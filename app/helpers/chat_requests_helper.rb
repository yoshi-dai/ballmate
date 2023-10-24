module ChatRequestsHelper
  def create_user_chat_request
    @chat_request = ChatRequest.new(sender_id: current_user.id, receiver_id: params[:chat_request][:receiver_id], status: :pending)
    if @chat_request.save
      current_user.create_notification_chat_request!(current_user, @chat_request)
      redirect_to users_path, success: t('.success')
    else
      @users = User.where.not(id: User.matched(current_user).pluck(:id)).includes(:user_profile)
      flash.now[:warning] = t('.failure')
      render 'users/index'
    end
  end

  def create_matching_chat_request
    matching = Matching.find(params[:matching_id])
    @chat_request = ChatRequest.new(sender_id: current_user.id, matching_id: matching.id, status: :pending)
  
    if @chat_request.save
      matching.create_notification_matching!(current_user, matching)
      redirect_to matchings_path, success: t('.success')
    else
      redirect_to matchings_path, warning: t('.failure')
    end
  end

  def handle_user_approval(sender_id)
    chat_request = current_user.received_chat_requests.find_by(sender_id: sender_id, status: 'pending')
    matching = nil
  
    return redirect_to users_path, warning: t('.failure') unless chat_request
  
    ActiveRecord::Base.transaction do
      chat_request.update(status: 'approved')
      matching = create_group_and_matching(chat_request)
    end
  
    redirect_to matching_path(matching), success: t('.success')
  end

  def handle_matching_approval(user_id, matching_id)
    matching = Matching.find(matching_id)
    chat_request = current_user.matchings.find(matching_id).received_chat_requests.find_by(matching_id: matching_id, sender_id: user_id, status: 'pending')
  
    return redirect_to matching_profile_path(matching.matching_profile), success: t('.success')unless chat_request
  
    ActiveRecord::Base.transaction do
      add_sender_to_matching(chat_request, matching)
      chat_request.destroy!
      matching.create_notification_approve_matching!(current_user, matching)
    end
  
    redirect_to matching_profile_path(matching.matching_profile), success: t('.success')
  end

  def create_group_and_matching(chat_request)
    matching = nil
    ActiveRecord::Base.transaction do
      group = Group.create(name: "Group-#{SecureRandom.hex(4)}")
      group.users << current_user
      group.users << chat_request.sender
      matching = Matching.create(name: group.name, group_id: group.id, public_flag: false)
      matching.users << current_user
      matching.users << chat_request.sender
      current_user.create_notification_approve_chat_request!(current_user, chat_request)
    end
    matching
  end

  def add_sender_to_matching(chat_request, matching)
    group = Group.find(matching.group_id)
    group.users << chat_request.sender
  end

end
