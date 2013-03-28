package shape
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import frocessing.bmp.FImage;
	import frocessing.display.F5CanvasMovieClip2D;
	import frocessing.utils.FFileUtil;
	import frocessing.core.canvas.BitmapDataCanvas2D;
	import frocessing.core.canvas.out.SVGOutput2D;	
	import frocessing.core.canvas.DualCanvas2D;
	import frocessing.core.F5Canvas2D;
	/**
	* SVG Output test.
	* (prototype)
	* 
	* 
	* @author nutsu
	* @version 0.6
	*/
	[SWF(width=500,height=750,backgroundColor=0xffffff,frameRate=60)]
	public class SVGOutputTest extends F5CanvasMovieClip2D
	{		
		private var _svgout:SVGOutput2D;
		private var _bmpc:BitmapDataCanvas2D;
		private var _target_bmp:Bitmap;
		
		private var img:FImage;
		private var b:BrushState;
		
		/**
		 * 
		 */
		public function SVGOutputTest() 
		{
			_bmpc   = new BitmapDataCanvas2D( new BitmapData( 500, 750, false, 0 ) );
			_svgout = new SVGOutput2D( 500, 750 );
			super(
				new F5Canvas2D(new DualCanvas2D(_bmpc, _svgout)),
				_target_bmp = new Bitmap( _bmpc.bitmapData )
			);
			
			size( 500, 750 );
			_target_bmp.bitmapData = _bmpc.bitmapData;
		}
		
		public function setup():void {
			stage.scaleMode = "noScale";
			
			background(0);
			
			colorMode( HSV, 1 );

			b = new BrushState();
			b.vx = b.vy = 0.0;
			b.xx = 0;
			b.yy = 0;
			b.px0 = [0,0,0];
			b.py0 = [0,0,0];
			b.px1 = [0,0,0];
			b.py1 = [0,0,0];
		}
		
		public function draw():void {
			//描画
			drawing( mouseX, mouseY );
			
		}
		private function drawing( x:Number, y:Number ):void
		{
			var px:Number = b.xx;
			var py:Number = b.yy;
			b.xx += b.vx += ( x - b.xx ) * 0.1;
			b.yy += b.vy += ( y - b.yy ) * 0.1;
			
			//
			var x0:Number  = px + b.vy*0.1;
			var y0:Number  = py - b.vx*0.1;
			var x1:Number  = px - b.vy*0.1;
			var y1:Number  = py + b.vx*0.1;
			
			//
			noStroke();
			fill( random(0.95, 1), random(0.5, 1), random(0.5, 1) );
			beginShape();
			curveVertex( b.px0[0], b.py0[0] );
			curveVertex( b.px0[1], b.py0[1] );
			curveVertex( b.px0[2], b.py0[2] );
			curveVertex( x0, y0 );
			vertex( b.px1[2], b.py1[2] );
			curveVertex( x1, y1 );
			curveVertex( b.px1[2], b.py1[2] );
			curveVertex( b.px1[1], b.py1[1] );
			curveVertex( b.px1[0], b.py1[0] );
			endShape();
			endFill();
			//
			stroke( 0, 0.5 );
			noFill();
			curve( b.px0[0], b.py0[0], b.px0[1], b.py0[1], b.px0[2], b.py0[2], x0, y0 );
			curve( b.px1[0], b.py1[0], b.px1[1], b.py1[1], b.px1[2], b.py1[2], x1, y1 );
			
			
			b.px0.shift(), b.px0.push( x0 ); 
			b.py0.shift(), b.py0.push( y0 ); 
			b.px1.shift(), b.px1.push( x1 ); 
			b.py1.shift(), b.py1.push( y1 ); 
			
			b.vx *= 0.96;
			b.vy *= 0.96;
		}
		
		private var _flg:Boolean = true;
		
		public function mousePressed():void {
			if( _flg ){
				noLoop();
				_svgout.flush();
				FFileUtil.saveUTF( _svgout.svg, "untitled.svg" );
				_flg = false;
			}
		}
		
		public function keyPressed():void 
		{
			loop();
			background( 0 );
			_flg = true;
		}
	}
	
}
class BrushState {
	public var xx:Number;
	public var yy:Number;
	public var vx:Number;
	public var vy:Number;
	public var px0:Array;
	public var py0:Array;
	public var px1:Array;
	public var py1:Array;
	public function BrushState(){}
}