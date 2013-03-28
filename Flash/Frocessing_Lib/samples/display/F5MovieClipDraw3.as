package display 
{
	import frocessing.display.F5MovieClip2D;
	/**
	* draw loop.
	* 
	* @author nutsu
	* @version 0.6
	*/
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0xCCCCCC )]
	public class F5MovieClipDraw3 extends F5MovieClip2D
	{		
		public function draw():void
		{
			translate( mouseX, mouseY );
			circle( 0, 0, 50 );
		}
	}

}