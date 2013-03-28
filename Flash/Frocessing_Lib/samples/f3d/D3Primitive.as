package f3d 
{
	import frocessing.display.F5MovieClip3D;
	
	/**
	 * Primitive Object
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0 )]
	public class D3Primitive extends F5MovieClip3D
	{
		private var wh:Number;
		private var hh:Number;
		private var a:Number = 0;
		
		public function D3Primitive() 
		{
			super();
		}
		
		public function setup():void
		{
			wh = 256;
			hh = 256;
			size( 512, 512 );
			perspective( PI/3, 1, 20 );
		}
		
		public function draw():void {
			var ca:Number = radians( mouseX-wh );
			var cb:Number = radians( mouseY-hh );
			
			camera( wh + 100.0*sin(ca), hh + 100.0*sin(cb/2), 100.0*cos(ca), wh, hh, 0.0, 0.0, 1.0, 0.0);
			
			translate( wh, hh, 0);
			
			//big sphere
			stroke(0x66);
			noFill();
			sphereDetail( 6 );
			fg.backFaceCulling = false;
			sphere(400);
			
			//small sphere
			stroke(127);
			fill( 255 );
			sphereDetail( 12 );
			fg.backFaceCulling = true;
			sphere(30);
			
			//box
			rotateX( a );
			pushMatrix();
			translate(50, 0, 0);
			box(20, 10, 10);
			popMatrix();
			
			translate(0, 50, 0);
			rotateY( HALF_PI );
			
			box(10, 20, 10);
			
			a += 0.02;
		}
	}
	
}