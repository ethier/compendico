// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require cocoon
//= require awesomplete/awesomplete.min.js
//= require_tree .

$(function () {
  document.addEventListener('turbolinks:load', function () {
    if ($('.awesomplete-from-email').length > 0) {
      var from_email = $('.awesomplete-from-email')[0];

      var a = new Awesomplete(from_email, {
        minChars: 3,
        replace: function (suggestion) {
          $('#compendico_digest_from_email_id').val(suggestion.value);
          this.input.value = suggestion.label;
        }
      });

      from_email.oninput = () => {
        $.ajax({
          type: 'get',
          dataType: 'json',
          url: from_email.dataset.url,
          data: {
            q: from_email.value
          },
          cache: false,
          success: function (data) {
            console.log(data);
            a.list = data.emails;
            a.evaluate();
          }
        });
      };
    }

    // Get all "navbar-burger" elements
    var $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

    // Check if there are any navbar burgers
    if ($navbarBurgers.length > 0) {
      // Add a click event on each of them
      $navbarBurgers.forEach(function ($el) {
        $el.addEventListener('click', function () {

          // Get the target from the "data-target" attribute
          var target = $el.dataset.target;
          var $target = document.getElementById(target);

          // Toggle the class on both the "navbar-burger" and the "navbar-menu"
          $el.classList.toggle('is-active');
          $target.classList.toggle('is-active');
        });
      });
    }

    $('#api-key-button').on('click', function (event) {
      $(event.target).html($('#api-key-content').html());
      event.stopPropagation();
    });

    function box_radio_click(target) {
      target.parent().find('.box-radio').css('background-color', '#fff');

      target.find('.radio:first').prop('checked', true);
      target.css('background-color', '#f5f5f5');
    }

    $('.box-radio p').on('click', function (event) {
      $target = $(event.target).parent('label');

      event.stopPropagation();

      box_radio_click($target);
    });

    $('.box-radio').on('click', function (event) {
      $target = $(event.target);

      box_radio_click($target);
    });

    $('.box-radio input:radio:checked').each(function () {
      box_radio_click($(this).parent('label'));
    });

    $(document).on('click', '.notification > button.delete', function () {
      $(this).parent().addClass('is-hidden');
      return false;
    });

    $('#compendico_template_category').on('change', function() {
      var markup_input = $('#compendico_template_markup');
      var existing_val = markup_input.val();

      var message_var = '{{ message }}';
      var digest_var = '{{ digest }}';

      if ($(this).val() == 'digest') {
        if (existing_val.indexOf(message_var) > -1) {
          markup_input.val(existing_val.replace(message_var, ''));
        }

        if (existing_val.indexOf(digest_var) == -1) {
          markup_input.val(existing_val + digest_var);
        }
      }

      if ($(this).val() == 'message') {
        if (existing_val.indexOf(digest_var) > -1) {
          markup_input.val(existing_val.replace(digest_var, ''));
        }

        if (existing_val.indexOf(message_var) == -1) {
          markup_input.val(existing_val + message_var);
        }
      }
    });
  });
});
