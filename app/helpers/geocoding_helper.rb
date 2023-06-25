module GeocodingHelper
  require 'net/http'
  require 'json'

  def geocode(address, api_key)
    base_url = 'https://maps.googleapis.com/maps/api/geocode/json'
    encoded_address = URI.encode_www_form_component(address)
    url = "#{base_url}?address=#{encoded_address}&key=#{api_key}"

    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    if data['status'] == 'OK'
      result = data['results'][0]
      location = result['geometry']['location']
      latitude = location['lat']
      longitude = location['lng']

      [latitude, longitude]
    else
      # エラーハンドリング
      puts "Geocoding error: #{data['status']}"
      nil
    end
  end
end
