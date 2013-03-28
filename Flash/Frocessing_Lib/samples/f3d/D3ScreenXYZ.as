package f3d 
{
	import frocessing.display.F5MovieClip3D;
	
	/**
	 * test screenX,Y,Z
	 * (screenX,Y,Z は引数の座標を現在のMatrixで変換した値を返す)
	 * 
	 * from processing example.
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0 )]
	public class D3ScreenXYZ extends F5MovieClip3D
	{
		public function setup():void
		{
			size( stage.stageWidth, stage.stageHeight );
			noFill();
		}
		
		public function draw():void
		{
			var xx:Number = mouseX;
			var yy:Number = mouseY;
			var z:Number = -200;

			// Draw "X" at z = -200
			stroke(255);
			line3d(xx-10, yy-10, z, xx+10, yy+10, z); 
			line3d(xx+10, yy-10, z, xx-10, yy+10, z); 
			
			// Draw 2D line by screenX,Y value
			// element drawn at z = 0 
			stroke(255,0,0);
			var theX:Number = screenX(xx, yy, z);
			var theY:Number = screenY(xx, yy, z);
			line3d(theX, 0, 0, theX, fg.height, 0); // is same to (xx, 0, z, xx, fg.height, z)
			line3d(0, theY, 0, fg.width, theY, 0);
			
			// Draw line in 2D at same x value
			// element drawn at z = 0
			stroke(102);
			line3d(xx, 0, 0, xx, fg.height, 0);
			line3d( 0, yy, 0, fg.width, yy, 0);
			
			
		}
	}
	
}