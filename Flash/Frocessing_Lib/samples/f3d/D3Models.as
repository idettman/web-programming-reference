package f3d 
{
	import frocessing.bmp.FImage;
	import frocessing.display.F5MovieClip3D;
	import frocessing.f3d.F3DModel;
	import frocessing.f3d.models.*;
	
	/**
	 * Model draw.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0 )]
	public class D3Models extends F5MovieClip3D
	{
		private var wh:Number;
		private var hh:Number;
		
		private var models:Array;
		private var mi:int = 0;
		private var ri:int = 0;
		
		private var img0:FImage;
		private var img1:FImage;
		private var img2:FImage;
		private var img3:FImage;
		private var img4:FImage;
		
		public function setup():void
		{
			wh = 256;
			hh = 256;
			size( 512, 512 );
			
			img0 = loadImage("asset/img/plane1.png");
			img1 = loadImage("asset/img/plane2.png");
			img2 = loadImage("asset/img/cubetexture.png");
			img3 = loadImage("asset/img/spheretexture.png");
			img4 = loadImage("asset/img/torustexture.png");
		}
		
		public function predraw():void
		{
			var m0:F3DModel = new F3DModel();
			m0.beginVertex( F3DModel.TRIANGLE_STRIP );
			m0.addVertex( -50, -50, 0, 0, 0 );
			m0.addVertex( -50,  50, 0, 0, 1 );
			m0.addVertex(  50, -50, 0, 1, 0 );
			m0.addVertex(  50,  50, 0, 1, 1 );
			m0.endVertex();
			
			var m1:F3DPlane = new F3DPlane( 100, 100, 4, 4 );
			var m2:F3DSimpleCube = new F3DSimpleCube( 60, 60, 60, 2, 2, 2 );
			var m3:F3DSphere = new F3DSphere( 50, 12, 12 );
			var m4:F3DTorus  = new F3DTorus( 40, 20, 16, 10 );
			var m5:F3DCube   = new F3DCube( 80, 40, 100, 3, 1, 5 );
			
			m0.setTexture( img0.bitmapData );
			m1.setTexture( img1.bitmapData, img0.bitmapData );
			m2.setTexture( img2.bitmapData );
			m3.setTexture( img3.bitmapData );
			m4.setTexture( img4.bitmapData );
			m5.setColors( 0xeeeeee, 0x666666, 0x444444, 0xcccccc, 0xffffff, 0x333333 );
			
			models = [m0, m1, m2, m3, m4, m5];
		}
		
		public function draw():void {
			var ca:Number = radians( mouseX-wh );
			var cb:Number = radians( mouseY-hh );
			
			camera( wh + 200.0*sin(ca), hh + 200.0*sin(cb/2), 200.0*cos(ca), wh, hh, 0.0, 0.0, 1.0, 0.0);
			
			translate( wh, hh, 0);
			
			if( ri==0 ){
				noStroke();
				models[mi].enableStyle();
			}else if ( ri == 1 ) {
				stroke( 180 );
				fill( 220 );
				fg.backFaceCulling = true;
				models[mi].disableStyle();
			}else if ( ri == 2 ) {
				stroke( 255 );
				fill( 120, 0.75 );
				fg.backFaceCulling = false;
				models[mi].disableStyle();
			}
			
			model( models[mi] );
		}
		
		public function mouseClicked():void 
		{
			mi++;
			if ( mi >= models.length) {
				mi = 0;
			}
		}
		
		public function keyPressed():void 
		{
			ri++;
			if ( ri > 2 ) {
				ri = 0;
			}
		}
	}

}