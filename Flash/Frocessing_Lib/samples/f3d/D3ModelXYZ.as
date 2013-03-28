package f3d 
{
	import frocessing.display.F5MovieClip3D;
	import frocessing.geom.FMatrix3D;
	/**
	 * test modelX,Y,Z
	 * (modelX,Y,Z は引数の値を、空間内の絶対座標を返す)
	 * 
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0 )]
	public class D3ModelXYZ extends F5MovieClip3D
	{		
		public function setup():void
		{
			size( 512, 512 );
		}
		
		private var a:Number = 10;
		public function draw():void
		{			
			pushMatrix();
			{
				translate(fg.width/2, fg.height/2, -200);
				
				rotateX( 2.0 );
				rotateZ( 2.5 );
				rotateY( a );
				
				translate( 200, 0, 0 );
				
				stroke(255);
				noFill();
				box( 100 );
				
				//現在の(0,0,0)の座標を取得
				var xx:Number = modelX(0, 0, 0);
				var yy:Number = modelY(0, 0, 0);
				var zz:Number = modelZ(0, 0, 0);
			}
			popMatrix();
			
			//
			pushMatrix();
			{
				translate(xx, yy, zz);
				stroke(255, 0, 0);
				fill( 255, 0.5 );
				box(50);
			}
			popMatrix();
			
			a += 0.02;
		}
	}
	
}