package image
{
	import frocessing.bmp.FImage;
	import frocessing.display.F5MovieClip2D;
	/**
	 * Image Texture.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0xeeeeee )]
	public class ImageVertex extends F5MovieClip2D
	{
		private var img:FImage;
		
		public function setup():void 
		{
			img = loadImage("asset/img/plane1.png");
			noStroke();
			noLoop();
		}
		
		public function draw():void 
		{
			var iw:Number = img.bitmapData.width;
			var ih:Number = img.bitmapData.height;
			
			translate( 20, 20 );
			pushMatrix();
			{
				image( img.bitmapData, 0, 0, 150, 150 );
				
				translate( 160, 0 );
				
				//set uv by pixel
				textureMode( IMAGE );
				beginShape( QUADS );
				texture( img.bitmapData );
				vertex(   0,   0,  0, 0 );
				vertex( 150,   0, iw, 0 );
				vertex( 150, 150, iw, ih );
				vertex(   0, 150,  0, ih );
				endShape();
				
				translate( 160, 0 );
				
				//set uv by normal ( default );
				textureMode( NORMALIZED );
				beginShape( QUADS );
				texture( img.bitmapData );
				vertex(   0,   0, 0.0, 0.0 );
				vertex( 150,   0, 1.0, 0.0 );
				vertex( 150, 150, 1.0, 1.0 );
				vertex(   0, 150, 0.0, 1.0 );
				endShape();
				
			}
			popMatrix();
			translate( 0, 160 );
			pushMatrix();
			{
				textureMode( NORMALIZED );
				
				beginShape( QUADS );
				texture( img.bitmapData );
				vertex(   0,   0, 0.0, 0.0 );
				vertex( 150,   0, 0.5, 0.0 );
				vertex( 150, 150, 0.5, 0.5 );
				vertex(   0, 150, 0.0, 0.5 );
				endShape();
				
				translate( 160, 0 );
				
				//set uv by pixel
				beginShape( QUADS );
				texture( img.bitmapData );
				vertex(   0,   0, 1.0, 1.0 );
				vertex( 150,   0, 0.0, 1.0 );
				vertex( 150, 150, 0.0, 0.0 );
				vertex(   0, 150, 1.0, 0.0 );
				endShape();
				
				translate( 160, 0 );
				
				//set uv by normal ( default );
				
				beginShape( TRIANGLE_STRIP );
				texture( img.bitmapData );
				vertex(   0,   0, 0.0, 0.0 );
				vertex(   0, 150, 0.0, 1.0 );
				vertex( 150,   0, 1.0, 0.0 );
				vertex( 150, 150, 1.0, 1.0 );
				endShape();
				
			}
			popMatrix();
			translate( 0, 160 );
			pushMatrix();
			{
				textureMode( NORMALIZED );
				
				imageDetail(1);
				beginShape( QUADS );
				texture( img.bitmapData );
				vertex(  50,   0, 0.0, 0.0 );
				vertex( 130,  50, 1.0, 0.0 );
				vertex( 150, 130, 1.0, 1.0 );
				vertex(   0, 150, 0.0, 1.0 );
				endShape();
				
				translate( 160, 0 );
				
				imageDetail(2);
				beginShape( QUADS );
				texture( img.bitmapData );
				vertex(  50,   0, 0.0, 0.0 );
				vertex( 130,  50, 1.0, 0.0 );
				vertex( 150, 130, 1.0, 1.0 );
				vertex(   0, 150, 0.0, 1.0 );
				endShape();
				
				translate( 160, 0 );
				
				imageDetail(4);
				beginShape( QUADS );
				texture( img.bitmapData );
				vertex(  50,   0, 0.0, 0.0 );
				vertex( 130,  50, 1.0, 0.0 );
				vertex( 150, 130, 1.0, 1.0 );
				vertex(   0, 150, 0.0, 1.0 );
				endShape();
			}
			popMatrix();
		}
	}
	
}