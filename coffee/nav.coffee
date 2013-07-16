###
#	Navigation pinning to the top
#	@file     nav.coffee
#	@author   Lukas Bestle <http://lu-x.me>
#	@created  16.07.2013 13:10
#	@updated  16.07.2013 13:10
###

$(document).ready(()->
	# Set the offset of the navigation on the page
	offsetTop = 238;
	
	# Function to check the current position
	navFix = ()->
		if($(window).width() <= 600)
			# On mobile devices, the navigation is not pinned
			return false;
		
		# Check whether it is on the screen
		if(-$('.wrapper').offset().top > offsetTop)
			$("nav").addClass("fixed");
		else
			$("nav").removeClass("fixed");
	
	# Check for a change when scrolling
	$('body').scroll(navFix);
	
	# Check once when loading the page
	navFix();
);