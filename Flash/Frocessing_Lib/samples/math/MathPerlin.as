package math
{
	import frocessing.display.F5MovieClip2DBmp;
	
	/**
	* Perlin Noise.
	* 
	* @author nutsu
	* @version 0.6
	*/
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0xCCCCCC )]
	public class MathPerlin extends F5MovieClip2DBmp
	{
		private var w:Number  = 512;
		private var h:Number = 512;
		private var n:int = 5;
		private var t:Number = 0;
		
		public function setup():void
		{
			size( w, h );
			background( 0 );
			noFill();
			colorMode( HSV, 1, 1, 1 );
			noiseSeed( 3 );
		}
		
		public function draw():void
		{			
			translate( 0, h/2 );
			
			stroke( t, 1, 1, 0.2 );
			beginShape();
			curveVertex( -100, 0 );
			for ( var i:int=0; i <= n; i++ ){
				var xx:Number = i * w / n;
				var yy:Number = noise( i * 0.25, t ) * 300 - 150;
				curveVertex( xx, yy );
			}
			curveVertex( w+100, 0 );
			endShape();
			
			t+=0.01;
		}
	}
}

