require 'open_weather_map/version'
require 'open_weather_map/base'

module OpenWeatherMap
  class City < Base
    def initialize(country, city)
      params = { q: "#{country},#{city}" }
      @response = request params
    end

  end

  class Geocode < Base
    def initialize(lat, lon)
      params = { lat: lat, lon: lon }
      @response = request params
    end

  end
end
