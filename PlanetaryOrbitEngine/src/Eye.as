package
{
	public class Eye
	{
		public var centerx:Number;  // place 0.0,0.0 at (centerx, centery) on screen
		public var centery:Number;  // place 0.0,0.0 at (centerx, centery) on screen
		public var magnification:Number;   // magnification of image
		public var m:Vector.<Point>;    // matrix describing angle & position
		public var d:Vector.<Point>;           // matrix used to add rotations
		public var rslm:Vector.<Point>;        // temporary result of matrix multiplication
		public var p:Point;             // temporary point

		// distance-from-center, left up clockwise magnification
		// example, "10.0 0.0 0.0 0.0 10.0"
		public function Eye (s:String, centerx:Number, centery:Number)
		{
			var st:StringTokenizer = new StringTokenizer (s);
			this.p = new Point (0.0, 0.0, 0.0);

			this.p.x = 0.0;
			this.p.y = 0.0;
			this.p.z = -Point.s2d (st.nextToken (), 10.0);
			var left:Number = Point.s2d (st.nextToken (), 0.0);
			var up:Number = Point.s2d (st.nextToken (), 0.0);
			var clockwise:Number = Point.s2d (st.nextToken (), 0.0);
			var magnification:Number = Point.s2d (st.nextToken (), 1.0);
			
			setEye (this.p, left, up, clockwise, centerx, centery, magnification);
		}

		/*public function Eye (p:Point, left:Number, up:Number, clockwise:Number, centerx:int, centery:int, magnification:Number)
		{
			setEye (p, left, up, clockwise, centerx, centery, magnification);
		}*/

		public function setEye (p:Point, 	// position of eye (done first)
				left:Number,             	// radians to rotate left (done second)
				up:Number,               	// radians to rotate up   (third)
				clockwise:Number,        	// radians to rotate clockwise (fourth)
				centerx:Number,             	// center of panel, x coord
				centery:Number,             	// center of panel, y coord
				magnification:Number):void  // controls size of image within panel
		{
			this.centerx = centerx;
			this.centery = centery;
			this.magnification = magnification;

			m = new Vector.<Point>(5);
			m[0] = new Point (1.0, 0.0, 0.0);
			m[1] = new Point (0.0, 1.0, 0.0);
			m[2] = new Point (0.0, 0.0, 1.0);
			m[3] = new Point (p.x, p.y, p.z);
			m[4] = new Point (0.0, 0.0, 0.0);
			d = new Vector.<Point>(3);
			d[0] = new Point (0.0, 0.0, 0.0);
			d[1] = new Point (0.0, 0.0, 0.0);
			d[2] = new Point (0.0, 0.0, 0.0);
			rslm = new Vector.<Point>(3);
			rslm[0] = new Point (0.0, 0.0, 0.0);
			rslm[1] = new Point (0.0, 0.0, 0.0);
			rslm[2] = new Point (0.0, 0.0, 0.0);
			this.left (left);
			this.up (up);
			this.clockwise (clockwise);
		}

		// spin world left by x radians
		public function left (x:Number):void
		{
			d[0].x = Math.cos (x);
			d[0].y = 0.0;
			d[0].z = Math.sin (x);
			d[1].x = 0.0;
			d[1].y = 1.0;
			d[1].z = 0.0;
			d[2].x = -Math.sin (x);
			d[2].y = 0.0;
			d[2].z = Math.cos (x);
			mdt ();
		}

		// spin world up by x radians
		public function up (x:Number):void
		{
			d[0].x = 1.0;
			d[0].y = 0.0;
			d[0].z = 0.0;
			d[1].x = 0.0;
			d[1].y = Math.cos (x);
			d[1].z = Math.sin (x);
			d[2].x = 0.0;
			d[2].y = -Math.sin (x);
			d[2].z = Math.cos (x);
			mdt ();
		}

		// spin clockwise by x radians
		public function clockwise (x:Number):void
		{
			d[0].x = Math.cos (x);
			d[0].y = Math.sin (x);
			d[0].z = 0.0;
			d[1].x = -Math.sin (x);
			d[1].y = Math.cos (x);
			d[1].z = 0.0;
			d[2].x = 0.0;
			d[2].y = 0.0;
			d[2].z = 1.0;
			mdt ();
		}

		// move the viewpoint
		public function center (p:Point):void { m[4].copy (p); }

		public function move (p:Point):void { m[3].plusa (m[3], 1.0, p); }

		public function zoom (scale:Number):void { magnification *= scale; }

		// m = D times M-Transpose
		public function mdt ():void
		{
			var tempValue:Point;
			rslm[0].x = m[0].x * d[0].x + m[1].x * d[0].y + m[2].x * d[0].z;
			rslm[0].y = m[0].y * d[0].x + m[1].y * d[0].y + m[2].y * d[0].z;
			rslm[0].z = m[0].z * d[0].x + m[1].z * d[0].y + m[2].z * d[0].z;
			rslm[1].x = m[0].x * d[1].x + m[1].x * d[1].y + m[2].x * d[1].z;
			rslm[1].y = m[0].y * d[1].x + m[1].y * d[1].y + m[2].y * d[1].z;
			rslm[1].z = m[0].z * d[1].x + m[1].z * d[1].y + m[2].z * d[1].z;
			rslm[2].x = m[0].x * d[2].x + m[1].x * d[2].y + m[2].x * d[2].z;
			rslm[2].y = m[0].y * d[2].x + m[1].y * d[2].y + m[2].y * d[2].z;
			rslm[2].z = m[0].z * d[2].x + m[1].z * d[2].y + m[2].z * d[2].z;
			tempValue = rslm[0];
			rslm[0] = m[0];
			m[0] = tempValue;
			tempValue = rslm[1];
			rslm[1] = m[1];
			m[1] = tempValue;
			tempValue = rslm[2];
			rslm[2] = m[2];
			m[2] = tempValue;
		}

		// map a real point to a point from the eye's perspective
		public function map (pout:Point, pin:Point):void
		{
			p.minus (pin, m[4]);
			pout.x = p.dot (m[0]);
			pout.y = p.dot (m[1]);
			pout.z = p.dot (m[2]);
			pout.minus (pout, m[3]);
		}

		// get the x pixel for this (already-translated) point
		public function mapx (p:Point):Number
		{
			return centerx + (magnification * p.x / p.z);
		}

		// get the y pixel for this (already-translated) point
		public function mapy (p:Point):Number
		{
			return centery + (magnification * p.y / p.z);
		}
	}
}
