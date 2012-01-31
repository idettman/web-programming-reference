package utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	public class DrawDisplayObjectUtil
	{
		private static var _bitmapData:BitmapData;
		
		private static var _point:Point;
		private static var _matrix:Matrix;
		private static var _clipRectangle:Rectangle;
		private static var _blendMode:String;
		private static var _colorTransform:ColorTransform;
		
		
		public static function getBitmapData(dislpayObject:DisplayObject):BitmapData
		{
			_bitmapData = new BitmapData(dislpayObject.width, dislpayObject.height, true /*transparent*/, NaN /*fillColor*/);
			_bitmapData.draw(dislpayObject, _matrix, null, null, null, false);
			
			return _bitmapData.clone();
		}
	}
}
