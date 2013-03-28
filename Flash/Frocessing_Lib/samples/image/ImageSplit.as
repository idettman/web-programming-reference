package image 
{
	import frocessing.bmp.FImage;
	import frocessing.display.F5MovieClip3D;
	import frocessing.f3d.models.F3DCube;
	/**
	 * Image splite.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0x333333 )]
	public class ImageSplit extends F5MovieClip3D
	{
		private var w:Number = 512;
		private var h:Number = 512;
		private var a:Number = 0;
		private var m:F3DCube;
		private var texture1:FImage;
		
		public function setup():void
		{
			size( w, h );
			texture1 = loadImage("asset/img/cube_image.png");
			m = new F3DCube( 40 );
		}
		
		public function predraw():void {
			var texs:Array = texture1.split( 3, 2 );
			m.setTextures( texs[0], texs[1], texs[2], texs[3], texs[4], texs[5] );
		}
		
		public function draw():void {
			var ca:Number = radians( mouseX-w/2 );
			var cb:Number = radians( mouseY/2 );
			
			camera( w/2 + 100.0*cos(ca), h/2 + 100.0*cos(cb), 100.0*sin(ca), w/2, h/2, 0.0, 0.0, 1.0, 0.0);
			
			translate(w / 2, h / 2, 0);
			
			noStroke();
			model( m );
		}
	}
	
}