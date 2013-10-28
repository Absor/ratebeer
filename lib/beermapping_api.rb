class BeermappingAPI
  def self.places_in(city)
    Place # varmistaa, että luokan koodi on ladattu
    city = city.downcase
    Rails.cache.write city, fetch_places_in(city), :expires_in => 1.hour if not Rails.cache.exist? city

    Rails.cache.read city
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{city.gsub(' ', '%20')}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.place_by(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/#{id}"
    response = HTTParty.get url
    place = response.parsed_response["bmp_locations"]["location"]
    Place.new(place)
  end

  def self.scores_by(id)
    url = "http://beermapping.com/webservice/locscore/#{key}/#{id}"
    response = HTTParty.get url
    scores = response.parsed_response["bmp_locations"]["location"]
    scores
  end

  def self.key
    Settings.beermapping_apikey
  end
end