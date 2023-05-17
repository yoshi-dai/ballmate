class MatchingProfilesController < ApplicationController
  def show
    @matching_profile = MatchingProfile.find(params[:id])
    @matching = @matching_profile.matching
  end
  
  def edit
    @matching_profile = MatchingProfile.find(params[:id])
    @matching = @matching_profile.matching
  end

  def update
    @matching_profile = MatchingProfile.find(params[:id])
    @matching = @matching_profile.matching
    if @matching.update(matching_params) && @matching_profile.update(matching_profile_params)
      redirect_to matchings_path, notice: 'マッチングプロフィールが更新されました。'
    else
      render :edit
    end
  end

  private

  def matching_profile_params
    params.require(:matching).permit(
      matching_profile_attributes: [:activity_content, :activity_detail, :recruitment_content, :short_message, :image]
    )
  end

  def matching_params
    params.require(:matching).permit(:name, :date, :time_zone, :place)
  end
end


