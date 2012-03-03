package experiments.hype
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;

	import hype.extended.color.ColorPool;
	import hype.extended.layout.ShapeLayout;
	import hype.framework.core.ObjectPool;
	import hype.framework.display.BitmapCanvas;
	
	
	public class HypeTest extends Sprite
	{
		private var _colorPool:ColorPool;
		private var _pool:ObjectPool;
		private var _bitmapCanvas:BitmapCanvas;
		private var _shapeLayout:ShapeLayout;
		
		
		public function HypeTest()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_colorPool = new ColorPool(0xFF0000, 0x00FF00, 0x0000FF);
			
			_bitmapCanvas = new BitmapCanvas(400, 400, true,0xFFFF0000);
			addChild(_bitmapCanvas);
			
			_pool = new ObjectPool(TestShape, 50);
			
			_shapeLayout = new ShapeLayout(new TestShape);
			
			
			_pool.onRequestObject = onPoolRequestHandler;
		}
		
		public function onPoolRequestHandler(clip:DisplayObject):void
		{
			trace("on pool request");
			
		}
		
		
	}
}
