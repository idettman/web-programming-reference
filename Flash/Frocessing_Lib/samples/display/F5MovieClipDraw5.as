package display 
{
	import frocessing.display.F5MovieClip2DBmp;
	/**
	* bmp draw.
	* 
	* @author nutsu
	* @version 0.6
	*/
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0xCCCCCC )]
	public class F5MovieClipDraw5 extends F5MovieClip2DBmp
	{
		public function draw():void
		{
			line( pmouseX, pmouseY, mouseX, mouseY );
		}
	}

}