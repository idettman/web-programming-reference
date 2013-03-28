package transform 
{
	import frocessing.display.F5MovieClip2D;
	/**
	 * Transform Tree
	 * based on processing example "Recursive Tree" by Daniel Shiffman. 
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0 )]
	public class TransformTree extends F5MovieClip2D
	{
		private var theta:Number;
		
		public function setup():void 
		{
			stage.quality = "low";
			size( 512, 512 );
			stroke( 255, 0.5 );
		}
		
		public function draw():void
		{
		   theta = radians( 90*mouseX/fg.width );
		   translate( fg.width*0.5, fg.height*0.85 );
		   scale( 1.5 - 0.75*mouseY/fg.height );
		   line(0,0,0,-150);
		   translate(0,-150);
		   branch(120);
		}
		
		private function branch( h:Number ):void
		{
		   h *= 0.66;
		   if (h > 2) {
			  branch2( h,  theta );
			  branch2( h, -theta );
		   }
		}
		
		private function branch2( h:Number, t:Number ):void 
		{
		   pushMatrix();
		   rotate(t);
		   line(0,0,0,-h);
		   translate(0,-h); 
		   branch(h);       
		   popMatrix();
		}
	}

}