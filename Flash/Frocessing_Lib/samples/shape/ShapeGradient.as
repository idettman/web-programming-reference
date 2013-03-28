package shape 
{
	import frocessing.core.canvas.CanvasNormalGradientFill;
	import frocessing.display.F5MovieClip3D;
	import frocessing.shape.FShapeRect;
	import frocessing.bmp.FImage;
	import frocessing.geom.FGradientMatrix;
	/**
	 * Shape Gradient Test
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0 )]
	public class ShapeGradient extends F5MovieClip3D
	{
		private var w:Number = 512;
		private var h:Number = 512;
		private var img:FImage;
		private var sp:FShapeRect;
		
		public function setup():void
		{
			size( w, h );
			
			img = loadImage("asset/img/color.jpg");
			
			sp = new FShapeRect( 0, 0, 48, 48, 8, 8 );
			var mat:FGradientMatrix = new FGradientMatrix();
			mat.createLinear( 0, 0, 0.5, 1 );
			sp.fill = new CanvasNormalGradientFill( true, "linear", [0, 0xffffff], [1, 1], [0, 255], mat );
			
			noStroke();
			QMedium();
		}

		public function draw():void
		{
			translate( w/2, h/2 );
			rotateX( (mouseY-w/2)*0.01 );
			rotateY( (mouseX-h/2)*0.01 );
			
			translate( -150, -150 );
			
			for( var i:int=0; i<6; i++ )
			{
				for( var j:int=0; j<6; j++ )
				{
					var c:uint = img.getColor( j / 6, i / 6 ); 	
					CanvasNormalGradientFill(sp.fill).colors[0] = c;
					CanvasNormalGradientFill(sp.fill).colors[1] = lerpColor( c, 0, 0.5 );
					shape( sp, j*300/6, i*300/6 );
				}
			}
		}
		
	}

}
