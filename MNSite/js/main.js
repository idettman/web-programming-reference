var Main = {

	windowData: { windowWidth: 0,windowHeight: 0,isLandscapeView: false },
	
	videoData: { width: 854, height: 480},
	
	init: function () {
		$.proxy (this.initVideoPlayer, this);
		$.proxy (this.initPhotoViewer, this);
		$.proxy (this.initPageSelector, this);
		$.proxy (this.initLayout, this);

		this.initVideoPlayer ();
		this.initPhotoViewer ();
		this.initPageSelector ();
		this.initLayout ();
	},

	initVideoPlayer: function () {
		var classLevelScope = this;
		_V_ ('reelVideoPlayer').ready (function () {
			classLevelScope.reelVideoPlayer = this;
		});
	},
	
	initPhotoViewer: function () {
		$ ('#photos').responsiveSlides ({
			auto: false,
			fade: 100,
			nav: true,
			pager: true,
			prevText: '<',
			nextText: '>',
			manualControls: '#photos-pager'
		});
	},

	initPageSelector: function () {
		$.hideAllExcept ('.tab', '.box');
		$ ('.tab').on ('click', $.proxy (this.onPageChange, this));
	},

	onPageChange: function (event) {

		// Could be null until ready callback fires
		if (this.reelVideoPlayer) {
			if (event.delegateTarget.hash !== '#reel') {
				this.reelVideoPlayer.pause ();
			}
			else {
				if (this.reelVideoPlayer.currentTime () !== 0) {
					this.reelVideoPlayer.currentTime (0);
					this.reelVideoPlayer.play ();
				}
				else
				{
					this.reelVideoPlayer.play ();
				}
			}
		}
	},

	initLayout: function () {
		$ ('#main').bind ('updateLayout', $.proxy (this.updateLayout, this));

		$ (window).bind ('load resize orientationchange', function () {
			$ ('#main').trigger ('updateLayout');
		});

		this.updateLayout ();
	},

	updateLayout: function () {
		this.windowData.windowWidth = $ (window).width ();
		this.windowData.windowHeight = $ (window).height ();
		this.windowData.isLandscapeView = (Math.max (this.windowData.windowWidth, this.windowData.windowHeight) === this.windowData.windowWidth);
		
		//var MIN_WIDTH = 30.0;//32.0
		var MIN_WIDTH = 40.0;
		var MAX_WIDTH = 64.2;
		
		
		if (this.windowData.windowWidth / 16.0 < MAX_WIDTH) {

			console.log ('width:', ((this.windowData.windowWidth / 16.0)/MAX_WIDTH));
			
			
			
			if (this.windowData.windowWidth / 16.0 > MIN_WIDTH) {
				var emsWidth = this.windowData.windowWidth / 16.0;

				
				if (this.reelVideoPlayer) {
					var scaleRatio = (this.windowData.windowWidth / 16.0)/MAX_WIDTH;
					var videoWidth = Math.floor(this.windowData.windowWidth * scaleRatio);
					var videoHeight = Math.floor(this.windowData.windowHeight * scaleRatio);
					this.reelVideoPlayer.size (videoWidth, videoHeight);
				}
				
				$ ("body").css ("font-size", (emsWidth / MAX_WIDTH) + "em");
			}
			else {

				if (this.reelVideoPlayer) {
					var scaleRatio = (MIN_WIDTH / 16.0)/MAX_WIDTH;
					var videoWidth = Math.floor(this.windowData.windowWidth * scaleRatio);
					var videoHeight = Math.floor(this.windowData.windowHeight * scaleRatio);
					this.reelVideoPlayer.size (videoWidth, videoHeight);
				}
				
				$ ("body").css ("font-size", MIN_WIDTH / MAX_WIDTH + "em");
			}
		}
		else {
			if (this.reelVideoPlayer) {
				this.reelVideoPlayer.size(this.videoData.width, this.videoData.height);
			}
			$ ("body").css ("font-size", "1.0em");
		}
	},
	
	reelVideoPlayer: null
};