package transform 
{
	import frocessing.bmp.FImage;
	import frocessing.display.F5MovieClip3D;
	/**
	 * Transform Cubes
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0 )]
	public class TransformCubes extends F5MovieClip3D
	{
		private var img:FImage;
		
		public function setup():void 
		{
			stage.quality = "low";
			size( 512, 512 );
			stroke( 0 );
			img = loadImage( "asset/img/color.jpg" );
		}
		
		public function draw():void
		{
			var hw:Number = 256;
			var hh:Number = 256;
			translate( hw, hh, (mouseY-hh)*2 );
			rotateX( (mouseY-hh)*0.01 );
			rotateY( (mouseX-hw)*0.01 );
			
			var a:Number = (mouseX-hw)*0.0002;	
			translate( -200, -200 );
			for( var i:int=0; i<400; i+=30 ){
				for( var j:int=0; j<400; j+=30 ){
					fill( img.getColor( j/400, i/400 ) );
					rotateX( a );
					rotateY( a );
					box(25);
					translate(30,0);
				}
				translate(-j,30);
			}
		}
	}
}