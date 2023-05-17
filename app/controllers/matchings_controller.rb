class MatchingsController < ApplicationController
  def index
    @matchings = Matching.all
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
        redirect_to edit_matching_profile_path(@matching_profile)
      else
        redirect_to @matching
      end
    else
      render 'show'
    end
  end

  private

  def matching_params
    params.require(:matching).permit(:name , :date, :time_zone, :place, :public_flag)
  end
end
