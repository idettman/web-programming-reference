package shape 
{
	import flash.display.MovieClip;
	import frocessing.shape.FShapeSVGLoader;
	/**
	 * svg to sprite
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0xCCCCCC )]
	public class ShapeSVG2Sprite extends MovieClip
	{
		private var s:FShapeSVGLoader;
		
		public function ShapeSVG2Sprite() 
		{
			s = new FShapeSVGLoader("asset/svg/tiger.svg", null, onload );
		}
		
		public function onload():void {
			addChild( s.toSprite() );
		}
	}

}