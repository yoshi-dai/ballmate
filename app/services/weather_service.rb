require 'httparty'

class WeatherService
  include HTTParty
  base_uri 'http://api.openweathermap.org'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_weather_by_coordinates(latitude, longitude)
    response = self.class.get("/data/2.5/weather", query: { lat: latitude, lon: longitude, appid: @api_key })
    response.parsed_response
  end

  def get_weather_by_coordinates_and_date(latitude, longitude, _timestamp)
    response = self.class.get("/data/2.5/forecast", query: { lat: latitude, lon: longitude, appid: @api_key })
    response.parsed_response
  end

  def temperature(city)
    response = get_weather(city)

    if response["cod"] == 200
      response["main"]["temp"]
    else
      handle_error(response)
      # エラーが発生した場合に適切なデフォルト値を返すか、例外を発生させるなど、
      # プログラムの要件に応じた処理を行ってください
      # 以下はデフォルト値を返す例です
      # return 0
    end
  rescue HTTParty::Error, SocketError => e
    handle_connection_error(e)
    # エラーが発生した場合に適切なデフォルト値を返すか、例外を発生させるなど、
    # プログラムの要件に応じた処理を行ってください
    # 以下はデフォルト値を返す例です
    # return 0
  end
end
