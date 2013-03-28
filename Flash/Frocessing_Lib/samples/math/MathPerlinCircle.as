package math 
{
	import frocessing.display.F5MovieClip2D;
	
	/**
	* Perlin Noise.
	* 
	* @author nutsu
	* @version 0.6
	*/
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0xffffff )]
	public class MathPerlinCircle extends F5MovieClip2D
	{
		private var noiseScale:Number = 0.1;
		
		public function draw():void
		{
			noStroke();
			fill(0);
			translate( 6, 6 );
			for ( var i:int = 0; i <= 20; i++ ){
				for ( var j:int = 0; j <= 20; j++ ) {
					var s:Number = 20*noise( i * noiseScale, j * noiseScale, (mouseY+mouseX)*0.01 )
					circle( i * 25, j * 25, s );
				}
			}
		}
		
	}
	
}