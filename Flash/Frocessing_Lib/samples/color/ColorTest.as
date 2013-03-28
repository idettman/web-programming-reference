package color 
{
	import frocessing.display.F5MovieClip2D;
	/**
	 * Color Test
	 * from processing sample
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF(frameRate="30", width="512", height="512", backgroundColor="#cccccc")] 
	public class ColorTest extends F5MovieClip2D
	{
		
		public function ColorTest() 
		{
			background(51);
			
			pushMatrix();
			
			var c_orange:uint = color(204, 102, 0);
			var c_blue:uint = color(0, 102, 153);
			var orangeblueadd:uint = blendColor(c_orange, c_blue, ADD);
			noStroke();
			fill(c_orange);
			rect(14, 20, 20, 60);
			fill(orangeblueadd);
			rect(40, 20, 20, 60);
			fill(c_blue);
			rect(66, 20, 20, 60);
			
			translate( 100, 0 );
			
			stroke(255);
			var from:uint = color(204, 102, 0);
			var to:uint = color(0, 102, 153);
			var interA:uint = lerpColor(from, to, .33);
			var interB:uint = lerpColor(from, to, .66);
			fill(from);
			rect(10, 20, 20, 60);
			fill(interA);
			rect(30, 20, 20, 60);
			fill(interB);
			rect(50, 20, 20, 60);
			fill(to);
			rect(70, 20, 20, 60);
			
			
			popMatrix();
			//-----------------------------------------------------------
			translate( 0, 100 );
			pushMatrix();
			
			noStroke();
			var c:uint;
			colorMode( RGB, 255 );
			trace( fg.colorModeA );
			
			c = color(0, 126, 255, 102);
			fill(c);
			rect(15, 15, 35, 70);
			fill( f5_alpha(c), 255 );
			rect(50, 15, 35, 70);
			fill( red(c), 255 );
			rect(85, 15, 35, 70);
			fill( green(c), 255 );
			rect(120, 15, 35, 70);
			fill( blue(c), 255 );
			rect(155, 15, 35, 70);
			
			translate( 200, 0 );
			
			colorMode(HSB, 255);
			c = color(0, 126, 255, 255 );
			fill(c);
			rect(15, 15, 35, 70);
			fill( f5_alpha(c), 255 );
			rect(50, 15, 35, 70);
			fill( hue(c), 255 );
			rect(85, 15, 35, 70);
			fill( saturation(c), 255 );
			rect(120, 15, 35, 70);
			fill( brightness(c), 255 );
			rect(155, 15, 35, 70);

			popMatrix();
			//-----------------------------------------------------------
		}
	}
	
}