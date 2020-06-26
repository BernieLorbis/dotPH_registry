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
//= require jquery3
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require_tree .


$(document).ready(function() {

  	$('form').on("ajax:success", function(event, data, status, xhr){
    	$('#result').html(xhr.responseText);
  	});

    // global variables
    var domain = "";
    var period = 0;

  	$(document).on('click', '.buy_now', function() {
  		domain = $(this).data('domain')
  		period = $('#duration_' + $(this).data('counter')).val()

        $.post('/validateSession', function (data) {
            if (data == "true") {
                window.location.href = "/payment/?period=" + period + "&domain=" + domain + "";
            } else {
                $('#confirmModal').modal('show')
            }
        });
  	});

  	$(document).on('change', '.duration', function() {
  		var counter = $(this).data('counter')
  		var value = $(this).val()
  		var price = 35 * value

  		$('#price_' + counter).text(price + ".00")
  	});

  	$(document).on('submit', '.loginForm', function(event) {
  		event.preventDefault()
  		var formData = $(this).serialize()

  		$.post('/login', formData,
  		function (data) {
  			if (data.success) {
                $('#message').html('')
                $('.loginForm')[0].reset()
                // redirect to payment page
                window.location.href = "/payment/?period=" + period + "&domain=" + domain + "";
            } else {
                $('#message').html('<div class="alert alert-danger">'+ data.message +'</div>')
            }
  		}, 'json')
  	});

   $('.registerForm').on('submit', function(event) {
        event.preventDefault();
        var form_data = $(this).serialize()

        $.post('/register', form_data,
        function(data) {
            if (data.success) {
                $('.registerForm')[0].reset()
                if (confirm(data.message)) {
                    window.location.href = "/"
                }

                window.location.href = "/"
            }
        }, 'json');
   });

    $(document).on('click', '.myDomain', function() {
        $.post('/my-domains', function(data) {
            $('#result').html(data)
        });
    });

});
