class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast("chat_channel_#{message.matching_id}", { message: render_message(message, message.user) })
  end

  private

  def render_message(message, _current_user)
    ApplicationController.renderer.render(
      partial: 'messages/message',
      locals: { message:, current_user: message.user }
    )
  end
end
