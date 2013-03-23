/**
 * Adapted by Isaac Dettman from:
 *
 * Orbit.java - an orbit simulator applet
 * By Bob Jenkins, July & August of 1998
 *
 * Recognized applet parameters:
 * "increment": how big a step to take between scenes
 * "background": the background color, eg "000000"
 * "work": the number of steps to do per increment, default is 5
 * "sleep": the number of milliseconds to sleep per display, default 50
 * "trail": leave trails; don't erase old positions of moons
 * "energy": report (current-initial)/initial total energy.  Any value.
 * "eye": how the camera is set up to view this,
 *    position, left(radians), up(radians), clockwise(radians), zoom
 *    "100.0 0.0 0.0 0.0 100.0"
 * "stop": any parameter causes applet to start off not moving
 * "length": length of simulation, stop after this point.
 * "scalemass": amount to scale all masses, default 1.0.  Easier than
 *    adjusting all velocities by sqrt(1/scalemass) when tuning things.
 * "moons": an integer, the number of moons, eg "3"
 * "moon1", "moon2", however many "moons" specified:
 *    position, velocity, mass, color, size.  For example:
 *   "p(0.0, 0.0, 0.0) v(0.0, 0.0, 0.0) 100.0 ffffff 10.0"
 * "follow": A moon number, eg 17.  Keep the eye positioned on moon 17.
 * "noperspective": No perspective -- treat distance as constant
 */










