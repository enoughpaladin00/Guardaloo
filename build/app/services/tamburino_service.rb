require "net/http"
require "uri"
require "nokogiri"

class TamburinoService
  BASE_URL = "https://rest.tamburino.it/api/v1/movietheaters/programming"
  API_KEY = ENV["TAMBURINO_API_KEY"]
  SERVICE_ID = "347"

  def self.get_programmazione(date: nil, days: 1, format: "xml")
    date ||= Date.today.strftime("%d-%m-%Y")
    uri = URI("#{BASE_URL}/#{SERVICE_ID}")
    params = { apikey: API_KEY, date: date, days: days, format: format }
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)
    return nil unless res.is_a?(Net::HTTPSuccess)

    if format == "xml"
      parse_xml(res.body)
    else
      JSON.parse(res.body)
    end
  rescue => e
    Rails.logger.error "Errore chiamando Tamburino API: #{e.message}"
    nil
  end

  def self.distance_km(lat1, lon1, lat2, lon2)
    rad_per_deg = Math::PI / 180
    rkm = 6371 # raggio medio della Terra in km

    dlat_rad = (lat2.to_f - lat1.to_f) * rad_per_deg
    dlon_rad = (lon2.to_f - lon1.to_f) * rad_per_deg

    lat1_rad = lat1.to_f * rad_per_deg
    lat2_rad = lat2.to_f * rad_per_deg

    a = Math.sin(dlat_rad / 2)**2 +
        Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad / 2)**2

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    rkm * c # distanza in km
  end

  def self.cinema_vicini(lat, lng, raggio_km: 20)
    tutti = get_programmazione
    return [] unless tutti

    tutti.select do |cinema|
      next unless cinema[:lat] && cinema[:lon]
      distanza = distance_km(lat, lng, cinema[:lat], cinema[:lon])
      distanza <= raggio_km
    end
  end



  def self.sync_programmazione
    cinemas = get_programmazione(format: "xml")
    return unless cinemas

    cinemas.each do |data|
      Cinema.find_or_initialize_by(name: data[:name]).tap do |cinema|
        cinema.name = data[:name]
        cinema.address = data[:address] + " " + data[:town]
        cinema.latitude = data[:lat]
        cinema.longitude = data[:lon]
        cinema.save!
      end
    end
  end



  def self.parse_xml(xml_body)
    doc = Nokogiri::XML(xml_body)
    cinemas = []
    doc.xpath("//CONTENT_MOVIE_THEATERS/REFERENCES/REFERENCE").each do |ref|
      cinemas << {
        id: ref.at_xpath("REFERENCE_ID")&.text,
        name: ref.at_xpath("REFERENCE_NAME")&.text,
        address: ref.at_xpath("REFERENCE_ADDRESS/ADDRESS_STREET_NAME")&.text,
        town: ref.at_xpath("REFERENCE_TOWN/TOWN_NAME")&.text,
        province: ref.at_xpath("REFERENCE_TOWN/TOWN_PROVINCE_NAME")&.text,
        phone: ref.at_xpath("REFERENCE_TELEPHONES/REFERENCE_TELEPHONE/TELEPHONE_NUMBER")&.text,
        lat: ref.at_xpath("REFERENCE_GEOCODING/GEOC_Y")&.text,
        lon: ref.at_xpath("REFERENCE_GEOCODING/GEOC_X")&.text
      }
    end
    cinemas
  end
end
