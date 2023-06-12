import consumer from "./consumer"

const chatChannel = consumer.subscriptions.create("ChatChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    return $('#messages').append(data['message']);
  },

  speak: function(message) {
    return this.perform('speak', {message: message});
  }
});

$(document).on('keypress', '[data-behavior~=room_speaker]', function(event) {
  if (event.key === 'Enter') {
    const text = event.target.value;
    const matchingId = document.getElementById('matching_id').value;
    chatChannel.speak({ text: text, matching_id: matchingId });
    event.target.value = '';
    event.preventDefault();
  }
});