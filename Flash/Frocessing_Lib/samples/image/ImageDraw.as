package image
{
	import frocessing.bmp.FImage;
	import frocessing.display.F5MovieClip2D;
	/**
	 * Image draw.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0xeeeeee )]
	public class ImageDraw extends F5MovieClip2D
	{
		private var img:FImage;
		
		public function setup():void 
		{
			img = loadImage("asset/img/plane1.png");
		}
		
		public function draw():void 
		{
			image( img.bitmapData, 10, 10, mouseX-10, mouseY-10 );
		}
	}
	
}