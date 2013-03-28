package display 
{
	import frocessing.display.F5MovieClip2D;
	/**
	* F5MovieClip Events
	* 
	* @author nutsu
	* @version 0.6
	*/
	[SWF( width=512, height=512, frameRate=12, backgroundColor=0xCCCCCC )]
	public class F5MovieClipEvents extends F5MovieClip2D
	{
		
		public function setup():void 
		{
			trace( "setup" );
		}
		
		public function predraw():void 
		{
			trace( "predraw" );
		}
		
		public function draw():void 
		{
			trace( "draw", frameCount, mouseX, mouseY, pmouseX, pmouseY, isMousePressed, isKeyPressed, keyCode );
		}
		
		public function mousePressed():void 
		{
			trace( "mousePressed" );
		}
		
		public function mouseReleased():void 
		{
			trace( "mouseReleased" );
		}
		
		public function mouseClicked():void
		{
			trace( "mouseClicked" );
		}
		
		public function mouseMoved():void
		{
			//trace( "mouseMoved" );
		}
		
		public function keyPressed():void 
		{
			trace( "keyPressed" );
		}
		
		public function keyReleased():void 
		{
			trace( "keyReleased" );
		}
		
	}

}