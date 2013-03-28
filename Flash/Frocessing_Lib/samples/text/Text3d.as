package text 
{
	import frocessing.display.F5MovieClip3D;
	import frocessing.text.FFont;
	import frocessing.text.FontUtil;
	import frocessing.text.IFont;
	import five3D.typography.HelveticaBold;
	/**
	 * Text 3D draw.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0 )]
	public class Text3d extends F5MovieClip3D
	{
		private var ff0:IFont
		private var ff:IFont;
		
		public function setup():void
		{
			size( stage.stageWidth, stage.stageHeight );
			
			ff0 = loadFont("asset/font/SwanseaBold-48.vlw");
			ff = new FFont( FontUtil.convertFive3DTypo( HelveticaBold ) );
			
			fg.backFaceCulling = false;
			
			textAlign( CENTER );
		}
		
		private var a:Number = 0;
		
		public function draw():void
		{
			camera( fg.width/2, fg.height/2, 30 + mouseY );
			
			translate( fg.width/2, fg.height/2 );
			rotateY( a );
			rotateZ( (mouseX-fg.width/2)*0.01 );
			
			textFont( ff, 24 );
			pushMatrix();
			translate( 0, 0, 0 );
			noStroke();
			fill( 0, 160, 200 );
			text( "FROCESSING", 0,  textAscent()+textDescent(), 0 );
			rotateY( PI );
			fill( 200, 0, 0 );
			text( "FROCESSING", 0, 0 );
			popMatrix();
			
			pushMatrix();
			stroke( 23, 196, 253 );
			noFill();
			text( "FROCESSING", 0,  textAscent()+textDescent(), -20 );
			rotateY( PI );
			stroke( 255, 0, 0 );
			text( "FROCESSING", 0, 0, -20 );
			popMatrix();
			
			textFont( ff0, 24 );
			fill( 23, 196, 253 );
			text( "FROCESSING", 0,  textAscent()+textDescent(), 20 );
			rotateY( PI );
			fill( 255, 0, 0 );
			text( "FROCESSING", 0, 0, 20 );
			
			a+=0.01;  
		}
	}
	
}