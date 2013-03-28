// forked from Test_Dept's forked from: Involute Curve
// forked from Test_Dept's Involute Curve
// forked from Test_Dept's GeomTest II
package {

	import flash.display.Sprite;


	[SWF(backgroundColor="#ffffff", width="465", height="465")]
	public class Gear extends Sprite {

		public function Gear() {
			addChild(new GearImpl() );
		}
	}
}

import flash.display.Graphics;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;


class GearImpl extends Sprite {

	public function GearImpl() {
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	private function addedToStageHandler(event : Event) : void {

		var system : GearSystem = new GearSystem(40, 0.3);
		system.showGuide = true;

		var gearAlpha : Number = 0.5;

		var cx : Number = stage.stageWidth / 2;
		var cy : Number = stage.stageHeight / 2;

		var gear1 : InvoluteGear = system.createInvoluteGear(7, 0x0000ff);
		gear1.alpha = gearAlpha;
		gear1.x = cx - gear1.pitchRadius;
		gear1.y = cy;
		addChild(gear1);

		var gear2 : InvoluteGear = system.createInvoluteGear(16, 0x00ff00);
		gear2.alpha = gearAlpha;
		gear2.x = cx + gear2.pitchRadius;
		gear2.y = cy;
		gear2.rotation = 180;
		addChild(gear2);

		var gear3 : RackGear = system.createRackGear(10, 0xff00cc);
		gear3.alpha = gearAlpha;
		gear3.x = cx;
		gear3.y = cy + gear3.pitch * 5;
		addChild(gear3);
		gear3.rotation = 180;

		stage.addEventListener(MouseEvent.MOUSE_MOVE, function(event : Event) : void {
			var angle : Number = (mouseY - cy);
			gear1.rotation = angle;
			gear2.rotation = 180 - angle * gear1.numTeeth / gear2.numTeeth;
			gear3.y = cy + gear3.pitch * 5
					+ (angle * Math.PI / 180) * gear1.pitchRadius;
		} );
	}
}

class GearSystem {

	private var _module : Number;
	private var _pressureAngle : Number;
	private var _ascRatio : Number;
	private    var _descRatio : Number;
	private var _showGuide : Boolean;

	public function GearSystem(
			module : Number,
			pressureAngle : Number = 0.4,
			ascRatio : Number = 1.0,
			descRatio : Number = 1.25
			) {
		_module = module;
		_pressureAngle = pressureAngle;
		_ascRatio = ascRatio;
		_descRatio = descRatio;
		_showGuide = false;
	}

	public function get module() : Number {
		return _module;
	}

	public function get pressureAngle() : Number {
		return _pressureAngle;
	}

	public function get ascRatio() : Number {
		return _ascRatio;
	}

	public function get descRatio() : Number {
		return _descRatio;
	}

	public function get showGuide() : Boolean {
		return _showGuide;
	}

	public function set showGuide(value : Boolean) : void {
		_showGuide = value;
	}

	public function createRackGear(numTeeth : int, color : uint = 0x666666) : RackGear {
		return new RackGear(this, numTeeth, color);
	}

	public function createInvoluteGear(numTeeth : int, color : uint = 0x666666) : InvoluteGear {
		return new InvoluteGear(this, numTeeth, color);
	}
}

class GearBase extends Sprite {

	private var _system : GearSystem;
	private var _numTeeth : int;
	private var _color : uint;

	public function GearBase(system : GearSystem, numTeeth : int, color : uint) {

		_system = system;
		_numTeeth = numTeeth;
		_color = color;

		setupProperties();

		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	public function get system() : GearSystem {
		return _system;
	}

	public function get numTeeth() : Number {
		return _numTeeth;
	}

	protected function setupProperties() : void {
	}

	private function addedToStageHandler(event : Event) : void {
		draw();
	}

	private function draw() : void {

		var cmds : Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
		cmds.push(
				new GraphicsSolidFill(_color),
				getGearPath(),
				new GraphicsEndFill()
		);

		var g : Graphics = graphics;

		g.clear();

		g.drawGraphicsData(cmds);

		if (system.showGuide) {
			drawGuide(g);
		}
	}

	protected function drawGuide(g : Graphics) : void {
		// for debug.
	}

	public function getGearPath() : GraphicsPath {
		throw new Error("not implemented");
	}
}

class RackGear extends GearBase {

