class GroupsController < ApplicationController
  before_action :load_users, only: [:new, :create]
  before_action :set_group, only: [:create]
  
  def new
    @group = Group.new
  end

  def create
    if create_group
      redirect_to matching_profile_path(@matching_profile), success: t('.success')
    else
      flash.now[:error] = t('.failure')
      render :new
    end
  end
  
  def leave
    group = Matching.find(params[:id]).group
    current_user.leave_group(group)
    group.destroy_if_empty # グループのユーザーが0人になったら削除する
    redirect_to matched_matchings_path, success: t('.success')
  end

  private

  def load_users
    @users = User.matched(current_user)
  end

  def set_group
    @group = Group.new(name: params[:name])
  end

  def create_group
    if @group.save
      add_users(@group)
      create_matching(@group)
      true
    else
      false
    end
  end

  def add_users(group)
    ActiveRecord::Base.transaction do
      group.users << current_user
      group.users << User.where(id: params[:group][:user_ids])
    end
  end
  
  def create_matching(group)
    ActiveRecord::Base.transaction do
      matching = Matching.create(name: group.name, group_id: group.id, public_flag: false)
      @matching_profile = MatchingProfile.create(matching_id: matching.id)# マッチングプロフィール詳細画面に遷移するためのインスタンス変数
    end
  end

  def group_params
    params.require(:group).permit(:name, user_ids: [])
  end
end
