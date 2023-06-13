class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel_#{params['matching']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create! text: data['message'], user_id: current_user.id, matching_id: params['matching']
  end
end
