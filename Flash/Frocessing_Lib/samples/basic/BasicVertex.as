package basic
{
	import frocessing.display.F5MovieClip2D;
	/**
	 * vertex draw test
	 * 
	 * from Processing example
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0xCCCCCC )]
	public class BasicVertex extends F5MovieClip2D
	{
		public function BasicVertex() 
		{
			size( 512, 512 );
			
			beginShape();
			vertex(30, 20);
			vertex(85, 20);
			vertex(85, 75);
			vertex(30, 75);
			endShape();
			
			pushMatrix();
			
			translate( 100, 0 );
			beginShape(POINTS);
			vertex(30, 20);
			vertex(85, 20);
			vertex(85, 75);
			vertex(30, 75);
			endShape();
			
			translate( 100, 0 );
			
			beginShape(LINES);
			vertex(30, 20);
			vertex(85, 20);
			vertex(85, 75);
			vertex(30, 75);
			endShape();
			
			translate( 100, 0 );
			
			noFill();
			beginShape();
			vertex(30, 20);
			vertex(85, 20);
			vertex(85, 75);
			vertex(30, 75);
			endShape(CLOSE);
			
			popMatrix();
			translate( 0, 100 );
			pushMatrix();
			
			noFill();
			beginShape();
			vertex(30, 20);
			vertex(85, 20);
			vertex(85, 75);
			vertex(30, 75);
			endShape();
			
			fill( 255 );
			translate( 100, 0 );
			
			beginShape(TRIANGLES);
			vertex(30, 75);
			vertex(40, 20);
			vertex(50, 75);
			vertex(60, 20);
			vertex(70, 75);
			vertex(80, 20);
			endShape();
			
			translate( 100, 0 );
			
			beginShape(TRIANGLE_STRIP);
			vertex(30, 75);
			vertex(40, 20);
			vertex(50, 75);
			vertex(60, 20);
			vertex(70, 75);
			vertex(80, 20);
			vertex(90, 75);
			endShape();
			
			translate( 100, 0 );
			
			beginShape(TRIANGLE_FAN);
			vertex(57.5, 50);
			vertex(57.5, 15); 
			vertex(92, 50); 
			vertex(57.5, 85); 
			vertex(22, 50); 
			vertex(57.5, 15); 
			endShape();
			
			popMatrix();
			translate( 0, 100 );
			pushMatrix();
			
			beginShape(QUADS);
			vertex(30, 20);
			vertex(30, 75);
			vertex(50, 75);
			vertex(50, 20);
			vertex(65, 20);
			vertex(65, 75);
			vertex(85, 75);
			vertex(85, 20);
			endShape();
			
			translate( 100, 0 );
			
			beginShape(QUAD_STRIP); 
			vertex(30, 20); 
			vertex(30, 75); 
			vertex(50, 20);
			vertex(50, 75);
			vertex(65, 20); 
			vertex(65, 75); 
			vertex(85, 20);
			vertex(85, 75); 
			endShape();
			
			translate( 100, 0 );
			
			beginShape();
			vertex(20, 20);
			vertex(40, 20);
			vertex(40, 40);
			vertex(60, 40);
			vertex(60, 60);
			vertex(20, 60);
			endShape(CLOSE);
			
			popMatrix();
		}
	}
	
}