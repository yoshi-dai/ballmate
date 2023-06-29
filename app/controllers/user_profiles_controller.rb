class UserProfilesController < ApplicationController
  before_action :set_user_profile, only: [:show, :edit, :update]
  before_action :set_favorite_soccer_activities, only: [:new, :edit]
  before_action :set_soccer_equipments, only: [:new, :edit]

  def new
    @user_profile = UserProfile.new
  end

  def create
    @user_profile = current_user.build_user_profile(user_profile_params)
    if @user_profile.save
      redirect_to user_profile_path(@user_profile), notice: 'ユーザープロフィールが作成されました。'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user_profile.update(user_profile_params)
      redirect_to @user_profile, notice: 'ユーザープロフィールが更新されました。'
    else
      render :edit
    end
  end

  private

  def set_user_profile
    @user_profile = current_user.user_profile
  end

  def set_favorite_soccer_activities
    @favorite_soccer_activities = FavoriteSoccerActivity.all
  end

  def set_soccer_equipments
    @soccer_equipments = SoccerEquipment.all
  end

  def user_profile_params
    params.require(:user_profile).permit(:name, :favorite_player, :position, :role_in_team, :age, :favorite_place, :available_time, :image, :image_cache, favorite_soccer_activity_ids: [], soccer_equipment_ids: [], available_day_of_week: [])
  end
end
