module GroupsHelper
  def create_matching(group)
    ActiveRecord::Base.transaction do
      matching = Matching.create(name: group.name, group_id: group.id, public_flag: false)
      @matching_profile = MatchingProfile.create(matching_id: matching.id)# マッチングプロフィール詳細画面に遷移するためのインスタンス変数
    end
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

  def leave_group(group)
    current_user.leave_group(group)
    group.destroy_if_empty # グループのユーザーが0人になったら削除する
  end
end
