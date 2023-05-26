require 'httparty'

class WeatherService
  include HTTParty
  base_uri 'http://api.openweathermap.org'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_weather(city)
    response = self.class.get("/data/2.5/weather", query: { q: city, appid: @api_key })
    response.parsed_response
  end
end