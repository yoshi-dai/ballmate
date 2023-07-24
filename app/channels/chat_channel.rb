class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel_#{params['matching']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    message = Message.create! text: data['message'], user_id: current_user.id, matching_id: params['matching']
    ActionCable.server.broadcast("chat_channel_#{message.matching_id}", { message: render_message(message) , messageother: render_messageother(message), message_user: current_user.id})
  end

  def delete_message(data)
    message = Message.find_by(id: data['message_id'])
    return unless message

    message.destroy!

    ActionCable.server.broadcast("chat_channel_#{params['matching']}", { message_id: data['message_id'], action: 'delete_message' })
  end

  private
  def render_message(message)
    ApplicationController.renderer.render(
      partial: 'messages/messagecurrent',
      locals: { message: message, current_user: current_user }
    )
  end

  def render_messageother(message)
    ApplicationController.renderer.render(
      partial: 'messages/messageother',
      locals: { message: message, current_user: current_user }
    )
  end
end
