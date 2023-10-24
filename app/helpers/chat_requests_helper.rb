module ChatRequestsHelper
  def create_user_chat_request
    @chat_request = ChatRequest.new(sender_id: current_user.id, receiver_id: params[:chat_request][:receiver_id], status: :pending)
    @chat_request.save
    current_user.create_notification_chat_request!(current_user, @chat_request)
  end

  def create_matching_chat_request
    matching = Matching.find(params[:matching_id])
    @chat_request = ChatRequest.new(sender_id: current_user.id, matching_id: params[:matching_id].to_i, status: :pending)
    @chat_request.save
    matching.create_notification_matching!(current_user, matching)
  end
end
