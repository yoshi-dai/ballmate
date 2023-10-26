class GroupsController < ApplicationController
  include GroupsHelper
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
    leave_group(group)
    redirect_to matched_matchings_path, success: t('.success')
  end

  private

  def load_users
    @users = User.matched(current_user)
  end

  def set_group
    @group = Group.new(name: params[:name])
  end

  def group_params
    params.require(:group).permit(:name, user_ids: [])
  end
end