	private var _top : Number;
	private var _bottom : Number;
	private var _pitch : Number;

	public function RackGear(system : GearSystem, numTeeth : int, color : uint) {
		super(system, numTeeth, color);
	}

	public function get pitch() : Number {
		return _pitch;
	}

	override protected function setupProperties() : void {

		_top = system.ascRatio * system.module;
		_bottom = -system.descRatio * system.module;
		_pitch = system.module * Math.PI;
	}

	override protected function drawGuide(g : Graphics) : void {

		var yFrom : Number = _bottom * Math.tan(system.pressureAngle);
		var yTo : Number = yFrom + _pitch * numTeeth;

		g.lineStyle(1, 0x000000);
		g.moveTo(0, yFrom);
		g.lineTo(0, yTo);

		g.lineStyle(1, 0xff0000);
		g.moveTo(_top, yFrom);
		g.lineTo(_top, yTo);
		g.moveTo(_bottom, yFrom);
		g.lineTo(_bottom, yTo);
	}

	override public function getGearPath() : GraphicsPath {
		var path : GraphicsPath = new GraphicsPath();
		for (var t : int = 0; t < numTeeth; t++) {
			drawTeeth(path, t);
		}
		return path;
	}

	private function drawTeeth(path : GraphicsPath, t : int) : void {

		var offsetY : Number = t * _pitch;
		var tanP : Number = Math.tan(system.pressureAngle);

		if (t == 0) {
			path.moveTo(_bottom, offsetY + _bottom * tanP);
		} else {
			path.lineTo(_bottom, offsetY + _bottom * tanP);
		}
		path.lineTo(_top, offsetY + _top * tanP);
		path.lineTo(_top, offsetY + _pitch / 2 - _top * tanP);
		path.lineTo(_bottom, offsetY + _pitch / 2 - _bottom * tanP);
	}
}

class InvoluteGear extends GearBase {

	private var _teethAngle : Number;
	private var _pitchRadius : Number;
	private var _pitchAngle : Number;
	private var _baseRadius : Number;
	private var _topRadius : Number;
	private var _topAngle : Number;
	private var _bottomRadius : Number;
	private var _bottomAngle : Number;

	public function InvoluteGear(system : GearSystem, numTeeth : int, color : uint) {
		super(system, numTeeth, color);
	}

	public function get pitchRadius() : Number {
		return _pitchRadius;
	}

	override protected function setupProperties() : void {

		_teethAngle = 2 * Math.PI / numTeeth;
		_pitchRadius = system.module * numTeeth / 2;
		_baseRadius = _pitchRadius * Math.cos(system.pressureAngle);
		_topRadius = _pitchRadius + system.ascRatio * system.module;
		_bottomRadius = _pitchRadius - system.descRatio * system.module;
		_pitchAngle = _pitchRadius * Math.sin(system.pressureAngle) / _baseRadius;

		function getAngleForBaseRadius(r : Number) : Number {
			return Math.sqrt(r * r - _baseRadius * _baseRadius) / _baseRadius;
		}
		_topAngle = getAngleForBaseRadius(_topRadius);
		_bottomAngle = getAngleForBaseRadius(Math.max(_bottomRadius, _baseRadius) );
	}

	override protected function drawGuide(g : Graphics) : void {

		g.lineStyle(1, 0);
		g.drawCircle(0, 0, _pitchRadius);

		g.lineStyle(1, 0xcccccc);
		g.drawCircle(0, 0, _baseRadius);

		g.lineStyle(1, 0xff0000);
		g.drawCircle(0, 0, _topRadius);
		g.drawCircle(0, 0, _bottomRadius);

		var mat : Matrix = new Matrix();
		mat.rotate(system.pressureAngle);

		var p : Point = mat.transformPoint(new Point(_baseRadius, 0) );

		g.lineStyle(1, 0x0000ff);
		g.moveTo(0, 0);
		g.lineTo(_pitchRadius, 0);
		g.lineTo(p.x, p.y);
		g.lineTo(0, 0);
	}

