class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params.merge(name: "Group-#{SecureRandom.hex(4)}"))

    if @group.save
      redirect_to groups_path, notice: 'グループを作成しました。'
    else
      render :new
    end
  end
end
