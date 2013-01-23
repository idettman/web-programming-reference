package components.video.livestream
{
	import flash.events.Event;


	public class LivestreamPlayerEvent extends Event
	{
		public static const LOAD_PLAYER_STARTED:String = "loadPlayerStarted";
		public static const LOAD_PLAYER_PROGRESS:String = "loadPlayerProgress";
		public static const PLAYER_READY:String = "playerReady";

		public static const PLAYER_ERROR:String = "playerError";
		public static const PLAYER_CONNECTED_TO_CHANNEL:String = "playerConnectedToChannel";
		public static const PLAYER_DISCONNECTED_FROM_CHANNEL:String = "playerDisconnectedFromChannel";
		
		public static const PLAYBACK_STARTED:String = "playbackStarted";
		public static const PLAYBACK_COMPLETE:String = "playbackComplete";

		public static const CHANNEL_IS_LIVE:String = "channelIsLive";
		public static const CHANNEL_IS_NOT_LIVE:String = "channelIsNotLive";

		public static const PLAYER_MUTED:String = "playerMuted";
		public static const PLAYER_UNMUTED:String = "playerUnmuted";

		public static const PLAYER_PLAY_CLICKED:String = "playerPlayClicked";
		public static const PLAYER_PAUSE_CLICKED:String = "playerPauseClicked";


		public var data:*;




		public function LivestreamPlayerEvent (type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			this.data = data;
			super (type, bubbles, cancelable);
		}
	}
}
