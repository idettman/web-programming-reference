package shape 
{
	import frocessing.display.F5MovieClip3D;
	import frocessing.shape.FShapeSVG;
	/**
	* SVG 3d test.
	* 
	* @author nutsu
	* @version 0.6
	*/
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0xCCCCCC )]
	public class ShapeSVG3d extends F5MovieClip3D
	{
		private var svgdata:FShapeSVG;
		
		public function setup():void
		{
			svgdata = loadShape("asset/svg/fig.svg");
			shapeMode( CENTER );
			stroke( 255 );
			noFill();
		}

		public function draw():void
		{
			var wh:Number = fg.width/2;
			var hh:Number = fg.height/2;
			translate( wh, hh, mouseY-hh );
			rotateX( -(mouseY-hh)*0.01 );
			rotateY( (mouseX-wh)*0.01 );
			shape( svgdata, 0, 0 );
		}

		public function mousePressed():void
		{
			svgdata.disableStyle();
		}

		public function mouseReleased():void
		{
			svgdata.enableStyle();
		}
	}
	
}