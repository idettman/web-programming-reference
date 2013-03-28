package image 
{
	import frocessing.bmp.FImage;
	import frocessing.display.F5MovieClip3D;
	
	/**
	 * Image 3d draw.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0xcccccc )]
	public class Image3d extends F5MovieClip3D
	{
		private var wh:Number;
		private var hh:Number;
		
		private var img_detail:int = 1;
		private var ri:int = 0;
		
		private var img:FImage;
		
		public function setup():void
		{
			wh = 256;
			hh = 256;
			size( 512, 512 );
			
			img = loadImage("asset/img/plane1.png");
			imageMode( CENTER );
		}
		
		
		public function draw():void {
			var ca:Number = radians( mouseX-wh );
			var cb:Number = radians( mouseY-hh );
			camera( wh + 200.0*sin(ca), hh + 200.0*sin(cb/2), 200.0*cos(ca), wh, hh, 0.0, 0.0, 1.0, 0.0);
			
			translate( wh, hh, 0);
			
			if( ri==0 ){
				fg.backFaceCulling = false;
			}else if ( ri == 1 ) {
				noStroke();
				fg.backFaceCulling = true;
			}
			
			imageDetail(img_detail);
			image( img.bitmapData, 0, 0, 100, 100 );
		}
		
		public function mouseClicked():void 
		{
			//change image detail
			img_detail++;
			if ( img_detail >= 8) {
				img_detail = 1;
			}
		}
		
		public function keyPressed():void 
		{
			ri++;
			if ( ri > 1 ) {
				ri = 0;
			}
		}
	}

}