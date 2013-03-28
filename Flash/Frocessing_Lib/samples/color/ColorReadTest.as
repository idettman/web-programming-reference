package color 
{
	import frocessing.display.F5MovieClip2D;
	/**
	 * create color(uint) and read color.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0x000000 )]
	public class ColorReadTest extends F5MovieClip2D
	{
		
		public function ColorReadTest() 
		{
			var colors:Array = [];
			var i:int;
			var n:int = 25;
			noStroke();
			
			//
			colorMode( HSV, n );
			for ( i = 0; i < n; i++ ) {
				//create 32bit color
				colors[i] = color( i, n, n, n );
			}
			translate( 10, 5 );
			drawColors( colors, n);
			
			for ( i = 0; i < n; i++ ) {
				//create 32bit color
				colors[i] = color( i, n, i, n/2 + i/2 );
			}
			translate( 50, 0 );
			drawColors( colors, n);
		}
		
		private function drawColors( colors:Array, n:int ):void
		{
			var i:int;
			for ( i = 0; i < n; i++ ) {
				//set 32bit color
				fill( colors[i] );
				rect( 0, i * 20, 40, 20 );
			}
			
			//read red value
			translate( 50, 0 );
			for ( i = 0; i < n; i++ ) {
				fill( red(colors[i]) );
				rect( 0, i * 20, 40, 20 );
			}
			
			//read green value
			translate( 50, 0 );
			for ( i = 0; i < n; i++ ) {
				fill( green(colors[i]) );
				rect( 0, i * 20, 40, 20 );
			}
			
			//read blue value
			translate( 50, 0 );
			for ( i = 0; i < n; i++ ) {
				fill( blue(colors[i]) );
				rect( 0, i * 20, 40, 20 );
			}
			
			//read alpha value
			translate( 50, 0 );
			for ( i = 0; i < n; i++ ) {
				fill( f5_alpha(colors[i]) );
				rect( 0, i * 20, 40, 20 );
			}
		}
		
	}

}