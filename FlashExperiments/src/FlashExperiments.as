package
{

	import base.display.AbstractSprite;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;


	public class FlashExperiments extends AbstractSprite
	{
		public function FlashExperiments ()
		{
			super ();
		}


		private var loadCue:Vector.<String>;
		private var loadedBitmaps:Vector.<Bitmap>;

		override protected function init ():void
		{
			loadedBitmaps = new Vector.<Bitmap> ();
			loadCue = new <String>["textures/front.png", "textures/back.png", "textures/top.png", "textures/bottom.png", "textures/left.png", "textures/right.png"];


			super.init ();
			var textField:TextField = new TextField ();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.multiline = false;
			textField.text = Capabilities.isDebugger + " : " + Capabilities.playerType + " : " + Capabilities.version + " : " + loaderInfo.swfVersion.toString();
			addChild (textField);
			//trace ("width:", Capabilities.screenResolutionX, Capabilities.screenResolutionY);


			startLoading();
		}

		private var loader:Loader;
		private function startLoading ():void
		{
			loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, loadCompleteHandler);

			loadNext();
		}

		private function loadNext ():void
		{
			for (var i:int = 0; i < loadCue.length; i++)
			{
				if (loadCue[i])
				{
					loader.load (new URLRequest (loadCue[i]));
					loadCue[i] = null;
					return;
				}
			}
			loadAllCompleted();
		}

		private function loadAllCompleted ():void
		{
			loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, loadCompleteHandler);

			var away3d:AbstractAway3D = new AbstractAway3D ();
			addChild (away3d);
			away3d.skyboxBitmaps = loadedBitmaps;
		}


		private function loadCompleteHandler (e:Event):void
		{
			loadedBitmaps.push (loader.content as Bitmap);
			loadNext ();
		}
	}
}
