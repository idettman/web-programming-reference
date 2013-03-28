package
{
	import adobe.utils.CustomActions;
	import com.bit101.components.HUISlider;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.Slider;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	//import net.hires.debug.Stats;
	/**
	 * ...
	 * @author lizhi http://game-develop.net/
	 */
	[SWF(frameRate=60)]
	public class CollidablePath extends Sprite
	{
		private var ballss:Vector.<Vector.<Sprite>> =new Vector.<Vector.<Sprite>>();
		public var startBall:Sprite;
		public var endBall:Sprite;
		public var start:VPoint = new VPoint;
		public var end:VPoint = new VPoint;
		public var lines:Vector.<VLine> = new Vector.<VLine>;
		public var lps:Vector.<VPoint> = new Vector.<VPoint>;
		private var nowVersion:int = 1;
		private var open:BinaryHeap;
		private var path:Vector.<VPoint>;
		private var silder:HUISlider;
		public function CollidablePath()
		{
			ballss.push(new Vector.<Sprite>);
			for (var i:int = 0; i < 7;i++ ) {
				ballss[0].push(createBall(i));
			}
			startBall = createBall(i);
			endBall = createBall(i);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
			addEventListener(Event.ENTER_FRAME, enterFrame);

			//addChild(new Stats);
			new PushButton(this, 0, 100, "add lines", createLines);
			silder = new HUISlider(this, 0, 120, "num");
			silder.tick = 1;
			silder.setSliderParams(3, 10, 5);
		}

		private function createLines(e:Event):void {
			ballss.push(new Vector.<Sprite>);
			for (var i:int = 0; i < silder.value; i++ ) {
				var s:Sprite = createBall(i);
				s.x = i * 100 + 100;
				s.y = 100+50*Math.random();
				ballss[ballss.length-1].push(s);
			}
		}

		private function enterFrame(e:Event):void
		{
			graphics.clear();
			graphics.lineStyle(0);

			lines.length = 0;
			lps.length = 0;
			for each(var balls:Vector.<Sprite> in ballss){
				for (var i:int = 0; i < balls.length-1; i++ ) {
					var line:VLine = new VLine;
					var p0:VPoint = new VPoint;
					p0.x = balls[i].x;
					p0.y = balls[i].y;
					var p1:VPoint = new VPoint;
					p1.x = balls[i+1].x;
					p1.y = balls[i + 1].y;

					var d:Point = p1.subtract(p0);
					d.normalize(1);
					p1.x += d.x;
					p1.y += d.y;
					p0.x -= d.x;
					p0.y -= d.y;

					line.p0 = p0;
					line.p1 = p1;
					lines.push(line);
					lps.push(p0,p1);
				}
			}

			start = new VPoint;
			start.x = startBall.x;
			start.y = startBall.y;
			end.x = endBall.x;
			end.y = endBall.y;
			for each(line in lines) {
				dline(line.p0, line.p1);
			}

			/*for each(line in lines) {
			 for (i = 0; i < line.ps.length; i++ ) {
			 graphics.lineStyle(0, passable(start,line.ps[i])?0xff00:0xff0000);
			 dline(start, line.ps[i]);
			 }
			 }*/

			nowVersion++;
			open = new BinaryHeap(justMin);
			start.g = 0;
			var node:VPoint = start;
			node.version = nowVersion;
			var flag:Boolean = true;
			while (!passable(node,end)) {
				for each(var test:VPoint in lps) {
					if (test == node||!passable(node,test)) {
						continue;
					}
					var cost:Number = Point.distance(node, test);
					var g:Number = node.g + cost;
					var h:Number = Point.distance(end, test);
					var f:Number = g + h;
					if (test.version==nowVersion) {
						if (test.f>f) {
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
						}
					}else {
						test.f = f;
						test.g = g;
						test.h = h;
						test.parent = node;
						open.ins(test);
						test.version = nowVersion;
					}
				}
				if (open.a.length==1) {
					flag = false;
					break;
				}
				node = open.pop() as VPoint;
			}
			path = new Vector.<VPoint>;
			if(flag){
				end.parent = node;
				node = end;
				path.push(node);
				while (node != start){
					node = node.parent;
					path.unshift(node);
				}
			}

			graphics.lineStyle(3, 0xffff, .5);
			for (i = 0; i < path.length-1;i++ ) {
				dline(path[i], path[i+1]);
			}
		}

		private function passable(p0:VPoint, p1:VPoint):Boolean {
			for each(var line:VLine in lines) {
				if (intersect(p0,p1,line.p0,line.p1)) {
					return false;
				}
			}
			return true;
		}

		private function dline(b1:VPoint, b2:VPoint):void {
			graphics.moveTo(b1.x, b1.y);
			graphics.lineTo(b2.x, b2.y);
		}

		private function stage_mouseUp(e:MouseEvent):void
		{
			stopDrag();
		}

		private function createBall(i:int):Sprite {
			var b:Sprite = new Sprite;
			var tf:TextField = new TextField;
			tf.mouseEnabled = tf.mouseWheelEnabled = false;
			b.addChild(tf);
			tf.autoSize = "left";
			tf.text = "" + i;
			tf.x = -tf.width / 2;
			tf.y = -tf.height / 2;
			b.graphics.beginFill(0xffffff * Math.random(), .7);
			b.graphics.drawCircle(0, 0, 10);
			b.x = Math.random() * stage.stageWidth;
			b.y = Math.random() * stage.stageHeight;
			b.addEventListener(MouseEvent.MOUSE_DOWN, onMD);
			addChild(b);
			return b;
		}

		private function onMD(e:Event):void {
			(e.currentTarget as Sprite).startDrag();
		}

		public static function intersect(p1:Point,p2:Point,p3:Point,p4:Point):Boolean {
			return((Math.max(p1.x,p2.x)>=Math.min(p3.x,p4.x))&&
					(Math.max(p3.x,p4.x)>=Math.min(p1.x,p2.x))&&
					(Math.max(p1.y,p2.y)>=Math.min(p3.y,p4.y))&&
					(Math.max(p3.y,p4.y)>=Math.min(p1.y,p2.y))&&
					(multiply(p3,p2,p1)*multiply(p2,p4,p1)>0)&&
					(multiply(p1,p4,p3)*multiply(p4,p2,p3)>0));
		}

		public static function multiply(sp:Point,ep:Point,op:Point):int {
			return((sp.x-op.x)*(ep.y-op.y)-(ep.x-op.x)*(sp.y-op.y));
		}
		private function justMin(x:Object, y:Object):Boolean {
			return x.f < y.f;
		}

	}

}
import flash.geom.Point;