	override public function getGearPath() : GraphicsPath {
		var path : GraphicsPath = new GraphicsPath();
		for (var t : int = 0; t < numTeeth; t++) {
			drawTeeth(path, t);
		}
		return path;
	}

	private function drawTeeth(path : GraphicsPath, t : int) : void {

		var offsetT : Number = t * _teethAngle;
		var dt1 : Number = system.pressureAngle - _pitchAngle;

		var offsetR : Number = _topRadius - _pitchRadius;
		var dt2 : Number = offsetR
				* Math.tan(system.pressureAngle) / _pitchRadius;
		var dr : Number = _pitchRadius - offsetR;
		var baseAngle : Number = Math.sqrt(
				_baseRadius * _baseRadius - dr * dr) / _pitchRadius;

		var dig :Boolean = _pitchRadius - (_topRadius - _pitchRadius) < _baseRadius;

		var pointsArray : Array = new Array();

		if (dig) {
			pointsArray.push(
					GeoUtil.getInvolutePoints(_pitchRadius, -offsetR,
							0, -baseAngle, offsetT - dt2) );
		}

		pointsArray.push(
				GeoUtil.getInvolutePoints(_baseRadius, 0,
						_bottomAngle, _topAngle, offsetT + dt1),
				GeoUtil.getInvolutePoints(_baseRadius, 0,
						-_topAngle, -_bottomAngle, offsetT - dt1 + _teethAngle / 2) );

		if (dig) {
			pointsArray.push(
					GeoUtil.getInvolutePoints(_pitchRadius, -offsetR,
							baseAngle, 0, offsetT + dt2 + _teethAngle / 2) );
		}

		for (var i : int = 0; i < pointsArray.length; i++) {

			var lastP : Array = null;

			var points : Array = pointsArray[i];

			for (var j : int = 0; j < points.length; j++) {

				var p : Array = points[j];

				if (lastP != null) {

					var c : Point = GeoUtil.getCrossPoint(
							lastP[2], lastP[1], p[2], p[1]);
					path.curveTo(c.x, c.y, p[1].x, p[1].y);

				} else{
					if (t == 0 && i == 0) {
						path.moveTo(p[1].x, p[1].y);
					} else {
						path.lineTo(p[1].x, p[1].y);
					}
				}

				lastP = p;
			}
		}
	}
}

class GeoUtil {

	public static function getInvolutePoints(
			r : Number,
			offsetR : Number,
			minT : Number,
			maxT : Number,
			offsetT : Number,
			dt : Number = 0.314
			) : Array {

		var points : Array = new Array();

		var div : int = Math.max(1, Math.abs( (maxT - minT) / dt) );

		for (var i : int = 0; i <= div; i++) {

			var t : Number = (maxT - minT) * i / div + minT;

			var mat : Matrix = new Matrix();
			mat.rotate(offsetT + t);

			points.push([
				mat.transformPoint(new Point(r, 0) ),
				mat.transformPoint(new Point(r + offsetR, -r * t) ),
				mat.transformPoint(new Point(r, (t == 0)? 1 : 0) )
			]);
		}

		return points;
	}

	public static function getCrossPoint(
			a1 : Point, a2 : Point,
			b1 : Point, b2 : Point
			) : Point {

		var a12 : Point = a2.subtract(a1);
		var b12 : Point = b2.subtract(b1);

		var mat : Matrix = new Matrix(
				-a12.y, a12.x,
				-b12.y, b12.x);

		mat.invert();

		var st : Point = mat.transformPoint(b2.subtract(a2) );

		var s : Number = st.x;

		return new Point(
				a2.x - a12.y * s,
				a2.y + a12.x * s);
	}
}

