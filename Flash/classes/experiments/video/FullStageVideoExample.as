package experiments.video 
{
	/**
	 *	This class illustrates a slightly more complicate StageVideo implementation
	 *	Including Pan and Zoom controls
	 *	And information about the rendering state of the StageVideo instance
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.2
	 *
	 *	@author R Blank
	 *	@since  09.09.2011
	 */
 
	//import the MovieClip, because this class is a MovieClip
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.ui.Keyboard;


	//import the Rectangle, so that we can size and position the StageVideo instance
	//import Point so that we can pan and zoom our stage video
	//import StageVideoAvailabilityEvent so we can hear
	//when StageVideo availability changes
	//StageVideoEvent provides information to us about video rendering
	//import StageVideo so we can use StageVideo
	//import StageVideoAvailability to get the values for the
	//StageVideoAvailabilityEvent.available property
	//import Video as a backup for when StageVideo is not available
	//import the NetConnection and NetStream to play our video file
	//import the TextField so we can log values visibly

	//KeyboardEvent for keyboard controls
	//Keyboard class provides keyboard key values
	public class FullStageVideoExample extends MovieClip {
 
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
 
		//the location of our video file
		//private const _videoURL : String = "../_media/bunny.mov" ;
		//private const _videoURL : String = "oopjs.mov" ;
		private const _videoURL : String = "stagevideo_test.mp4" ;
		//private const _videoURL : String = "backcountry_bombshells_4min_HD_H264.mp4" ;
		//private const _videoURL : String = "backcountry_bombshells_4min_HD_H264.mp4" ;
		//the value which we will use to iterate pan and zoom controls
		private const _zoomAndPanVal : Number = .05 ;
 
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		public function FullStageVideoExample ( ) {
			//call the _init function to startup
			//opaqueBackground = 0x00000000;
			//alpha = 0;
			_init () ;
		}
 
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
 
		//the Video object to play video when StageVideo is not available
		private var _video : Video ;		
		//the StageVideo object to play fully accelerated video
		private var _stageVideo : StageVideo ;
		//the NetStream and NetConnection objects to play video
		private var _ns : NetStream ;
		private var _nc : NetConnection ;
		//the TextField object to log informationvisibly in the browser
		private var _tf : TextField ;
		//_panX stores the current stage video horizontal pan value
		private var _panX : Number ;
		//_panY stores the current stage video vertical pan value
		private var _panY : Number ;
		//_zoom stores the current stage video zoom value
		private var _zoom : Number ;
 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
 
		//called by the constructor to startup the player
		private function _init ( ) : void
		{
			//create the video object as back up, in case StageVideo is not available
			_video = new Video ( ) ;
			//create the TextField for logging
			_tf = new TextField ( );
			_tf.height = stage.stageHeight ;
			_tf.width = stage.stageWidth ;
			_tf.mouseWheelEnabled = true ; 
			_tf.multiline = true ; 
			_tf.wordWrap = true ; 
			addChild ( _tf ) ;
			//the NetConnection object over which video is delivered
			_nc = new NetConnection ( ) ;
			//connect _nc to null because we are playing video progressively
			_nc.connect ( null ) ;
			//create the NetStream to deliver video over the NetConnection
			_ns = new NetStream ( _nc ) ;
			//define the NetStream client as 'this' (meaning this class)
			//where _ns will look for the onMetaData and onCuePoint methods
			_ns.client = this ;
			//tell the NetStream to play our video file
			_ns.play ( _videoURL ) ;
			//listen for the StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY event
			//this is dispatched as soon as the event listener is added
			//and when stage video availability changes during SWF playback
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, _onStageVideoAvailability);
 
		}
 
		//called when we wish to start StageVideo playback
		private function _enableStageVideo() : void 
		{
			//if the _video object is in the display list
			if ( _video.parent )
				//remove _video from the display list
				removeChild ( _video ) ;
			//if we do not have a StageVideo object reference 
			//already stored in _stageVideo
			if ( _stageVideo == null ) 
			{
				//set _stageVideo to reference the first of our
				//available StageVideo objects (up to 8 available on desktops)
				_stageVideo = stage.stageVideos [ 0 ] ;
				//listen for the StageVideoEvent.RENDER_STATE
				//which provides us information about how the video is being rendered
				//this is fired when the netstream is attached to the StageVideo instance
				_stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, _onStageVideoStateChange );
				//log the available color spaces
				_tf.appendText ( "_stageVideo.colorSpaces : " + _stageVideo.colorSpaces.toString() + "\n");
 
			}
			
			//attach our NetStream instance to our StageVideo instance
			_stageVideo.attachNetStream ( _ns ) ;
			
			
			//listen for key strokes (which we use for pan and zoom controls)
			stage.addEventListener ( KeyboardEvent.KEY_DOWN , _onKeyDown ) ;
			//reset pan values to 0 (center)
			_panX = 0 ;
			_panY = 0 ;
			//reset zoom value to 1 (actual size)
			_zoom = 1 ;
		}
 
		//called when StageVideo becomes unavailable
		//and we need to use a Video object as back-up
		private function _disableStageVideo() : void {
			stage.removeEventListener ( KeyboardEvent.KEY_DOWN , _onKeyDown ) ;
			//attach our NetStream to our Video object
			_video.attachNetStream ( _ns ) ;
			//add the Video object to the display list
			//(so that it can be seen)
			addChild ( _video ) ;
			//add the _tf TextField back to the display list
			//so that it is on top of the _video object
			addChild ( _tf ) ;
		}
 
 
		//called to change the zoom factor on the StageVideo instance
		//called with true to zoom in
		//            false to zoom out
		private function _zoomIn ( zoomIn : Boolean ) : void
		{
			//if we are zooming in
			if ( zoomIn )
			{
				//if our current zoom factor is less than 16 (the max)
				if ( _zoom < 16 )
				{
					//increment our zoom factor (with a ceiling of 16)
					_zoom = Math.min ( 16 , _zoom + _zoomAndPanVal ) ;
					//set the zoom factor on the StageVideo instance to our _zoom value
					_stageVideo.zoom = new Point ( _zoom , _zoom ) ;
				}
			//otherwise, we are zooming out
			} else {
				//if our current zoom factor is greater than 1 (the minimum)
				if ( _zoom > 1 )
				{
					//decrement our zoom factor (with a floor of 1)
					_zoom = Math.max ( 1 , _zoom - _zoomAndPanVal ) ; 
					//update the zoom of the StageVideo to our zoom factor
					_stageVideo.zoom = new Point ( _zoom , _zoom ) ;
				}
			}
			//log the zoom factor
			_tf.appendText ( "zoomed to " + _zoom + "\n") ;
		}
 
		//called to pan our stage video (which only matters if zoom > 1 )
		//called with "up" to pan up
		//            "down" to pan down
		//            "left" to pan left
		//            "right" to pan right
		private function _pan ( direction : String ) : void
		{
			//if the zoom factor is greater than 1
			if ( _zoom > 1 ) 
			{
				//switch, based on the 'direction' parameter
				switch ( direction )
				{
					case "up" :
						//if _panY is greater than the minimum value
						if ( _panY > -1 )
						{
							//decrement _panY (with a floor of -1)
							_panY = Math.max ( -1 , _panY - _zoomAndPanVal ) ;
						}
						break ;
					case "down" :
						//if _panY is less than the max value
						if ( _panY < 1 )
						{
							//increment _panY (with a ceiling of 1)
							_panY = Math.min ( 1 , _panY + _zoomAndPanVal ) ;
						}
						break ;
					case "left" :
						//if _panX is greater than the minimum value
						if ( _panX > -1 )
						{
							//decrement _panX (with a floor of -1)
							_panX = Math.max ( -1 , _panX - _zoomAndPanVal ) ;
						}
						break ;
					case "right" :
						//if _panX is less than the max value
						if ( _panX < 1 )
						{
							//increment _panX (with a ceiling of 1)
							_panX = Math.min ( 1 , _panX + _zoomAndPanVal ) ;
						}
						break ;
				}
				//log the pan
				_tf.appendText ( "Panning to _panX: " + _panX + " , _panY: " + _panY + "\n" );
				//pan the StageVideo
				_stageVideo.pan = new Point ( _panX , _panY ) ;
			}
		}
 
		//called to reset the pan and zoom on the stage video
		private function _resetPanAndZoom ( ) : void
		{
			//set the pan values to 0
			_panX = 0 ;
			_panY = 0 ;
			//set the zoom factor to 1
			_zoom = 1 ;
			//update the pan value on the StageVideo
			_stageVideo.pan = new Point ( _panX , _panY ) ;
			//update the zoom value on the StageVideo
			_stageVideo.zoom = new Point ( _zoom , _zoom ) ;
		}
 
		//--------------------------------------
		//  Event Handlers
		//--------------------------------------
 
		//this serves as the callback when keys are pressed down
		private function _onKeyDown ( evt : KeyboardEvent ) : void
		{
			//switch based on the code of the pressed key
			switch ( evt.keyCode )
			{
				//if the enter key is pressed
				case Keyboard.ENTER :
					//call to reset the StageVideo display
					_resetPanAndZoom ( ) ;
					break ;
				//the F key
				case 70 :
					//enter full screen playback ('esc' will implicitly exit full screen)
					stage.displayState = "fullScreen" ;
					break ;
				//the 'space' key
				case 32 :
					_tf.text = ""; 
					break ;
				//the +/= key
				case 187 :
					//call to zoom in
					_zoomIn ( true ) ;
					break ;
				//the -/_ key
				case 189 :
					//call to zoom out
					_zoomIn ( false ) ;
					break;
				case Keyboard.UP :
					//call to pan up
					_pan ( "up" ) ;
					break ;
				case Keyboard.DOWN :
					//call to pan down
					_pan ( "down" ) ;
					break;
				case Keyboard.LEFT :
					//call to pan left
					_pan ( "left" ) ;
					break ;
				case Keyboard.RIGHT :
					//call to pan right
					_pan ( "right" ) ;
					break ;
			}
		}
 
		//--------------------------------------
		//  StageVideo Event Handlers
		//--------------------------------------
 
		//our callback function for the
		//StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY event
		private function _onStageVideoAvailability ( evt : StageVideoAvailabilityEvent ) : void {
			//log the availability of StageVideo
			_tf.appendText ( "StageVideo has become " + evt.availability + "\n" );
			//if StageVideo is available
			if ( evt.availability )
				//call _enableStageVideo
				_enableStageVideo ( ) ;
			else 
				//otherwise call _disableStageVideo
				_disableStageVideo ( ) ;
		}
 
		private function _onStageVideoStateChange ( evt : StageVideoEvent ) : void {
			//log the rendering method
			_tf.appendText ( "StageVideo is rendering with " + evt.status + "\n" );
			//size and position our _stageVideo with a new Rectangle
			//sized the native width and height of the video we are playing
			_stageVideo.viewPort = new Rectangle ( 0 , 0 , _stageVideo.videoWidth , _stageVideo.videoHeight ) ;
		}		
		//--------------------------------------
		//  NetStream Event Handlers
		//--------------------------------------
 
		//the NetStream will look for these two methods: onMetaData + onCuePoint
		//on whatever object is identified as the NetStream's client
		//if they do not exist, you will receive a run time error
		//when the NetStream encounters metadata or cuepoints in the video
 
		//onMetaData is called when metadata is encoutered in NetStream playback
		public function onMetaData( info:Object ) : void 
		{ 
			//capture the native video width and height from the metadata
			//and update the width and height of the _video object
			//to match the loaded info
			if ( info.width )
				_video.width = int ( info.width ) ;
			if ( info.height )
				_video.height = int ( info.height ) ;
		}
 
		public function onCuePoint( info:Object ) : void { }
		public function onXMPData( info:Object ) : void { }
 
	}
 
}