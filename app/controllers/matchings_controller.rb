class MatchingsController < ApplicationController
  include MatchingsHelper
  include GeocodingHelper
  require 'date'
  require_relative '../services/weather_service'

  before_action :set_matching, only: %i[show edit update destroy]
  before_action :set_q, only: %i[index matched_matchings requested_matchings approval_pending_matchings]
  before_action :set_other_user, only: %i[show edit]

  def index
    @matchings = @q.result(distinct: true).where(public_flag: 1).where.not(id: excluded_matchings_ids).page(params[:page])
  end

  def show
    @messages = @matching.messages.includes(:user).order(created_at: :asc)
  end

  def edit; end

  def update
    if @matching.update(matching_params)
      redirect_to @matching, success: t('.success')
    else
      flash.now[:warning] = t('.failure')
      render 'show'
    end
  end

  def destroy
    delete_matching!(@matching)
    redirect_to matchings_path, success: t('.success')
  end

  def matched_matchings
    @matchings = @q.result(distinct: true)
      .where(id: current_user.matchings.pluck(:id))
      .where.not(id: current_user.personal_matchings.pluck(:id).uniq)
      .page(params[:page])
  end

  def requested_matchings
    @chat_requests = current_user.sent_chat_requests.includes(matching: :matching_profile).where(status: 'pending')
    @matchings = @q.result(distinct: true).where(public_flag: 1).where(id: @chat_requests.map(&:matching_id)).page(params[:page])
  end

  def approval_pending_matchings
    @chat_requests = ChatRequest.includes(matching: :matching_profile).where(matching: current_user.matchings, status: 'pending')
    @matchings = @q.result(distinct: true).where(public_flag: 1).where(id: @chat_requests.map(&:matching_id)).page(params[:page])
  end

  private

  def matching_params
    params.require(:matching).permit(:name, :date, :scheduled_time, :place, :public_flag)
  end
  
  def set_q
    @q = Matching.includes(:matching_profile, :group).ransack(params[:q])
  end

  def set_matching
    @matching = Matching.find(params[:id])
  end

  def set_other_user
    @user = other_user
  end

  def other_user
    @matching.users.where.not(id: current_user.id).first
  end

  def excluded_matchings_ids
    [
      current_user.matchings.pluck(:id), # 承認済みのマッチング
      current_user.sent_chat_requests.where(status: 'pending').pluck(:matching_id) # 申請済みのマッチング
    ].flatten.uniq
  end

  def fetch_weather_data(place, date = nil)
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
end
