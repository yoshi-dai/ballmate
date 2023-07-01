class GroupsController < ApplicationController
  def new
    @group = Group.new
    @users = User.where.not(id: current_user.id).includes(:user_profile).where(id: current_user.personal_matchings.map(&:users).flatten.uniq)
  end

  def create
    group = Group.new(name: params[:name])
    group.users << current_user
    group.users << User.where(id: params[:group][:user_ids])
    if group.save
      @matching = Matching.create(name: group.name, group_id: group.id, public_flag: false)
      @matching_profile = MatchingProfile.create(matching_id: @matching.id)
      redirect_to matching_profile_path(@matching_profile), notice: 'マッチングプロフィールが作成されました。'
    else
      render :new
    end
  end

  def leave
    group = Matching.find(params[:id]).group
    current_user.delete_approved_chat_request_for_matching(group) # マッチングに対するチャットリクエストを削除する
    group.users.delete(current_user)
    group.destroy_if_empty # グループが空になったら削除する
    redirect_to matchings_path, notice: 'グループから退出しました。'
  end

  private

  def group_params
    params.require(:group).permit(:name, user_ids: [])
  end
end
