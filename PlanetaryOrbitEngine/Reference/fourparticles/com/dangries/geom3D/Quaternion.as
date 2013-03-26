package com.dangries.geom3D {
	public class Quaternion {
		public var w;
		public var x;
		public var y;
		public var z;
		
		private var qOutput:Quaternion;
		
		public function Quaternion(_w=0,_x=0, _y=0, _z=0) {
			this.w = _w;
			this.x = _x;
			this.y = _y;
			this.z = _z;
		}
		
		public function clone():Quaternion {
			return new Quaternion(this.w, this.x, this.y, this.z);
		}
		
		public function add(q:Quaternion):Quaternion {
			qOutput = new Quaternion()
			qOutput.w = this.w + q.w;
			qOutput.x = this.x + q.x;
			qOutput.y = this.y + q.y;
			qOutput.z = this.z + q.z;
			return qOutput;
		}
		
		public function subtract(q:Quaternion):Quaternion {
			qOutput = new Quaternion()
			qOutput.w = this.w - q.w;
			qOutput.x = this.x - q.x;
			qOutput.y = this.y - q.y;
			qOutput.z = this.z - q.z;
			return qOutput;
		}
		
		public function normalize():Quaternion {
			qOutput = new Quaternion()
			var mag = Math.sqrt(this.w*this.w + this.x*this.x + this.y*this.y + this.z*this.z);
			qOutput.w = this.w/mag;
			qOutput.x = this.x/mag;
			qOutput.y = this.y/mag;
			qOutput.z = this.z/mag;
			return qOutput;
		}
		
		public function magnitudeSquare():Number {
			return this.w*this.w + this.x*this.x + this.y*this.y +this.z*this.z;
		}
		
		public function toString(radix:int):String {
			return "(" + this.w.toFixed(radix) + ", " + this.x.toFixed(radix) + ", " + this.y.toFixed(radix) + ", " + this.z.toFixed(radix) + ")";
		}

	}
}
