class MatchingProfilesController < ApplicationController
  def show
    @matching_profile = MatchingProfile.find(params[:id])
    @matching = @matching_profile.matching
    @messages = @matching.messages.includes(:user).order(created_at: :asc)
    @users = @matching.group.users.includes(:user_profile)
  end

  def edit
    @matching_profile = MatchingProfile.find(params[:id])
    @matching = @matching_profile.matching
  end

  def update
    @matching_profile = MatchingProfile.find(params[:id])
    if @matching_profile.update(matching_profile_params)
      redirect_to matching_profile_path(@matching_profile), notice: 'マッチングプロフィールが更新されました。'
    else
      render :edit
    end
  end

  def update_public_flag
    @matching_profile = MatchingProfile.find(params[:id])
    @matching_profile.matching.update(public_flag: params.dig(:matching_profile, :public_flag) == '1')
    respond_to do |format|
      format.html { redirect_to matching_profile_path(@matching_profile), notice: '公開設定が更新されました。' }
      format.js 
    end
  end
  
  private

  def matching_profile_params
    params.require(:matching_profile).permit(
      :activity_content,
      :activity_detail,
      :recruitment_content,
      :short_message,
      :image,
      :image_cache
    )
  end
end
