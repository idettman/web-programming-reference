package f3d 
{
	import frocessing.display.F5MovieClip3D;
	
	/** 
	* Frocessing 3D の座標系　左手系
	* X（赤）右、Y（青）下、Z（緑）手前
	* 
	* 回転は左手回転
	*/
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0 )]
	public class D3Axis extends F5MovieClip3D
	{
		public function setup():void
		{
			size( stage.stageWidth, stage.stageHeight );
			noFill();
			rectMode( CENTER );
		}
		
		public function draw():void {
			translate(fg.width/2, fg.height/2);
			
			rotateX( radians(mouseY - fg.height/2) );
			rotateY( radians(mouseX - fg.width/2) );
			
			strokeWeight(1);
			stroke(255, 0.5);
			box( 200 );
			rect( 0, 0, 200, 200 );
			
			strokeWeight(2);
			//X
			stroke( 0xffff0000 ); 
			line3d( 0, 0, 0, 100, 0, 0 );
			//Y
			stroke( 0xff0000ff );
			line3d( 0, 0, 0, 0, 100, 0 );
			//Z
			stroke( 0xff00ff00 );
			line3d( 0, 0, 0, 0, 0, 100 );
		}
	}
	
}