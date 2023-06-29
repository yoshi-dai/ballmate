$(document).on('turbolinks:load', function() {
  $('#public-flag-checkbox').on('change', function() {
    $('#public-flag-submit').trigger('click');
  });
});