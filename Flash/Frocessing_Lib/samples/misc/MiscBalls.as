package misc 
{
	import frocessing.bmp.FImage;
	import frocessing.display.F5MovieClip3D;
	import frocessing.math.Random;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	
	/**
	 *  
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0xffffff )]
	public class MiscBalls extends F5MovieClip3D
	{
		
		private var w:Number = 512;
		private var h:Number = 512;
		
		private var num:int = 500;
		private var img:FImage;
		private var imgs:Array 
		private var img_size:Number = 20;
		
		private var a:Number = 0;
		
		private var xx:Array;
		private var yy:Array;
		private var zz:Array;

		public function MiscBalls() 
		{
			super();
		}
		
		public function setup():void {
			
			xx = Random.normals( num, 0, 130 );
			yy = Random.normals( num, 0, 130 );
			zz = Random.normals( num, 0, 130 );
			
			imageMode( CENTER );
			imageSmoothing( false );
			imageDetail(1);
			
			perspective( Math.PI*0.5, w/h, 100 );
			
			img = loadImage( "asset/img/ball.png" );
			
			//
			stage.quality   = "low";
			stage.scaleMode = "noScale";
		}
		
		public function predraw():void {
			//resize image
			img.setSize( img.bitmapData.width + 40, img.bitmapData.height + 40 );
			imgs = [];
			var filter:BlurFilter = new BlurFilter(2, 2, 16);
			imgs[0] = img.bitmapData;
			for( var m:int=1; m<20; m++ ){
				filter.blurX = filter.blurY = (m + 1) * 0.2;
				var img_:BitmapData = img.bitmapData.clone();
				img_.applyFilter( img_, img.bitmapData.rect, img.bitmapData.rect.topLeft, filter );
				imgs[m] = img_;
			}
		}
		
		public function draw():void 
		{
			camera( w/2, h/2, 100 + mouseY );
			translate( w/2, h/2 );
			rotateY( radians(a) );
			rotateX( radians(a*0.5) );
			
			noStroke();
			var camera_z:Number = fg.cameraZ;
			for (var i:int=0; i<num; i++){
				var sz:Number = Math.abs( norm( screenZ(xx[i], yy[i], zz[i])-camera_z, 0, camera_z ) );
				var zi:int = Math.min( 19, Math.floor( sz * 30 ) );
				image2d( imgs[zi], xx[i], yy[i], zz[i], img_size, img_size );
			}
			a+=1.0;
		}
		
	}
	
}