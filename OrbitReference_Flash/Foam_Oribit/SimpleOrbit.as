package example.orbit
{
	import flash.display.Sprite;
	import org.generalrelativity.foam.Foam;
	import org.generalrelativity.foam.dynamics.element.body.Circle;
	import org.generalrelativity.foam.dynamics.ode.solver.Euler;
	import org.generalrelativity.foam.view.Renderable;
	import org.generalrelativity.foam.dynamics.element.body.RigidBody;
	import org.generalrelativity.foam.util.ShapeUtil;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import example.orbit.force.GravitationalForceGenerator;

	public class SimpleOrbit extends Sprite
	{
		
		public static const START_COLOR:uint = 0x00aa00;
		public static const RK4_COLOR:uint = 0xaa0000;
		public static const EULER_COLOR:uint = 0x0000aa;
		public static const SOURCE_COLOR:uint = 0;
		
		public function SimpleOrbit()
		{
			
			var foam:Foam = addChild( new Foam() ) as Foam;
			//scale to initially fit (800x600)
			foam.x = 200, foam.y = 100, foam.scaleX = foam.scaleY = 0.5;
			
			//create a source of the gravitational pull
			var source:Circle = new Circle( 400, 300, 60, 10000 );
			
			//create an element influenced by source's gravitational pull to be integrated with the Euler IODESolver
			var eulerOrbital:Circle = new Circle( 700, 300, 30, 100, 0, -7 );
			//create an element influenced by source's gravitational pull to be integrated with the RK4 IODESolver
			var rungaKuttaOrbital:Circle = new Circle( 700, 300, 30, 100, 0, -7 );
			
			//create the gravitational force generator
			var gravity:GravitationalForceGenerator = new GravitationalForceGenerator( source );
			
			//add this to each orbital
			eulerOrbital.addForceGenerator( gravity );
			rungaKuttaOrbital.addForceGenerator( gravity );
			
			//add each element to FOAM (no collisions)
			foam.addElement( source, false, true, { color:SimpleOrbit.SOURCE_COLOR, alpha:1 } );
			//specify the use of our Euler solver
			foam.addElement( eulerOrbital, false, true, { color:SimpleOrbit.EULER_COLOR }, new Euler( eulerOrbital ) );
			//RK4 is default, no need to explicitly set
			foam.addElement( rungaKuttaOrbital, false, true, { color:SimpleOrbit.RK4_COLOR } );
			//easiest way to draw a circle where we want
			foam.addRenderable( new Renderable( new Circle( 700, 300, 30 ), false, { color:SimpleOrbit.START_COLOR } ) ); 
			
			setupLabels();
			
			//uncomment to watch Euler spiral out of control even faster
			foam.solverIterations = 121;
			
			//start the simulation
			foam.simulate();
			
		}
		
		private function setupLabels() : void
		{
			addLabel( "GRAVITATIONAL SOURCE", SimpleOrbit.SOURCE_COLOR, 20 );
			addLabel( "STARTING POINT", SimpleOrbit.START_COLOR, 35 );
			addLabel( "EULER INTEGRATOR", SimpleOrbit.EULER_COLOR, 50 );
			addLabel( "RK4 INTEGRATOR", SimpleOrbit.RK4_COLOR, 65 );
		}
		
		private function addLabel( text:String, color:uint, yPos:int ) : void
		{
			var textField:TextField = new TextField();
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = 400;
			textField.y = yPos;
			textField.textColor = color;
			textField.text = text;
			addChild( textField );
		}
		
	}
}