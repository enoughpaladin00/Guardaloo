module SearchHelper
  def extract_year(result)
    date = result["release_date"] || result["first_air_date"]
    date&.slice(0, 4)
  end
end
