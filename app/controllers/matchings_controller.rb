class MatchingsController < ApplicationController
  def index
    excluded_matchings_ids = [
      current_user.matchings.pluck(:id)
    ].flatten.uniq
    @matchings = Matching.where.not(id: excluded_matchings_ids)
  end

  def show
    @matching = Matching.includes(:matching_profile).find(params[:id])
    @user = @matching.users.includes(:user_profile).where.not(id: current_user.id).first
  end

  def edit
    @matching = Matching.find(params[:id])
    @user = @matching.users.includes(:user_profile).where.not(id: current_user.id).first
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
    @chat_requests = current_user.sent_chat_requests.includes(receiver: :user_profile).where(status: 'pending')
    @matchings = @chat_requests.map(&:receiver).compact.flatten.reject { |user| user == current_user }
    render 'matchings/index'
  end
  
  def approval_pending_matchings
    @chat_requests = current_user.received_chat_requests.includes(sender: :user_profile).where(status: 'pending')
    @matchings = @chat_requests.map(&:sender).compact.flatten.reject { |user| user == current_user }
    render 'matchings/index'
  end


  private

  def matching_params
    params.require(:matching).permit(:name , :date, :time_zone, :place, :public_flag)
  end
end
