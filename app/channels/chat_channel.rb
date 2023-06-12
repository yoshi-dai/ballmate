class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create! text: data['message']['text'], user_id: current_user.id, matching_id: data['message']['matching_id']
  end
end
