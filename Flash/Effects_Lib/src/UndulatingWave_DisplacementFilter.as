// forked from sharkbox's flash on 2010-1-6
package {
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.filters.*;
	import flash.events.Event;

	public class UndulatingWave_DisplacementFilter extends Sprite {
		public function UndulatingWave_DisplacementFilter(){

			var rect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			var point:Point = new Point();
			var perlin:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xffffff);
			var perlin2:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xffffff);
			perlin.perlinNoise(50, 50, 1, Math.random() * 1000, true, true, 1, true);
			var bmp:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xffffff);
			var bmp2:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xffffff);
			this.addChildAt(new Bitmap(bmp2),0);

			bmp.noise(1000,0,255,1|2|4,true);
			bmp.applyFilter(bmp,
					rect,
					point,
					new BlurFilter(20, 1, 5));

			this.addEventListener(Event.ENTER_FRAME, _oef);

			function _oef($evt)
			{
				perlin2.copyPixels(perlin,
						rect,
						new flash.geom.Point(-1, 0));
				perlin2.copyPixels(perlin,
						new flash.geom.Rectangle(0, 0, 1, stage.stageHeight),
						new flash.geom.Point(stage.stageWidth - 1, 0));
				perlin.copyPixels(perlin2, rect, point);
				bmp2.copyPixels(bmp, rect, point);
				bmp2.applyFilter(bmp2,
						rect,
						point,
						new flash.filters.DisplacementMapFilter(perlin, point, 1, 1, 2, 10));
			}
		}
	}
}