package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;


	public class Orbit extends Sprite
	{
		public var params:Object;

		public var increment:Number;       // how much to increment time each step
		public var t:Number;       // time
		public var maxt:Number;    // end of time;

		//private var runner:Thread;// background thread timing motions
		public var camera:Eye;  // camera for viewing the moons
		public var sim:Simulate;     // all the moons in the system
		public var bgcolor:Color; // background color
		public var should_move:Boolean;  // should the objects be moving
		//public var buffered:Image;     // double buffering buffer
		public var bg:Shape;           // buffered.getGraphics()
		public var oldmousex:Number;    // last handled mouse x
		public var oldmousey:Number;    // last handled mouse y
		public var mousex:Number;       // last recorded mouse x
		public var mousey:Number;       // last recorded mouse y
		public var rotatescale:Number;  // originally assume a screensized sphere
		public var drag:Boolean;         // is the mouse draging the image?
		public var xymode:Boolean;       // true is left/up, false is zoom/clockwise
		public var trail:Boolean;        // leave trails?
		public var energy:Boolean;       // occasionally report energy?
		public var work:int;         // how many substeps to do per iteration
		public var sleep:int;        // how long to sleep, in milliseconds
		public var follow:Moon;       // id of moon to follow,
		public var noperspective:Boolean;// no perspective; like viewed from infinity

		public function init ():void
		{
			createData();

			bg = new Shape ();
			addChild (bg);


			// set up infrastructure
			var param:String;
			this.t = -1.0;

			// get parameters

			this.bgcolor = Point.s2c (getParameter ("background"), Color.black);

			this.increment = Point.s2d (getParameter ("increment"), 0.1);

			this.maxt = Point.s2d (getParameter ("length"), 1.0e30) / this.increment;

			this.should_move = (getParameter ("stop") == null);

			this.trail = (getParameter ("trail") != null);

			this.noperspective = (getParameter ("noperspective") != null);

			this.work = Point.s2d (getParameter ("work"), 5);

			this.sleep = Point.s2d (getParameter ("sleep"), 50);

			// all the objects in the system
			param = getParameter ("moons");
			var luna:Vector.<Moon>;

			if (param == null)
			{
				luna = new Vector.<Moon> (1);
				luna[0] = new Moon ("0.0 0.0 0.0 0.0 0.0 0.0 1000.0 00ff00 15.0", 1);
			}
			else
			{
				var i:int = 0;
				luna = new Vector.<Moon> (parseInt (param));

				for (var j:int = 0; i < luna.length; ++j)
				{
					param = getParameter ("moon" + j);
					if (j > 2 * luna.length) break;
					if (param == null) continue;
					luna[i] = new Moon (param, j);
					++i;
				}
				var luna2:Vector.<Moon> = new Vector.<Moon> (i);

				for (var j:int = 0; j < i; ++j) luna2[j] = luna[j];

				luna = luna2;
			}

			if (Point.s2d (getParameter ("follow"), -1) != -1)
			{
				var tempint:int = Point.s2d (getParameter ("follow"), -1);
				for (var i:int = 0; i < luna.length; ++i)
				{
					if (luna[i].id == tempint)
					{
						this.follow = luna[i];
					}
				}
			}

			param = getParameter ("energy");
			energy = (param != null);

			var scalemass:Number = Point.s2d (getParameter ("scalemass"), 1.0);
			for (var i:int = 0; i < luna.length; ++i)
			{
				luna[i].m *= scalemass;
			}

			// the eye watching this world
			param = getParameter ("eye");
			if (param == null)
				param = "10.0  0.0  0.0  0.0  20.0";
			this.camera = new Eye (param, stage.stageWidth / 2, stage.stageHeight / 2);
			this.drag = false;
			this.oldmousex = 0.0;
			this.oldmousey = 0.0;
			this.mousex = 0.0;
			this.mousey = 0.0;
			this.rotatescale = this.camera.magnification / Math.min (stage.stageWidth, stage.stageHeight);
			this.sim = new Simulate (luna, this.increment, this.work, energy, noperspective);

			startRendering ();
		}

		private function startRendering ():void
		{
			mousex = x - this.camera.centerx;
			mousey = y - this.camera.centery;
			oldmousex = mousex;
			oldmousey = mousey;
			xymode = (4.0 * (mousex * mousex + mousey * mousey) < Math.min (this.camera.centerx * this.camera.centerx, this.camera.centery * this.camera.centery));
			drag = false;
			addEventListener (Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler (e:Event):void
		{
			update ();
		}

		private function createData ():void
		{
			params = {};
			params["increment"] = "140";
			params["work"] = "7";
			params["follow"] = "3";
			params["scalemass"] = "0.0000000012944";
			params["background"] = "000000";
			params["trail"] = "yes";
			params["energy"] = "yes";
			params["eye"] = "50 0 0.41487 0 500";
			params["moons"] = "11";
			params["moon3"] = "-0.008349066 0.000189290 0.000323565 0.000000048 -0.000000348 -0.000000150 396.89 ffff00 0.0093289";
			params["moon4"] = "-0.366950735 -0.233017122 -0.087053104 0.000427802 -0.000791151 -0.000466931 0.0000658 ffdddd 0.0000329";
			params["moon5"] = "0.517925495 -0.445522365 -0.233499924 0.000576233 0.000566230 0.000218276 0.00097029 ddffdd 0.0000817";
			params["moon1"] = "-0.18197903 0.88819973 0.38532644 -0.000717186 -0.000118962 -0.000051576 0.0012067 00ffff 0.0000847";
			params["moon6"] = "-1.596538576 0.436171769 0.243237864 -0.000152089 -0.000462584 -0.000208050 0.0001275 ff0000 0.0000451";
			params["moon7"] = "4.940498284 0.269444615 -0.004844226 -0.000019658 0.000301945 0.000129905 0.379 ffdd88 0.0009641";
			params["moon8"] = "7.791088486 4.739656899 1.622403811 -0.000137611 0.000178350 0.000079578 0.11348 ffffff 0.0008109";
			params["moon9"] = "13.408727053 -13.374109577 -6.047169310 0.000119777 0.000094894 0.000039867 0.01728 00ff00 0.0003452";
			params["moon10"] = "15.848452622 -23.573132782 -10.043179759 0.000110388 0.000065394 0.000024018 0.02038 0077ff 0.000334";
			params["moon11"] = "-10.984596612 -27.547235462 -5.287115643 0.000124706 -0.000051827 -0.000053747 0.000002575 ccccff 0.0000155";
		}

		public function startstop ():void
		{
			/*if (should_move && runner == null)
			 {
			 if (t > maxt)
			 { init (); }
			 runner = new Thread (this);
			 runner.start ();
			 }
			 else if (!should_move && runner != null && runner.isAlive ())
			 {
			 runner.stop ();
			 runner = null;
			 }*/
		}

		public function clear ():void
		{
			/*bg.graphics.beginFill (bgcolor.value);
			bg.graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);*/

			/*bg.setColor(bgcolor);
			 bg.fillRect(0, 0, width, height);
			 bg.setColor(bgcolor.gray);
			 bg.drawLine(0, 0, width, 0);
			 bg.drawLine(0, 0, 0, height);
			 bg.drawLine(width-1, 0, width-1, height-1);
			 bg.drawLine(0, height-1, width-1, height-1);*/
		}

		public function start ():void
		{
			// if objects should be moving, start them moving again
			startstop ();

			/*if (buffered == null)
			 {
			 buffered = createImage(width, height);
			 bg = buffered.getGraphics();
			 }*/

			// register that the screen needs painting
			//repaint ();
		}

		public function stop ():void
		{
			//runner = null;

			/*if (bg != null)
			 {
			 bg.dispose ();
			 bg = null;
			 }*/
			/*if (buffered != null)
			 {
			 buffered = null;
			 }*/
		}

		// mouse clicks turn the action on/off
		/*public function mouseUp (e:Event, x:int, y:int):Boolean
		{
			if (!drag)
			{
				should_move = (!should_move);
				startstop ();
			}
			drag = true;
			return true;
		}*/

		// mouse clicks turn the action on/off
		/*public function mouseDown (e:Event, x:int, y:int):Boolean
		{
			mousex = x - this.camera.centerx;
			mousey = y - this.camera.centery;
			oldmousex = mousex;
			oldmousey = mousey;
			xymode = (4.0 * (mousex * mousex + mousey * mousey) < Math.min (this.camera.centerx * this.camera.centerx, this.camera.centery * this.camera.centery));
			drag = false;
			return true;
		}*/

		// mouse clicks turn the action on/off
		/*public function mouseDrag (e:Event, x:int, y:int):Boolean
		{
			mousex = x - this.camera.centerx;
			mousey = y - this.camera.centery;
			return true;
		}*/

		public function run ():void
		{
			/*while (runner != null)
			 {
			 repaint ();    // notify paint() that it needs to run
			 //try {Thread.sleep(this.sleep);} catch (InterruptedException e) {}
			 if (t > maxt)
			 {
			 should_move = false;
			 runner = null;
			 }
			 }*/
		}

		// called by system in a separate thread when repaint() has been called.
		// Beware, several repaint()s may cause only one update() to happen.
		public function update ():void
		{
			paint ();
		}

		public function paint ():void
		{
			if (bg == null) return;     // there seem to be some race conditions


			trace ("paint");

			bg.graphics.beginFill (0x000000);
			bg.graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
			bg.graphics.endFill ();

			// find time increment
			if (t < 0.0)
			{
				clear ();
			}

			// erase old image
			/*if (!trail)
			{
				//bg.setColor (bgcolor);
				clear ();
			}*/

			// update camera
			var myx:Number = mousex;
			var myy:Number = mousey;
			var deltamousex:Number = myx - oldmousex;
			var deltamousey:Number = myy - oldmousey;
			if (deltamousex != 0 || deltamousey != 0)
			{
				drag = true;

				if (xymode)
				{          // xymode, roll simulation around the center
					var myrot:Number = Math.atan2 (deltamousex, deltamousey);
					var mynorm:Number = (deltamousex * deltamousex + deltamousey * deltamousey);
					camera.clockwise (-myrot);

					if (mynorm <= 10)
					{ // slow mouse can drag distant objects
						camera.up (Math.sqrt (mynorm) * (this.rotatescale / camera.magnification));
					}
					else
					{           // fast mouse spins quadratically fast
						camera.up (mynorm * this.rotatescale / (10 * camera.magnification));
					}
					camera.clockwise (myrot);
				}
				else
				{            // !xymode, zoom camera and spin it clockwise
					var mynorm:Number = oldmousex * oldmousex + oldmousey * oldmousey;
					if (mynorm > 0.5)
					{
						var myzoom:Number = Math.sqrt ((myx * myx + myy * myy) / mynorm);
						camera.zoom (myzoom);
						myx /= myzoom;
						myy /= myzoom;
						var myrot:Number = Math.asin ((oldmousey * myx - oldmousex * myy) / mynorm);
						camera.clockwise (myrot);
					}
				}
				oldmousex += int (deltamousex);
				oldmousey += int (deltamousey);
				if (trail)
				{
					clear ();
				}
			}
			if (follow != null)
			{
				camera.center (follow.p);
			}

			// draw the moons in their new positions
			sim.draw (bg, camera);

			// actually display the new image
			//this.getGraphics ().drawImage (buffered, 0, 0, null);

			// compute new positions
			sim.move ();
			t += 1.0;
		}


		public function getParameter (parameter:String):String
		{
			return params[parameter];
		}

	}
}
