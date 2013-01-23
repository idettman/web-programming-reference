package utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	public class ScreenshotUtils
	{
		public static function drawScreenshot (displayObject:DisplayObject, bounds:Rectangle):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData ((bounds.width), (bounds.height), true, 0x00000000);
			bitmapData.draw (displayObject, new Matrix (1, 0, 0, 1, -bounds.x, -bounds.y), null, null, null);

			return bitmapData;
		}


		public static function appendBitmapData (baseBitmapData:BitmapData, appendBitmapData:BitmapData, offsetX:Number = 0):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData (baseBitmapData.rect.width + appendBitmapData.rect.width - offsetX, baseBitmapData.height, true, 0x00000000);

			bitmapData.lock ();
			bitmapData.copyPixels (baseBitmapData, baseBitmapData.rect, new Point (0, 0), null, null, true);
			bitmapData.copyPixels (appendBitmapData, appendBitmapData.rect, new Point (baseBitmapData.width + offsetX, 0), null, null, true);
			bitmapData.unlock ();

			return bitmapData;
		}
	}
}
