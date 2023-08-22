class GroupsController < ApplicationController
  def new
    @group = Group.new
    @users = User.where.not(id: current_user.id).includes(:user_profile).where(id: current_user.personal_matchings.map(&:users).flatten.uniq)
  end

  def create
    group = Group.new(name: params[:name])
    if group.save
      ActiveRecord::Base.transaction do
        group.users << current_user
        group.users << User.where(id: params[:group][:user_ids])
        matching = Matching.create(name: group.name, group_id: group.id, public_flag: false)
        @matching_profile = MatchingProfile.create(matching_id: matching.id)
      end
      redirect_to matching_profile_path(@matching_profile), success: t('.success')
    else
      @group = Group.new(name: params[:name])
      @users = User.where.not(id: current_user.id).includes(:user_profile).where(id: current_user.personal_matchings.map(&:users).flatten.uniq)
      flash.now[:error] = t('.failure')
      render :new
    end
  end

  def leave
    ActiveRecord::Base.transaction do
      group = Matching.find(params[:id]).group
      current_user.delete_approved_chat_request_for_matching(group) # マッチングに対するチャットリクエストを削除する
      group.users.delete(current_user)
      group.destroy_if_empty # グループが空になったら削除する
    end
    redirect_to matchings_path, success: t('.success')
  end

  private

  def group_params
    params.require(:group).permit(:name, user_ids: [])
  end
end
