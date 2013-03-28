package misc
{
	import frocessing.display.F5MovieClip3D;
	
	/**
	 *  
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0x0 )]
	public class MiscCurve3d extends F5MovieClip3D
	{
		private var num:int = 100;
		private var a:Number = 0;
		private var vsa:Number = 0;

		public function MiscCurve3d() 
		{
			stage.quality = "low";
		}
		
		public function setup():void
		{
			curveDetail( 40 );
			noFill();
			stroke( 255, 0.5 );
			perspective( PI / 2 );
		}
		
		public function draw():void {
			translate( fg.width/2, fg.height/2, -100 + mouseY );
			rotateY( a );
			rotateX( a/3 );
			
			vsa += (mouseX*0.1*PI - vsa)*0.05;
			
			var r:Number = 100;
			beginShape();
			for( var i:int=0;i<num;i++ ){
				var vy:Number = r - r*2*i/num;
				var vs:Number = cos(vsa*vy/r);
				var vx:Number = r*cos(i*0.8)*vs;
				var vz:Number = r*sin(i*0.8)*vs;
				curveVertex3d( vx, vy, vz );
			}
			endShape();
			
			a += 0.02;
		}
	}
	
}