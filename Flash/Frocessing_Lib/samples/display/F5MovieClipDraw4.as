package display 
{
	import frocessing.display.F5MovieClip2D;
	/**
	* redraw.
	* 
	* @author nutsu
	* @version 0.6
	*/
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0xCCCCCC )]
	public class F5MovieClipDraw4 extends F5MovieClip2D
	{
		public function F5MovieClipDraw4()
		{
			noLoop();
		}
		
		public function draw():void
		{
			translate( mouseX, mouseY );
			circle( 0, 0, 50 );
		}
		
		public function mousePressed():void
		{
			redraw();
		}
	}

}