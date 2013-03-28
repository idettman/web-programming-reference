package text 
{
	import frocessing.display.F5MovieClip2D;
	import frocessing.text.IFont;
	/**
	 * font draw.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0x000000 )]
	public class TextFont extends F5MovieClip2D
	{
		private var font1:IFont;
		private var font2:IFont;
		
		public function setup():void
		{
			size( stage.stageWidth, stage.stageHeight );
			font1 = loadFont( "asset/font/Swansea-48.vlw" );
			font2 = loadFont( "asset/font/SwanseaBold-48.vlw" );
			noLoop();
		}
		
		public function draw():void
		{
			noStroke();
			
			translate( 56, 25 );
			testDraw( font1 );
			
			translate( 0, 160 );
			textAlign( RIGHT );
			testDraw( font2, 400 );
			
			translate( 0, 160 );
			textAlign( CENTER );
			testDraw( font2, 200 );
		}
		
		private function testDraw( f:IFont, x0:Number=0 ):void
		{
			fill( 255 );
			textFont( f, 12 );
			text( "FROCESSING TEXT DRAW", x0, 0 );
			
			fill( 200 );
			textSize( 24 );
			text( "FROCESSING TEXT DRAW", x0, 25 );
			
			fill( 150 );
			textSize( 36 );
			text( "FROCESSING TEXT", x0, 60 );
			
			fill( 100 );
			textSize( 38 );
			textLeading( 40 );
			text( "FROCESSING TEXT DRAW", 0, 100, 400, 200 );
			
		}
	}
	
}