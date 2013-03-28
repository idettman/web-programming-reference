package basic
{
	import frocessing.display.F5MovieClip2D;	
	/**
	 * basic shape draw test
	 * 
	 * from Processing example
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=30, backgroundColor=0xCCCCCC )]
	public class BasicShapes extends F5MovieClip2D
	{
		public function BasicShapes() 
		{			
			pushMatrix();
			
			// line
			stroke(0);
			line(30, 20, 85, 20);
			stroke(126);
			line(85, 20, 85, 75);
			stroke(255);
			line(85, 75, 30, 75);
			
			translate( 100, 0 );
			
			// point
			stroke(0);
			point(30, 20);
			point(85, 20);
			point(85, 75);
			point(30, 75);
			
			translate( 100, 0 );
			
			// arc
			stroke(0);
			fill(255);
			arc(50, 55, 50, 50, 0, PI/2);
			noFill();
			arc(50, 55, 60, 60, PI/2, PI);
			arc(50, 55, 70, 70, PI, TWO_PI-PI/2);
			arc(50, 55, 80, 80, TWO_PI-PI/2, TWO_PI);
			
			translate( 100, 0 );
			
			//circle
			fill(255);
			stroke(0);
			circle( 56, 46, 30 );
			
			popMatrix();
			
			//-----------------------------------------------------------
			translate( 0, 100 );
			pushMatrix();
			
			stroke(0);
			fill(255);
			
			//quad
			quad(38, 31, 86, 20, 69, 63, 30, 76);
			
			translate( 100, 0 );
			
			//triangle
			triangle(30, 75, 58, 20, 86, 75);
			
			translate( 100, 0 );
			
			//triangle
			ellipse(56, 46, 55, 35);
			
			translate( 100, 0 );
			
			//rect
			rect(30, 20, 55, 35);
			
			popMatrix();
			//-----------------------------------------------------------
			translate( 0, 100 );
			pushMatrix();
			
			ellipseMode(CENTER);
			ellipse(50, 50, 50, 50);
			
			translate( 100, 0 );
			
			ellipseMode(RADIUS);
			ellipse(50, 50, 25, 25);
			
			translate( 100, 0 );
			
			ellipseMode(CORNER);
			ellipse(25, 25, 50, 50);
			
			translate( 100, 0 );
			
			ellipseMode(CORNERS);
			ellipse(25, 25, 75, 75);
			
			popMatrix();
			//-----------------------------------------------------------
			translate( 0, 100 );
			pushMatrix();
			
			rectMode(CENTER);
			rect(50, 50, 50, 50);
			
			translate( 100, 0 );
			
			rectMode(RADIUS);
			rect(50, 50, 25, 25);
			
			translate( 100, 0 );
			
			rectMode(CORNER);
			rect(25, 25, 50, 50);
			
			translate( 100, 0 );
			
			rectMode(CORNERS);
			rect(25, 25, 75, 75);
			
			popMatrix();
		}
	}
	
}