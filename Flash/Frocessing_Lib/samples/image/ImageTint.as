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
	public class ImageTint extends F5MovieClip2D
	{
		private var img:FImage;
		
		public function setup():void 
		{
			img = loadImage("asset/img/plane1.png");
			noLoop();
		}
		
		public function draw():void 
		{
			translate( 20, 20 );
			pushMatrix();
			{
				image( img.bitmapData, 0, 0, 150, 150 );
				
				translate( 160, 0 );
				
				tint( 255, 0, 0 );
				image( img.bitmapData, 0, 0, 150, 150 );
				
				translate( 160, 0 );
				
				tint( 255, 255, 0 );
				image( img.bitmapData, 0, 0, 150, 150 );
			}
			popMatrix();
			translate( 0, 160 );
			pushMatrix();
			{
				tint( 200 );
				image( img.bitmapData, 0, 0, 150, 150 );
				
				translate( 160, 0 );
				
				tint( 100 );
				image( img.bitmapData, 0, 0, 150, 150 );
				
				translate( 160, 0 );
				
				noTint();
				image( img.bitmapData, 0, 0, 150, 150 );
			}
			popMatrix();
		}
	}
	
}