###
#	AJAX stuff
#	@file     ajax.coffee
#	@author   Lukas Bestle <http://lu-x.me>
#	@created  16.07.2013 13:10
#	@updated  16.07.2013 13:10
###

$(document).ready(()->
	initialUrl = document.location.href;
	firstPopState = true;
	
	# Click handler
	loadFromLink = ()->
		if($(this).parents().hasClass('feed') || $(this).hasClass('file'))
			# Is a direct link to a file/feed
			return true;
		
		load($(this).attr('href'));
		
		# Don't reload
		return false;
	
	# Load new content
	load = (url)->
		# Don't load the same page again
		if(url == window.location.href)
			return;
		
		# Disable current page
		$('.main').css('opacity', 0);
		$('.active').removeClass('active');
		$('.open').removeClass('open');
		
		# Get the new content
		$.get(url, (result)->
			# Split between meta data and content
			elements = result.split("\nSEPARATOR----SEPARATOR\n");
			
			if(typeof elements[1] != 'string')
				# Redirect to destination
				url = elements[0].match(/Redirect: (.*)/);
				window.location = url[1];
				return;
			
			# Split meta data between title and navigation
			meta = elements[0].split("\n");
			title = meta[0];
			navi = meta[1].split(" || ");
			
			# Get the content
			html = elements[1];
			
			setTimeout(()->
				# Set title
				$('title').html(title);
				
				# Activate navigation
				$('nav a[href="' + navi[0] + '"]').addClass(navi[1]);
				
				# Add the page to the history
				history.pushState(null, null, url);
				
				# Set the content
				$('.main').html(html);
				$('.main').css('opacity', 1);
				
				# Update link handlers
				$('a[href^="' + location.protocol + '//' + location.hostname + '"]').unbind('click').click(loadFromLink);
			, 300);
		);
	
	# User clicks back/forward button
	$(window).on('popstate', (e)->
		if(document.location.href == initialUrl && firstPopState)
			# Page loads the first time
			firstPopState = false;
			return;
		
		# Load the page
		load(location.pathname + location.search);
	);
	
	# User clicks a link
	$('a[href^="' + location.protocol + '//' + location.hostname + '"]').click(loadFromLink);
);
