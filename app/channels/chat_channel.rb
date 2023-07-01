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

  def delete_message(data)
    message = Message.find_by(id: data['message_id'])
    return unless message

    message.destroy!

    ActionCable.server.broadcast("chat_channel_#{params['matching']}", { message_id: data['message_id'], action: 'delete_message' })
  end
end
