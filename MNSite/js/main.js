var Main = {

	windowData: {
		windowWidth: 0,
		windowHeight: 0,
		isLandscapeView: false
	},

	init: function ()
	{
		$.proxy (this.initVideoPlayer, this);
		$.proxy (this.initPhotoViewer, this);
		$.proxy (this.initPageSelector, this);
		$.proxy (this.initLayout, this);

		this.initVideoPlayer ();
		this.initPhotoViewer ();
		this.initPageSelector ();
		this.initLayout ();
	},


	initVideoPlayer: function ()
	{
		this.reelVideoPlayer = _V_ ('reelVideoPlayer');
		/*_V_('reelVideoPlayer').ready(function() {
		 //var myPlayer = this; //myPlayer.play();
		 console.log ('reelvideoplayer ready');
		 });*/
	},


	initPhotoViewer: function ()
	{
		$ ('#photos').responsiveSlides ({
			auto: false,
			fade: 500,
			nav: true,
			pager: true,
			prevText: '<',
			nextText: '>',
			manualControls: '#photos-pager'
		});
	},


	initPageSelector: function ()
	{
		$.hideAllExcept ('.tab', '.box', $.proxy (this.onPageChange, this));
	},


	onPageChange: function (pageID)
	{

		console.log ('onPageChange:', this, this.reelVideoPlayer);

		if (pageID !== '#reel')
		{
			this.reelVideoPlayer.pause ();
		}
		else
		{
			if (this.reelVideoPlayer.currentTime () !== 0)
			{
				this.reelVideoPlayer.currentTime (0);
				this.reelVideoPlayer.play ();
			}
		}
	},


	initLayout: function ()
	{
		$ ('#main').bind ('updateLayout', $.proxy(this.updateLayout, this));

		$ (window).bind ('load resize orientationchange', function () {
			$ ('#main').trigger ('updateLayout');
		});

		this.updateLayout ();
	},


	updateLayout: function ()
	{
//		console.log('body scroll height:', $('body')[0].scrollHeight);
		this.windowData.windowWidth = $ (window).width();
		this.windowData.windowHeight = $ (window).height();
		this.windowData.isLandscapeView = (Math.max(this.windowData.windowWidth, this.windowData.windowHeight) === this.windowData.windowWidth);
		
		// find largest side
		
		/*var emsWidth = 0;
		if (this.windowData.windowWidth > this.windowData.windowHeight)
		{
			emsWidth = this.windowData.windowHeight / 16.0;
			$ ("body").css ("font-size", (emsWidth / 40.1) + "em");
		}
		else
		{
			emsWidth = this.windowData.windowWidth / 16.0;
			$ ("body").css ("font-size", (emsWidth / 64.2) + "em");
		}*/


		if (this.windowData.windowWidth/16.0 < 64.2)
		{
			var emsWidth = this.windowData.windowWidth / 16.0;
			$ ("body").css ("font-size", (emsWidth / 64.2) + "em");
		}
		else
		{
			$ ("body").css ("font-size", "1.0em");
		}
		
		
		
		
//		$ ('#main').height (this.windowData.windowHeight - $ ('#siteHeader').outerHeight () - 32);
//		$ ('.pageContent').width ($ ('#main').width ());
//		$ ('.pageContent').height ($ ('#main').innerHeight());

		/*var updatedHeight;
		if (windowHeight > 240)
		{
			updatedHeight = windowHeight - $ ('#siteHeader').outerHeight () - 32;
		}
		else
		{
			updatedHeight = 240 - $ ('#siteHeader').outerHeight () - 24;
		}
		$ ('#main').height (updatedHeight);
		 $ ('.pageContent').width ($ ('#main').width ());
		 $ ('.pageContent').height (updatedHeight);*/
//		font-size: 1em;
//		$ ("body").css ("font-size", "1.2em");
	},
	
	
	reelVideoPlayer: null
};