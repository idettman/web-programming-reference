package transform 
{
	import frocessing.display.F5MovieClip2D;
	/**
	 * Transform Color Wheel
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0 )]
	public class TransformColorWheel extends F5MovieClip2D
	{
		private var theta:Number;
		
		public function setup():void 
		{
			size( 512, 512 );
			colorMode( HSV, 60, 1, 1, 1 );
			noStroke();
			rectMode( CENTER );
			noLoop();
		}
		
		public function draw():void
		{
			translate( fg.width / 2, fg.height / 2 );
			rotate( -PI / 2 );
			
			for ( var i:int = 0; i < 60 ; i++ ) 
			{
				fill( i, 1, 1 );
				rect( 200, 0, 30, 10, 4, 4 );
				rotate( TWO_PI / 60 );
			}
		}
	}

}