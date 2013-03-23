/*
ActionScript 3 experiment by Dan Gries (djg@dangries.com) of www.dangries.com.
Dan is a friend of flashandmath.com.

Last modified: July 22, 2008.
*/


package com.dangries.bitmapUtilities {
	import flash.display.*;
	import flash.events.*;
	import com.dangries.geom3D.*;
	import com.dangries.objects.Particle3D;
	public class NoiseParticleMaker extends EventDispatcher {
		
		public static const PARTICLES_CREATED:String="particlesCreated";
		
		private var _particleArray:Array;
		public var numParticles:Number;
		
		public function NoiseParticleMaker(num):void {
			this._particleArray = [];
			this.numParticles = num;
		}

		public function createParticles():void {
			var c:uint;
			var r:Number;
			var g:Number;
			var b:Number;
			for (var i:Number=0; i<=numParticles-1; i++) {
				r = Math.random()*255;
				g = Math.random()*255;
				b = Math.random()*255;
				c = uint(0xFF000000 | int(r) << 16 | int(g) << 8 | int(b));
				var p:Particle3D = new Particle3D(c);
				//add to array			
				this.particleArray.push(p);
			}
			dispatchEvent(new Event(NoiseParticleMaker.PARTICLES_CREATED));
		}
				
		public function setGlobalAlpha(globalAlpha:Number):void {
			var c:uint;
			var p:Particle3D;
			trace(_particleArray.length);
			for (var t=0; t<= _particleArray.length - 1; t++) {
				p = _particleArray[t];
				p.setColor((uint(255*globalAlpha) << 24) | (p.color & 0x00FFFFFF));
			}
		}
		
		public function buildDestinationArrays(numDestinations:Number):void {
			var p:Particle3D;
			for (var t=0; t<= _particleArray.length - 1; t++) {
				p = _particleArray[t];
				for (var n:Number = 0; n <= numDestinations-1; n++) {
					var thisPoint3D:Point3D = new Point3D();
					p.dest.push(thisPoint3D);
				}
			}
		}
		
		public function get particleArray():Array {
			return _particleArray;
		}
		
	}
}