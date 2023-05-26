require 'rest_client'
module OpenWeatherMap
  URL = 'http://api.openweathermap.org/data/2.5/weather'
  class Base

    def cond
      @response['weather'][0]['main']
    end

    def temp_min
      @response['main']['temp_min']
    end

    def temp_max
      @response['main']['temp_max']
    end

    def cond_jp
      jp_cond = ''
      case @response['weather'][0]['main']
      when 'Clear' then jp_cond = '晴れ'
      when 'Clouds' then jp_cond = '曇り'
      when 'Snow' then jp_cond = '雪'
      when 'Rain' then jp_cond = '雨'
      else jp_cond = 'その他'
      end

      return jp_cond
    end

    def temp_min_celsius
      to_celsius @response['main']['temp_min']
    end

    def temp_max_celsius
      to_celsius @response['main']['temp_max']
    end

    private
    def request(params)
      response = RestClient.get OpenWeatherMap::URL, { params: params }
      JSON.parse(response)
    end

    def to_celsius(temp)
      (temp.to_f - 273.15).round(1)
    end

  end
end

