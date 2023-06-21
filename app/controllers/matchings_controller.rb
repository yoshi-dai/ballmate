class MatchingsController < ApplicationController
  include GeocodingHelper
  require 'date'
  require_relative '../services/weather_service'

  def index
    excluded_matchings_ids = [
      current_user.matchings.pluck(:id),
      current_user.sent_chat_requests.where(status: 'pending').pluck(:matching_id), # 申請済みのマッチング
    ].flatten.uniq
    @q = Matching.includes(:matching_profile).ransack(params[:q])
    @matchings = @q.result(distinct: true).where(public_flag: 1).where.not(id: excluded_matchings_ids).page(params[:page])
  end

  def show
    @matching = Matching.includes(:matching_profile).find(params[:id])
    @user = @matching.users.includes(:user_profile).where.not(id: current_user.id).first
    @weather_data = fetch_weather_data(@matching.place, @matching.date)
  end

  def edit
    @matching = Matching.find(params[:id])
    @user = @matching.users.includes(:user_profile).where.not(id: current_user.id).first
    @weather_data = fetch_weather_data(@matching.place, @matching.date)
    @messages = @matching.messages.includes(:user).order(created_at: :asc)
  end

  def update
    @matching = Matching.find(params[:id])
    if @matching.update(matching_params)
      if params[:matching][:public_flag] == "1"
        @matching_profile = @matching.create_matching_profile
        redirect_to edit_matching_profile_path(@matching_profile.id)
      else
        redirect_to @matching
      end
    else
      render 'show'
    end
  end

  def matched_matchings
    @q = Matching.includes(:matching_profile).ransack(params[:q])
    @matchings = @q.result(distinct: true).where(id: current_user.matchings.pluck(:id)).page(params[:page])
    render 'matchings/index'
  end
  
  def requested_matchings
    @q = Matching.includes(:matching_profile).ransack(params[:q])
    @chat_requests = current_user.sent_chat_requests.includes(matching: :matching_profile).where(status: 'pending')
    @matchings = @q.result(distinct: true).where(public_flag: 1).where(id: @chat_requests.map(&:matching_id)).page(params[:page])
    render 'matchings/index'
  end
  
  def approval_pending_matchings
    @q = Matching.includes(:matching_profile).ransack(params[:q])
    @chat_requests = ChatRequest.includes(matching: :matching_profile).where(matching: current_user.matchings, status: 'pending')
    @matchings = @q.result(distinct: true).where(public_flag: 1).where(id: @chat_requests.map(&:matching_id)).page(params[:page])
    render 'matchings/index'
  end


  private

  def fetch_weather_data(place, date = nil)
    latitude, longitude = geocode(place, ENV['GOOGLE_MAPS_API_KEY'])
    return nil unless latitude && longitude
  
    weather_service = WeatherService.new(ENV['OPEN_WEATHER_MAP_API_KEY'])
  
    if date.nil?
      weather_service.get_weather_by_coordinates(latitude, longitude)
    else
      timestamp = DateTime.parse(date.to_s).to_i
      weather_service.get_weather_by_coordinates_and_date(latitude, longitude, timestamp)
    end
  end

  def matching_params
    params.require(:matching).permit(:name , :date, :time_zone, :place, :public_flag)
  end
end
