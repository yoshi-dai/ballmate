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
        console.log(data['message']);
        return $('#messages').append(data['message']);
      },

      speak: function(message) {
        return this.perform('speak', {message: message});
      }
    }
  );

  $(document).on('keypress', '[data-behavior~=room_speaker]', function(event) {
    if (event.key === 'Enter') {
      chatChannel.speak(event.target.value);
      event.target.value = '';
      event.preventDefault();
    }
  });
});