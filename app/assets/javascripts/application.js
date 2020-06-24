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

  	$(document).on('click', '.buy_now', function() {
  		var domain = $(this).data('domain')
  		var period = $('#duration_' + $(this).data('counter')).val()

  		$('#confirmModal').modal('show')
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
  			alert(data)
  		})

  	})
});
