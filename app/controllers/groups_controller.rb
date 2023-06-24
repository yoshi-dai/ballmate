class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    # ユーザーがグループを作成した場合
    if @group.save
      @group.users << current_user
      redirect_to group_path(@group), notice: 'グループを作成しました。'
    else
      render :new
    end
  end
end
