namespace :tmdb do
  desc "Importa trending movies da TMDB"
  task import_trending_movies: :environment do
    require 'net/http'
    require 'json'

    api_key = ENV['TMDB_API_KEY'] || 'LA_TUA_API_KEY'  # meglio usare variabile d'ambiente

    url = URI("https://api.themoviedb.org/3/trending/movie/week?api_key=#{api_key}&language=it-IT")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    data['results'].each do |movie|
      # Controlla se esiste già per evitare duplicati
      existing = Movie.find_by(tmdb_id: movie['id'])
      next if existing

      Movie.create!(
        tmdb_id: movie['id'],
        title: movie['title'],
        overview: movie['overview'],
        release_date: movie['release_date']
      )
      puts "Importato: #{movie['title']}"
    end

    puts "Importazione completata!"
  end
end
