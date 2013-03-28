package f3d 
{
	import frocessing.display.F5MovieClip3D;
	/**
	 * Frustum Projection test
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0x333333 )]
	public class D3CameraFrustum extends F5MovieClip3D
	{
		
		public function setup():void {
			size( 512, 512 );
			stroke(255);
			fill(127);
		}

		public function draw():void {
			
			var wa:Number = 1.0*mouseX/fg.width;
			var ha:Number = 1.0*mouseY/fg.height;
			
			frustum( -50.0*(1.0-wa), 50.0*wa,  -50.0*(1.0-ha), 50.0*ha, 50, 50000 );
			
			translate(fg.width/2, fg.height/2, 0 );
			rotateY(-PI/6);
			box( 200 );
		}
	}

}