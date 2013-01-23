package components.video.livestream
{
	import base.display.AbstractMovieClip;

	import flash.display.Loader;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;


	// components.video.livestream.LivestreamPlayer
	public class LivestreamPlayer extends AbstractMovieClip
	{
		public static const LIVESTREAM_DOMAIN:String = "cdn.livestream.com";
		public static const LIVESTREAM_CROSS_DOMAIN:String = "http://cdn.livestream.com/crossdomain.xml";
		
		public var player:Object;
		
		
		private static const PLAYER_SWF_URL:String = "http://cdn.livestream.com/chromelessPlayer/v20/playerapi.swf";
		private static const DEFAULT_WIDTH:Number = 480;
		private static const DEFAULT_HEIGHT:Number = 240;
		
		private var _loader:Loader;
		private var _devKey:String;
		private var _clipId:String;
		private var _channelId:String;
		private var _videoWidth:Number;
		private var _videoHeight:Number;
		private var _autoPlayVideo:Boolean;


		public function LivestreamPlayer (devKey:String)
		{
			super ();
			Security.allowDomain (LIVESTREAM_DOMAIN);
			Security.loadPolicyFile (LIVESTREAM_CROSS_DOMAIN);
			_devKey = devKey;
		}


		/**
		 * Public Methods
		 */
		public function playVideo ():void
		{
			if (player)
			{
				player.play ();
			}
			else
			{
				_autoPlayVideo = true;
				trace ("LivestreamPlayer . playVideo() : player is null");
			}
		}


		public function pauseVideo ():void
		{
			if (player)
			{
				// Pause playback without closing the connection.
				player.pause ();
			}
			else
			{
				_autoPlayVideo = false;
				trace ("LivestreamPlayer . pauseVideo() : player is null");
			}
		}


		public function stopVideo ():void
		{
			if (player)
			{
				// Stop playback and close the connection.
				player.stop ();
			}
			else
			{
				_autoPlayVideo = false;
				trace ("LivestreamPlayer . stopVideo() : player is null");
			}
		}


		public function muteVideo ():void
		{
			if (player)
			{
				if (!Boolean (player.isMute))
					player.toggleMute ();
			}
			else
			{
				trace ("LivestreamPlayer . muteVideo() : player is null");
			}
		}


		public function unmuteVideo ():void
		{
			if (player)
			{
				if (Boolean (player.isMute))
					player.toggleMute ();
			}
			else
			{
				trace ("LivestreamPlayer . unmuteVideo() : player is null");
			}
		}


		/**
		 * Private/Protected Methods
		 */
		override protected function setDefaults ():void
		{
			super.setDefaults ();
			_autoPlayVideo = true;
			_videoWidth = DEFAULT_WIDTH;
			_videoHeight = DEFAULT_HEIGHT;
		}


		override protected function init ():void
		{
			super.init ();
			initLoader ();
		}


		override protected function destroy ():void
		{
			destroyPlayer ();
			destroyLoader ();
			super.destroy ();
		}


		private function update ():void
		{
			if (player && _devKey && _channelId)
			{
				// If true, the player will show error messages on the screen when an error occurs.
				// Default is true
				//player.showErrorMessages = false;

				player.width = _videoWidth;
				player.height = _videoHeight;
				player.devKey = _devKey;
				player.volume = 0;
				player.letterBox = false;

				//player.showThumbnail = true, false;
				//player.showPlayButton = true, false;
				//player.showPauseButton = true, false;
				//player.showMuteButton = true, false;
				//player.showFullscreenButton = true, false;
				//player.showSpinner = true, false;
				//player.volume = 0 - 1;
				//player.letterBox = true, false;
				//player.aspectWidth = Number;
				//player.aspectHeight = Number;

				player.load (_channelId, _clipId);

				if (_autoPlayVideo)
					player.play ();
			}
		}


		private function initLoader ():void
		{
			const PLAYER_SWF_URL_REQUEST:URLRequest = new URLRequest (PLAYER_SWF_URL);

			_loader = new Loader ();
			addChild (_loader);
			_loader.contentLoaderInfo.addEventListener (Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, loaderProgressHandler);
			

			try
			{
				// load remotely
				_loader.load (PLAYER_SWF_URL_REQUEST, new LoaderContext (true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
			}
			catch (error:SecurityError)
			{
				// load locally
				_loader.load (PLAYER_SWF_URL_REQUEST);
			}
			
			dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.LOAD_PLAYER_STARTED));
		}


		private function destroyLoader ():void
		{
			if (_loader)
			{
				_loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, loaderCompleteHandler);
				_loader.contentLoaderInfo.removeEventListener (ProgressEvent.PROGRESS, loaderProgressHandler);

				if (_loader.contentLoaderInfo.bytesLoaded < _loader.contentLoaderInfo.bytesTotal)
					_loader.close ();
				else
					_loader.unload ();

				removeChild (_loader);
				_loader = null;
			}
		}


		private function initPlayer ():void
		{
			if (_loader.content)
			{
				player = _loader.content;

				player.addEventListener ("mutedEvent", videoMutedHandler);
				player.addEventListener ("unmutedEvent", videoUnmutedHandler);

				player.addEventListener ("pauseClickedEvent", pauseClickedHandler);
				player.addEventListener ("playClickedEvent", videoPlayClickedHandler);

				player.addEventListener ("isLiveEvent", isLiveHandler);
				player.addEventListener ("errorEvent", playerErrorHandler);
				player.addEventListener ("playbackEvent", playbackHandler);
				player.addEventListener ("connectionEvent", connectionHandler);
				player.addEventListener ("playbackTimeEvent", playbackTimeHandler);
				player.addEventListener ("disconnectionEvent", disconnectionHandler);
				player.addEventListener ("playbackCompleteEvent", playbackCompleteHandler);

				update ();
				stage.align = StageAlign.TOP;
				dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.PLAYER_READY));
			}
			else
			{
				throw new Error (">>Error LivestreamPlayer.initPlayer(): _loader.content is null");
			}
		}


		private function destroyPlayer ():void
		{
			if (player)
			{
				player.stop ();

				player.removeEventListener ("mutedEvent", videoMutedHandler);
				player.removeEventListener ("unmutedEvent", videoUnmutedHandler);

				player.removeEventListener ("pauseClickedEvent", pauseClickedHandler);
				player.removeEventListener ("playClickedEvent", videoPlayClickedHandler);
				
				player.removeEventListener ("isLiveEvent", isLiveHandler);
				player.removeEventListener ("errorEvent", playerErrorHandler);
				player.removeEventListener ("playbackEvent", playbackHandler);
				player.removeEventListener ("connectionEvent", connectionHandler);
				player.removeEventListener ("playbackTimeEvent", playbackTimeHandler);
				player.removeEventListener ("disconnectionEvent", disconnectionHandler);
				player.removeEventListener ("playbackCompleteEvent", playbackCompleteHandler);
				player = null;
			}
		}


		/**
		 * Getters/Setters
		 */
		public function get clipId ():String
		{ return _clipId; }


		public function set clipId (value:String):void
		{
			if (value != _clipId)
			{
				_clipId = value;
				update ();
			}
		}


		public function get channelId ():String { return _channelId; }


		public function set channelId (value:String):void
		{
			if (value != _channelId)
			{
				_channelId = value;
				update ();
			}
		}


		public function get autoPlayVideo ():Boolean { return _autoPlayVideo; }


		public function set autoPlayVideo (value:Boolean):void
		{
			_autoPlayVideo = value;
		}


		public function set videoWidth (videoWidth:Number):void
		{
			_videoWidth = videoWidth;
			if (player)
				player.width = _videoWidth;
		}


		public function set videoHeight (videoHeight:Number):void
		{
			_videoHeight = videoHeight;
			if (player)
				player.height = _videoHeight;
		}


		public function get isLive ():Boolean { return Boolean (player.isLive); }


		/**
		 * Event Handlers
		 */
		private function loaderProgressHandler (e:ProgressEvent):void
		{
			dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.LOAD_PLAYER_PROGRESS, _loader.contentLoaderInfo.bytesTotal / _loader.contentLoaderInfo.bytesLoaded));
		}


		private function loaderCompleteHandler (e:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener (ProgressEvent.PROGRESS, loaderProgressHandler);
			_loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, loaderCompleteHandler);
			
			initPlayer ();
		}


		/*
		 Fired when the player initially connects to the channel. This does not imply that video playback has started
		 */
		private function connectionHandler (e:Event):void
		{
			//trace ("LivestreamPlayer . connectionHandler:");
			dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.PLAYER_CONNECTED_TO_CHANNEL));
		}


		/*
		 Fired when a clip reaches it's end in on-demand mode or when the playback was stopped in live mode
		 */
		private function playbackCompleteHandler (e:Event):void
		{
			//trace ("LivestreamPlayer . playbackCompleteHandler:");
			dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.PLAYBACK_COMPLETE));
		}


		/*
		 Fired when the player gets disconnected from the channel. Does not usually happen unless your connection drops for instance
		 */
		private function disconnectionHandler (e:Event):void
		{
			//trace ("LivestreamPlayer . disconnectionHandler:");
			dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.PLAYER_DISCONNECTED_FROM_CHANNEL));
		}


		/*
		 Fired when content playback actually starts, when the video starts playing
		 */
		private function playbackHandler (e:Event):void
		{
			//trace ("LivestreamPlayer . playbackHandler > isLive:", player.isLive);
			dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.PLAYBACK_STARTED));
		}


		/*
		 Playback time event, passes the current playback time as an argument Only for on-demand clips.
		 */
		private function playbackTimeHandler (e:Event):void
		{
			//trace ("LivestreamPlayer . playbackTimeHandler:", e);
		}


		/*
		 Fired when the channel goes on/off live status. You may use isLive after this has been fired to check whether the channel went live or just stopped being live.
		 */
		private function isLiveHandler (e:Event):void
		{
			//trace ("LivestreamPlayer . isLiveHandler > player.isLive:", player.isLive);
			if (player.isLive)
				dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.CHANNEL_IS_LIVE));
			else
				dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.CHANNEL_IS_NOT_LIVE));
		}


		/*
		 Fired when an error occurs. The code attribute on the event will tell you what the error code is and the message attribute contains a short description of the issue
		 */
		private function playerErrorHandler (e:Event):void
		{
			//trace ('LivestreamPlayer . playerErrorHandler > Object (e).message: ' + Object (e).message);
			dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.PLAYER_ERROR, Object (e).message));
		}


		private function videoMutedHandler (e:Event):void
		{
			//trace ('LivestreamPlayer . videoMutedHandler');
			dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.PLAYER_MUTED));
		}


		private function videoUnmutedHandler (e:Event):void
		{
			//trace ('LivestreamPlayer . videoUnmutedHandler');
			dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.PLAYER_UNMUTED));
		}


		private function pauseClickedHandler (e:Event):void
		{
			//trace ('LivestreamPlayer . pauseClickedHandler');
			dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.PLAYER_PAUSE_CLICKED));

		}


		private function videoPlayClickedHandler (e:Event):void
		{
			//trace ('LivestreamPlayer . videoPlayClickedHandler');
			dispatchEvent (new LivestreamPlayerEvent (LivestreamPlayerEvent.PLAYER_PLAY_CLICKED));
		}


	}
}
