=begin require 'httparty'
require 'nokogiri'

class TamburinoService
  BASE_URL = 'https://rest.tamburino.it/api/v1/movietheaters/programming'
  API_KEY = 'VdMXyp8oqcXNPwfA' # Tua API key
  SERVICE_ID = '347'           # ID del servizio attivo

  def self.fetch_programmazione
    url = "#{BASE_URL}/#{SERVICE_ID}?apikey=#{API_KEY}&format=json"
    response = HTTParty.get(url)
    if response.success?
      JSON.parse(response.body)
    else
      nil
    end
  end
end
=end
require 'net/http'
require 'uri'
require 'nokogiri'

class TamburinoService
  BASE_URL = 'https://rest.tamburino.it/api/v1/movietheaters/programming'

  def self.get_programmazione(id_servizio, apikey:, date: nil, days: 1, format: 'xml')
    date ||= Date.today.strftime('%d-%m-%Y')
    uri = URI("#{BASE_URL}/#{id_servizio}")
    params = { apikey: apikey, date: date, days: days, format: format }
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)
    return nil unless res.is_a?(Net::HTTPSuccess)

    if format == 'xml'
      parse_xml(res.body)
    else
      
    end
  rescue => e
    Rails.logger.error "Errore chiamando Tamburino API: #{e.message}"
    nil
  end


  

  def self.parse_xml(xml_body)
    doc = Nokogiri::XML(xml_body)
    cinemas = []
    doc.xpath('//CONTENT_MOVIE_THEATERS/REFERENCES/REFERENCE').each do |ref|
      cinemas << {
        id: ref.at_xpath('REFERENCE_ID')&.text,
        name: ref.at_xpath('REFERENCE_NAME')&.text,
        address: ref.at_xpath('REFERENCE_ADDRESS/ADDRESS_STREET_NAME')&.text,
        town: ref.at_xpath('REFERENCE_TOWN/TOWN_NAME')&.text,
        province: ref.at_xpath('REFERENCE_TOWN/TOWN_PROVINCE_NAME')&.text,
        phone: ref.at_xpath('REFERENCE_TELEPHONES/REFERENCE_TELEPHONE/TELEPHONE_NUMBER')&.text,
        lat: ref.at_xpath('REFERENCE_GEOCODING/GEOC_Y')&.text,
        lon: ref.at_xpath('REFERENCE_GEOCODING/GEOC_X')&.text
      }
    end
    cinemas
  end
end
