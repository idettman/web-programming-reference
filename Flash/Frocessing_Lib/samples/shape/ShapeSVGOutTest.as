package shape 
{
	import flash.display.MovieClip;
	import frocessing.shape.FShapeSVGLoader;
	import frocessing.shape.FSVGBuffer;
	import frocessing.utils.FFileUtil;
	/**
	 * shape object to svg.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0xCCCCCC )]
	public class ShapeSVGOutTest extends MovieClip
	{
		private var s:FShapeSVGLoader;
		
		public function ShapeSVGOutTest() 
		{
			s = new FShapeSVGLoader("asset/svg/tiger.svg", null, onload );
		}
		
		public function onload():void {
			addChild( s.toSprite() );
			
			var buf:FSVGBuffer = new FSVGBuffer( 500, 500 );
			buf.addShape( s );
			FFileUtil.saveUTF( buf.getSVGString(), "testsvg.svg" );
		}
	}

}