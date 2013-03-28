package display 
{
	import frocessing.display.F5MovieClip2D;
	/**
	* draw in constructor
	* 
	* @author nutsu
	* @version 0.6
	*/
	[SWF( width=512, height=512, frameRate=12, backgroundColor=0xCCCCCC )]
	public class F5MovieClipDraw1 extends F5MovieClip2D
	{
		
		public function F5MovieClipDraw1()
		{
			translate( 256, 256 );
			circle( 0, 0, 200 );
		}
	}

}