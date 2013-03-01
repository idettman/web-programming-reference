package
{

	import components.animationscrubber.AnimationScrubberComponent;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;


	[SWF(width="973",height = "600",frameRate="24")]
	public class AnimationScrubber extends Sprite
	{
		public var animationScrubberComponent:AnimationScrubberComponent;


		public var loader:Loader;


		public function AnimationScrubber ()
		{
			animationScrubberComponent = new AnimationScrubberComponent ();
			addChild (animationScrubberComponent);

			loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, animationLoadCompleteHandler);
			loader.load (new URLRequest ("AssetRav4360Animation.swf"));
		}


		private function animationLoadCompleteHandler (e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, animationLoadCompleteHandler);


			animationScrubberComponent.animation = loader.content as MovieClip;
		}
	}
}
