package color 
{
	import frocessing.display.F5MovieClip2DBmp;
	/**
	 * Color Mode Test.
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=400, height=200, frameRate=30, backgroundColor=0 )]
	public class ColorModeTest extends F5MovieClip2DBmp
	{
		public function ColorModeTest() 
		{
			size( 400, 200 );
			
			var i:int, j:int;
			
			colorMode( RGB, 200 );
			for ( i = 0; i < 200; i++) {
				for ( j = 0; j < 200; j++){
					stroke(i, j, 0);
					point(i, j);
				}
			}
			
			colorMode( HSV, 200 );
			for ( i = 0; i < 200; i++) {
				for ( j = 0; j < 200; j++){
					stroke(i, j, 200);
					point(i+200, j);
				}
			}
		}
		
	}

}