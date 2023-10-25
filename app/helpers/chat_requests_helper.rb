module ChatRequestsHelper
  def create_user_chat_request
    @chat_request = ChatRequest.new(sender_id: current_user.id, receiver_id: params[:chat_request][:receiver_id], status: :pending)
    @chat_request.save
    current_user.create_notification_chat_request!(current_user, @chat_request)
    true
  end

  def create_matching_chat_request
    matching = Matching.find(params[:matching_id])
    @chat_request = ChatRequest.new(sender_id: current_user.id, matching_id: matching.id, status: :pending)
    @chat_request.save
    matching.create_notification_matching!(current_user, matching)
    true
  end

  def create_personal_matching(chat_request)
    matching = nil
    ActiveRecord::Base.transaction do
      begin
        chat_request.update(status: 'approved')
        group = Group.create(name: "Group-#{SecureRandom.hex(4)}")
        group.users << current_user
        group.users << chat_request.sender
        matching = Matching.create(name: group.name, group_id: group.id, public_flag: false)
        matching.users << current_user
        matching.users << chat_request.sender
        current_user.create_notification_approve_chat_request!(current_user, chat_request)
      rescue StandardError => e
        raise ActiveRecord::Rollback, e
      end
    end
    matching
  end

  def add_sender_to_group_matching(chat_request, matching)
    group = Group.find(matching.group_id)
    group.users << chat_request.sender
    chat_request.destroy!
    matching.create_notification_approve_matching!(current_user, matching)
    true
  end

  def cancel_user_chat_request(chat_request)
    begin
      ActiveRecord::Base.transaction do
        current_user.destroy_notification_chat_request!(current_user, chat_request)
        chat_request.destroy!
      end
      true
    rescue StandardError => e
      Rails.logger.error("An error occurred: #{e.message}")
      false
    end
  end

  def cancel_matching_chat_request(chat_request, matching)
    begin
      ActiveRecord::Base.transaction do
        matching.destroy_notifications_matching!(current_user, matching)
        chat_request.destroy!
      end
      true
    rescue StandardError => e
      Rails.logger.error("An error occurred: #{e.message}")
      false
    end
  end

  def reject_user_chat_request(chat_request)
    chat_request.destroy!
    true
  end
end
