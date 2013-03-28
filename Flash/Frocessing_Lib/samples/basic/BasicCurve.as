package basic
{
	import frocessing.display.F5MovieClip2D;
	/**
	 * curve draw.
	 * 
	 * from processing example
	 * 
	 * @author nutsu
	 * @version 0.6
	 */
	[SWF( width=512, height=512, frameRate=60, backgroundColor=0xeeeeee )]
	public class BasicCurve extends F5MovieClip2D
	{
		public function BasicCurve() 
		{
			pushMatrix();
			
			// bezier
			noFill();
			stroke(255, 102, 0);
			line(85, 20, 10, 10);
			line(90, 90, 15, 80);
			stroke(0, 0, 0);
			bezier(85, 20, 10, 10, 90, 90, 15, 80);
			
			//
			translate( 100, 0 );
			
			noFill();
			stroke(255, 102, 0);
			line(30, 20, 80, 5);
			line(80, 75, 30, 75);
			stroke(0, 0, 0);
			bezier(30, 20,  80, 5,  80, 75,  30, 75);
			
			//
			translate( 100, 0 );
			
			// spline
			noFill();
			stroke(255, 102, 0);
			curve(5, 26, 5, 26, 73, 24, 73, 61);
			stroke(0); 
			curve(5, 26, 73, 24, 73, 61, 15, 65); 
			stroke(255, 102, 0);
			curve(73, 24, 73, 61, 15, 65, 15, 65);
			
			popMatrix();
			
			//-----------------------------------------------------------
			
			translate( 0, 100 );
			pushMatrix();
			
			stroke(0);
			
			//bezierVertex
			noFill();
			beginShape();
			vertex(30, 20);
			bezierVertex(80, 0, 80, 75, 30, 75);
			endShape();
			
			translate( 100, 0 );
			
			//bezierVertex
			fill( 255 );
			beginShape();
			vertex(30, 20);
			bezierVertex(80, 0, 80, 75, 30, 75);
			bezierVertex(50, 80, 60, 25, 30, 20);
			endShape();
			
			translate( 100, 0 );
			
			//curveVertex
			noFill();
			beginShape();
			curveVertex(84,  91);
			curveVertex(84,  91);
			curveVertex(68,  19);
			curveVertex(21,  17);
			curveVertex(32, 100);
			curveVertex(32, 100);
			endShape();
			
			popMatrix();
			//-----------------------------------------------------------
			translate( 0, 100 );
			pushMatrix();
			
			var i:int;
			var t:Number;
			var xx:Number;
			var yy:Number;
			var tx:Number;
			var ty:Number;
			var a:Number;
			
			bezier(85, 20, 10, 10, 90, 90, 15, 80);
			var steps:int = 6;
			fill(255);
			for ( i = 0; i <= steps; i++) {
				t = i / steps;
				// Get the location of the point
				xx = bezierPoint(85, 10, 90, 15, t);
				yy = bezierPoint(20, 10, 90, 80, t);
				// Get the tangent points
				tx = bezierTangent(85, 10, 90, 15, t);
				ty = bezierTangent(20, 10, 90, 80, t);
				// Calculate an angle from the tangent points
				a = atan2(ty, tx);
				a += PI;
				stroke(255, 102, 0);
				line(xx, yy, cos(a)*30 + xx, sin(a)*30 + yy);
				stroke(0);
				ellipse(xx, yy, 5, 5);
			}

			translate( 100, 0 );
			
			noFill();
			stroke(0);
			bezier(85, 20, 10, 10, 90, 90, 15, 80);
			stroke(255, 102, 0);
			steps = 16;
			for ( i = 0; i <= steps; i++) {
				t = i / steps;
				xx = bezierPoint(85, 10, 90, 15, t);
				yy = bezierPoint(20, 10, 90, 80, t);
				tx = bezierTangent(85, 10, 90, 15, t);
				ty = bezierTangent(20, 10, 90, 80, t);
				a = atan2(ty, tx);
				a -= HALF_PI;
				line(xx, yy, cos(a)*8 + xx, sin(a)*8 + yy);
			}
			
			translate( 100, 0 );
			
			noFill();
			stroke(0);
			curveTightness(1); 
			curve(5, 26, 73, 24, 73, 61, 15, 65); 
			steps = 6;
			stroke(255, 102, 0);
			for ( i = 0; i <= steps; i++) {
				t = i / steps;
				xx = curvePoint(5, 73, 73, 15, t);
				yy = curvePoint(26, 24, 61, 65, t);
				tx = curveTangent(5, 73, 73, 15, t);
				ty = curveTangent(26, 24, 61, 65, t);
				a = atan2(ty, tx);
				a -= PI/2.0;
				line(xx, yy, cos(a)*8 + xx, sin(a)*8 + yy);
			}
			
			popMatrix();
			//-----------------------------------------------------------
			translate( 0, 100 );
			pushMatrix();
			
			// White curve 
			noFill();
			stroke(255,0,0); 
			beginShape();
			curveVertex(10, 26);
			curveVertex(10, 26);
			curveVertex(83, 24);
			curveVertex(83, 61);
			curveVertex(25, 65); 
			curveVertex(25, 65);
			endShape();

			// Gray curve
			stroke(126); 
			curveTightness(3.5); 
			beginShape();
			curveVertex(10, 26);
			curveVertex(10, 26);
			curveVertex(83, 24);
			curveVertex(83, 61);
			curveVertex(25, 65); 
			curveVertex(25, 65);
			endShape();
			 
			// Black curve 
			stroke(0); 
			curveTightness(-2.5); 
			beginShape();
			curveVertex(10, 26);
			curveVertex(10, 26);
			curveVertex(83, 24);
			curveVertex(83, 61);
			curveVertex(25, 65); 
			curveVertex(25, 65);
			endShape();
			
			popMatrix();
		}
	}
	
}