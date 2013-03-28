package {
	import flash.events.Event;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.*;
	import flash.geom.*;


	public class HitTest_Arc_vs_Point extends Sprite {
		private var t:TextField;
		public function HitTest_Arc_vs_Point() {
			addEventListener(Event.ENTER_FRAME, frame);
			t = new TextField();
			t.width = 200;
			t.height = 16;
			addChild(t);
		}

		private function frame(e:Event):void {
			var cx:Number = 200; // center x of the arc
			var cy:Number = 300; // center y of the arc
			var rad:Number = 160; // radius of the arc
			var startAng:Number = 16 * Math.PI / 180; // start angle of the arc
			var endAng:Number = 280 * Math.PI / 180; // end angle of the arc
			t.text = "hit = " + calc(cx, cy, rad, startAng, endAng, mouseX, mouseY);
			graphics.clear();
			graphics.beginFill(0x808080);
			graphics.drawCircle(cx, cy, rad);
			graphics.lineStyle(1, 0x000000);
			graphics.moveTo(cx, cy);
			graphics.lineTo(cx + Math.cos(startAng) * rad, cy + Math.sin(startAng) * rad);
			graphics.moveTo(cx, cy);
			graphics.lineTo(cx + Math.cos(endAng) * rad, cy + Math.sin(endAng) * rad);
		}

		private function calc(cx:Number, cy:Number, rad:Number, startAng:Number, endAng:Number, px:Number, py:Number):Boolean {
			var dx:Number = px - cx;
			var dy:Number = py - cy;
			if(dx * dx + dy * dy > rad * rad) return false; // first test
			// var toRadians:Number = Math.PI / 180;
			// startAng = startAng * toRadians; // if angle is digree
			// endAng = endAng * toRadians;
			var sx:Number = Math.cos(startAng);
			var sy:Number = Math.sin(startAng);
			var ex:Number = Math.cos(endAng);
			var ey:Number = Math.sin(endAng);
			if(sx * ey - ex * sy > 0) {
				if(sx * dy - dx * sy < 0) return false; // second test
				if(ex * dy - dx * ey > 0) return false; // third test
				return true; // all test passed
			} else {
				if(sx * dy - dx * sy > 0) return true; // second test
				if(ex * dy - dx * ey < 0) return true; // third test
				return false; // all test passed
			}

		}

	}
}