class VLine
{
	public var p0:VPoint;
	public var p1:VPoint;
	public function VLine()
	{

	}

}
class VPoint extends Point
{
	public var line:VLine;
	public var g:Number;
	public var h:Number;
	public var f:Number;
	public var version:int = -1;
	public var parent:VPoint;
	public function VPoint()
	{

	}

}

class BinaryHeap {
	public var a:Array = [];
	public var justMinFun:Function = function(x:Object, y:Object):Boolean {
		return x < y;
	};

	public function BinaryHeap(justMinFun:Function = null){
		a.push(-1);
		if (justMinFun != null)
			this.justMinFun = justMinFun;
	}

	public function ins(value:Object):void {
		var p:int = a.length;
		a[p] = value;
		var pp:int = p >> 1;
		while (p > 1 && justMinFun(a[p], a[pp])){
			var temp:Object = a[p];
			a[p] = a[pp];
			a[pp] = temp;
			p = pp;
			pp = p >> 1;
		}
	}

	public function pop():Object {
		var min:Object = a[1];
		a[1] = a[a.length - 1];
		a.pop();
		var p:int = 1;
		var l:int = a.length;
		var sp1:int = p << 1;
		var sp2:int = sp1 + 1;
		while (sp1 < l){
			if (sp2 < l){
				var minp:int = justMinFun(a[sp2], a[sp1]) ? sp2 : sp1;
			} else {
				minp = sp1;
			}
			if (justMinFun(a[minp], a[p])){
				var temp:Object = a[p];
				a[p] = a[minp];
				a[minp] = temp;
				p = minp;
				sp1 = p << 1;
				sp2 = sp1 + 1;
			} else {
				break;
			}
		}
		return min;
	}
}