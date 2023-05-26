class MatchingsController < ApplicationController
  require_relative '../services/weather_service'

  def index
    excluded_matchings_ids = [
      current_user.matchings.pluck(:id),
      current_user.sent_chat_requests.where(status: 'pending').pluck(:matching_id), # 申請済みのマッチング
    ].flatten.uniq
    @matchings = Matching.where(public_flag: 1).where.not(id: excluded_matchings_ids)
  end

  def show
    @matching = Matching.includes(:matching_profile).find(params[:id])
    @user = @matching.users.includes(:user_profile).where.not(id: current_user.id).first
    weather_service = WeatherService.new(ENV['OPEN_WEATHER_MAP_API_KEY'])
    @weather_data = weather_service.get_weather(@matching.place)
  end

  def edit
    @matching = Matching.find(params[:id])
    @user = @matching.users.includes(:user_profile).where.not(id: current_user.id).first
    weather_service = WeatherService.new(ENV['OPEN_WEATHER_MAP_API_KEY'])
    @weather_data = weather_service.get_weather(@matching.place)
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
    @matchings = current_user.matchings.includes(:matching_profile)
    render 'matchings/index'
  end
  
  def requested_matchings
    @chat_requests = current_user.sent_chat_requests.includes(matching: :matching_profile).where(status: 'pending')
    @matchings = @chat_requests.map(&:matching).compact.flatten.reject { |matching| matching == current_user }
    render 'matchings/index'
  end
  
  def approval_pending_matchings
    @chat_requests = ChatRequest.includes(matching: :matching_profile).where(matching: current_user.matchings, status: 'pending')
    @matchings = @chat_requests.map(&:matching).compact.uniq.flatten.reject { |user| user == current_user }
    render 'matchings/index'
  end


  private

  def matching_params
    params.require(:matching).permit(:name , :date, :time_zone, :place, :public_flag)
  end
end
