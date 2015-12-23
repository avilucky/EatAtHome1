// This jquery script runs on every page-- it is used to provide some basic
// styling on widgets and buttons.

function configureSlides(width, height, selector) {
	if ($(selector).length>0 && $(".slide_wrapper").length>1) {
		$(selector).slidesjs({
        	width: width,
        	height: height
      	});
      $(".slidesjs-next").html('<span class="ui-icon ui-icon-carat-1-e"></span>');
      $(".slidesjs-previous").html('<span class="ui-icon ui-icon-carat-1-w"></span>');
      $(".slidesjs-pagination").hide();
	}
	if ($(".image_wrapper").length==1) {
		$(selector).css("display", "block")
	}
}


$(document).on('ready page:load', function(event) {
  $(document).ready(function() {
    stylePage();
    
    $("#addFIPortion").click(function () {
    	var counter = $('#Portions div').length + 1;
	    if(counter>5){
            displayError("No more than 5 portions allowed");
            return false;
	    }   
	    clearErrors();
		
	    var newPortionDiv = $(document.createElement('div'))
	        .attr("id", 'Portion' + counter);
                
	    newPortionDiv.after().html('<input type="hidden" name="food_items[portion_id[' + (counter-1) + ']]' +
			'" id="food_items_portion_id[' + (counter-1) + ']" value="" >' +
	    	'<label for="food_items_p">Portion # '+ counter + ' : </label>' +
	        '<input type="text" name="food_items[portion[' + (counter-1) + ']]' +
	        '" id="food_items_portion[' + (counter-1) + ']" value="" >' + '&nbsp;' +
	        '<label name="food_items_p">Price : </label>' +
	        '<input type="text" name="food_items[price[' + (counter-1) + ']]' +
	        '" id="food_items_price[' + (counter-1) + ']" value="" >'
	        );
            
	    newPortionDiv.appendTo("#Portions");
    });

    $("#removeFIPortion").click(function () {
	    var counter = $('#Portions div').length + 1;
	    if(counter <= 2){
            displayError("At least one portion required");
            return false;
        }
		clearErrors();
        $("#Portion" + (counter-1)).remove();	
    });
    
    if($('#order_food_item_portion').length){
		changePrice($('#order_food_item_portion').val(), JSON.parse($('#myfiportions').text()));
	}
  });
});

$(document).on('change', 'select[id="order_food_item_portion"]', function(sel){
		if($('#order_food_item_portion').length){
		    changePrice($(this).val(), JSON.parse($('#myfiportions').text()));
		}
});

function stylePage() {
    $(":button").button()
    $("input[type='submit']").button()
    $( "#tabs" ).tabs();
    configureSlides(300,300, "#slides")
    configureSlides(100,100, "#slides_user")
}

// Given a string, displays the string as an error in the header.
function displayError(err) {
    clearErrors();
    $("#message_header").append("<div id='message_box' class='ui-state-error ui-corner-all'><p>"+err+"</p></div>");
}

// Removes the error displayed in the header
function clearErrors() {
    $("#message_box").remove();
}

function changePrice(food_item_portion_id, food_items_portions){
	$.each(food_items_portions, function(key, value){
		if(value['id'] == food_item_portion_id){
			$('#fooditemportionprice').text(value['price']);
			return false;
		}
	});
}