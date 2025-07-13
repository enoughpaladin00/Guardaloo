namespace :cinema do
  desc "Esporta la programmazione dei cinema nel database"
  task export_showtimes: :environment do
    require_relative "../../app/services/serp_api_client"

    puts "⏳ Recupero dei dati da SerpApi..."
    showtimes = SerpApiClient.search_cinema_programs

    puts "🧹 Pulizia delle vecchie programmazioni..."
    CinemaShowtime.delete_all

    puts "💾 Salvataggio nuovi dati..."
    showtimes.each do |giorno|
      day = giorno["day"]
      giorno["movies"].each do |film|
        name = film["name"]
        film["showing"].each do |proiezione|
          CinemaShowtime.create!(
            day: day,
            movie: name,
            show_type: proiezione["type"],
            show_times: proiezione["time"]
          )
        end
      end
    end

    puts "✅ Programmazione salvata con successo!"
  end
end
