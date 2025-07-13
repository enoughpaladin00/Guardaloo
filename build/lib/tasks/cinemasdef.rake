namespace :cinemasdef do
  desc "Importa cinema da API Tamburino nella tabella cinemasdef"
  task import: :environment do
    require 'open-uri'
    require 'nokogiri'

    puts "Importazione in corso..."

    url = "https://rest.tamburino.it/api/v1/movietheaters/programming/347?apikey=VdMXyp8oqcXNPwfA&date=31-05-2025"
    xml = URI.open(url).read
    doc = Nokogiri::XML(xml)

    doc.xpath('//CONTENT_MOVIE_THEATERS/REFERENCES/REFERENCE').each do |ref|
      tamburino_id = ref.at_xpath('REFERENCE_ID')&.text&.to_i
      name         = ref.at_xpath('REFERENCE_NAME')&.text
      address      = ref.at_xpath('REFERENCE_ADDRESS/ADDRESS_STREET_NAME')&.text
      town         = ref.at_xpath('REFERENCE_TOWN/TOWN_NAME')&.text
      province     = ref.at_xpath('REFERENCE_TOWN/TOWN_PROVINCE_NAME')&.text
      phone        = ref.at_xpath('REFERENCE_TELEPHONES/REFERENCE_TELEPHONE/TELEPHONE_NUMBER')&.text
      lat          = ref.at_xpath('REFERENCE_GEOCODING/GEOC_Y')&.text&.to_f
      lon          = ref.at_xpath('REFERENCE_GEOCODING/GEOC_X')&.text&.to_f

      # crea o aggiorna cinema nella tabella
      Cinemasdef.find_or_create_by!(tamburino_id: tamburino_id) do |c|
        c.name     = name
        c.address  = address
        c.town     = town
        c.province = province
        c.phone    = phone
        c.lat      = lat
        c.lon      = lon
      end
    end

    puts "Importazione completata!"
  end
end
