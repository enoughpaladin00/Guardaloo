=begin class CinemasController < ApplicationController
  def index
    @cinemas = TamburinoService.fetch_programmazione
  end
end
=end
class CinemasController < ApplicationController
  def index
    id_servizio = 347  # il servizio che ti restituisce l’elenco dei cinema
    @cinemas = TamburinoService.get_programmazione(id_servizio, apikey: ENV['TAMBURINO_APIKEY'], format: 'xml') || []
  end
end
