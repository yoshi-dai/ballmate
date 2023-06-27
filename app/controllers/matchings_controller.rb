class MatchingsController < ApplicationController
  include GeocodingHelper
  require 'date'
  require_relative '../services/weather_service'

  def index
    excluded_matchings_ids = [
      current_user.matchings.pluck(:id), # 承認済みのマッチング
      current_user.sent_chat_requests.where(status: 'pending').pluck(:matching_id) # 申請済みのマッチング
    ].flatten.uniq
    @q = Matching.includes(:matching_profile, :group).ransack(params[:q])
    @matchings = @q.result(distinct: true).where(public_flag: 1).where.not(id: excluded_matchings_ids).page(params[:page])
  end

  def show
    @matching = Matching.find(params[:id])
    @user = @matching.users.where.not(id: current_user.id).first
    @messages = @matching.messages.includes(:user).order(created_at: :asc)
  end

  def edit
    @matching = Matching.find(params[:id])
    @user = @matching.users.where.not(id: current_user.id).first
  end

  def update
    @matching = Matching.find(params[:id])
    if @matching.update(matching_params)
      redirect_to @matching, notice: 'success'
    else
      render 'show'
    end
  end

  def matched_matchings
    @q = Matching.includes(:matching_profile, :group).ransack(params[:q])
    @matchings = @q.result(distinct: true)
                    .where(id: current_user.matchings.pluck(:id))
                    .where.not(id: current_user.personal_matchings.pluck(:id).uniq)
                    .page(params[:page])
    render 'matchings/index'
  end

  def requested_matchings
    @q = Matching.includes(:matching_profile, :group).ransack(params[:q])
    @chat_requests = current_user.sent_chat_requests.includes(matching: :matching_profile).where(status: 'pending')
    @matchings = @q.result(distinct: true).where(public_flag: 1).where(id: @chat_requests.map(&:matching_id)).page(params[:page])
    render 'matchings/index'
  end

  def approval_pending_matchings
    @q = Matching.includes(:matching_profile, :group).ransack(params[:q])
    @chat_requests = ChatRequest.includes(matching: :matching_profile).where(matching: current_user.matchings, status: 'pending')
    @matchings = @q.result(distinct: true).where(public_flag: 1).where(id: @chat_requests.map(&:matching_id)).page(params[:page])
    render 'matchings/index'
  end

  private

  def fetch_weather_data(place, date = nil)# これは、天気情報を取得するためのメソッド(仮)です 
    latitude, longitude = geocode(place, ENV.fetch('GOOGLE_MAPS_API_KEY', nil))
    return nil unless latitude && longitude

    weather_service = WeatherService.new(ENV.fetch('OPEN_WEATHER_MAP_API_KEY', nil))

    if date.nil?
      weather_service.get_weather_by_coordinates(latitude, longitude)
    else
      timestamp = DateTime.parse(date.to_s).to_i
      weather_service.get_weather_by_coordinates_and_date(latitude, longitude, timestamp)
    end
  end

  def matching_params
    params.require(:matching).permit(:name, :date, :time_zone, :place, :public_flag)
  end
end
