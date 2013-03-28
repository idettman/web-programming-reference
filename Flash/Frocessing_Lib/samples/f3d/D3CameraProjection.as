package f3d 
{
	import frocessing.display.F5MovieClip3D;
	/**
	 * Projection test
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0 )]
	public class D3CameraProjection extends F5MovieClip3D
	{
		
		public function setup():void 
		{
			size( 512, 512 );
			stroke( 255 );
			fill( 127 );
		}
		
		public function draw():void 
		{
			var wh:Number = fg.width / 2;
			var hh:Number = fg.height / 2;
			
			if ( isMousePressed )
			{
				var fov:Number = PI/3.0; 
				var near:Number = hh / tan( fov/2.0 ); 
				perspective(fov, fg.width/fg.height, 1, near*100); 
			}
			else if ( isKeyPressed ) 
			{
				frustum( -wh, wh, -hh, hh, fg.cameraZ, 10000 );
			}
			else 
			{
				ortho(-wh, wh, -hh, hh, 10, 20); 
			}
			
			translate(fg.width/2, fg.height/2, 0);
			rotateX(-PI/6); 
			rotateY(PI/3); 
			box(160); 
		}
		
	}

}