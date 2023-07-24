import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const chatChannel = consumer.subscriptions.create(
    { 
      channel: "ChatChannel",
      matching: $('#messages').data('matching_id'),
      current_user_id: $('#messages').data('current_user_id')
    }, 
    {

      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        if (data.action === 'delete_message') {
          $(`#message-${data.message_id}`).remove();
        } else {
          const showUser = $('#show_user').data('show_user');
          if (data['message_user'] === showUser) {
            $('#messages').append(data.message);
            scrollChatToBottom();
          } else {
            $('#messages').append(data.messageother);
            scrollChatToBottom();
          }   
        }
      },

      speak: function(message) {
        return this.perform('speak', { message: message });
      },
      
      deleteMessage(messageId) {
        return this.perform('delete_message', { message_id: messageId });
      }
    }
  );

  function scrollChatToBottom() {
    const chatContainer = document.getElementById('messages');
    if (chatContainer) {
      chatContainer.scrollTop = chatContainer.scrollHeight;
    }
  }

  $(document).on('keypress', '[data-behavior~=room_speaker]', function(event) {
    if (event.key === 'Enter') {
      chatChannel.speak(event.target.value);
      event.target.value = '';
      event.preventDefault();
    }
  });

  $(document).on('click', '.delete-message', function() {
    const messageId = $(this).data('message-id');
    chatChannel.deleteMessage(messageId);
  });

  scrollChatToBottom();
});
