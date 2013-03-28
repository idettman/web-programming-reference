package shape 
{
	import frocessing.display.F5MovieClip2D;
	import frocessing.shape.FShapeSVG;
	/**
	* SVG test.
	* 
	* @author nutsu
	* @version 0.6
	*/
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0xFFFFFF )]
	public class ShapeSVG extends F5MovieClip2D
	{
		private var svgdata:FShapeSVG;
		
		public function setup():void
		{
			svgdata = loadShape("asset/svg/shapes.svg");
			noLoop();
			stroke(0);
			noFill();
		}

		public function draw():void
		{
			shape( svgdata );
		}
		
		public function mouseClicked():void
		{
			if ( svgdata.styleEnabled ) {
				svgdata.disableStyle();
			}else {
				svgdata.enableStyle();
			}
			redraw();
		}
	}
}