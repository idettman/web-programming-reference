var Main = {


	init: function ()
	{
		// Get reference to video play so it can be accessed within Main
		/*this.reelVideoPlayer = $ ('#reelVideoPlayer').get (0);*/
		this.reelVideoPlayer = _V_('reelVideoPlayer');

		_V_('reelVideoPlayer').ready(function() {

			//var myPlayer = this;
			// EXAMPLE: Start playing the video.
			//myPlayer.play();
			console.log ('REEL VIDEO PLAYER READY!!!!!');
		});


		$ ('#photos').responsiveSlides ({
			auto: false,
			fade: 500,
			nav: true,
			pager: true,
			prevText: 'Previous',
			nextText: 'Next',
			manualControls: '#photos-pager'
		});


		$.hideAllExcept ('.tab', '.box', $.proxy(Main.onPageChange, Main));
	},


	onPageChange: function (pageID) {


		if (pageID !== '#reel') {
			this.reelVideoPlayer.pause ();
		}
		else {
			if (this.reelVideoPlayer.currentTime() !== 0) {
				this.reelVideoPlayer.currentTime (0);
			}
			this.reelVideoPlayer.play ();
		}
	},


	reelVideoPlayer: null

};