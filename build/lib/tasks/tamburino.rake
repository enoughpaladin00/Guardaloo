namespace :tamburino do
  desc "Sincronizza la programmazione dei cinema da Tamburino API"
  task sync_programmazione: :environment do
    puts "Avvio sincronizzazione programmazione cinema..."
    TamburinoService.sync_programmazione
    puts "Sincronizzazione completata!"
  end
end