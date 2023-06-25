class GroupsController < ApplicationController
  def new
    @group = Group.new
    @users = User.where.not(id: current_user.id).includes(:user_profile).where(id: current_user.personal_matchings.map(&:users).flatten.uniq)
  end

  def create
    group = Group.new(name: params[:name])
    group.users << current_user
    group.users << User.where(id: params[:group][:user_ids])
    binding.irb
    if group.save
      @matching = Matching.create(name: group.name, group_id: group.id)
      @matching_profile = MatchingProfile.new(matching_id: @matching.id)
      @matching_profile.save! # 例外処理は一旦省略
      redirect_to matching_profile_path(@matching_profile), notice: 'マッチングプロフィールが作成されました。'
    else
      render :new
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, user_ids: [])
  end
end
