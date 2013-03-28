package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;

	[SWF(frameRate=2, width=1000, height=465)]
	public class SimpleProjectilePrediction extends Sprite
	{
		private var _unit :Unit;
		private var _enemy :Enemy;

		public function SimpleProjectilePrediction()
		{
			_unit = new Unit(233, 233);
			_enemy = new Enemy(433, 433);

			_unit.target = _enemy;

			addChild(_unit);
			addChild(_enemy);
		}
	}
}

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;

class Unit extends Sprite
{
	protected var _x :Number;
	protected var _y :Number;
	protected var _vX :Number;
	protected var _vY :Number;
	protected var _tar :Enemy;
	protected var _speed :Number;
	protected var _radius :Number;
	protected var _status :Boolean;

	public function Unit($x:Number, $y:Number, $speed:Number = 64)
	{
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);

		_x = $x;
		_y = $y;
		_vX = 0;
		_vY = 0;
		_tar = null;
		_speed = $speed; //greater = slower
		_radius = 2;
		_status = true;
	}

	public function addedToStage($e:*) :void
	{
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

		_vX = (_tar._x/_speed) + _tar.vX;
		_vY = (_tar._y/_speed) + _tar.vY;

		init();

		addEventListener(Event.ENTER_FRAME, onFrame);
	}

	public function init() :void
	{
		graphics.clear();
		graphics.lineStyle(1);
		graphics.drawCircle(_x, _y, (_radius*2));
		if (_tar != null)
		{
			graphics.lineStyle(1, 0xCCCCCC);
			//graphics.moveTo(_x, _y);
			//graphics.lineTo(_tar._x+(_tar._vX*_speed), _tar._y+(_tar._vY*_speed));
		}
	}

	public function projectile() :void
	{
		if (_status)
		{
			//(((_tar.x - (_tar.radius*1.45)) - (_x + (_radius*1.45))) < _vX) ? (_x += ((_tar.x - (_tar.radius*1.45)) - (_x + (_radius*1.45))), rotation*=180) : _x += _vX;
			//(((_tar.y - (_tar.radius*1.45)) - (_y + (_radius*1.45))) < _vY) ? (_y += ((_tar.y - (_tar.radius*1.45)) - (_y + (_radius*1.45))), rotation*=180) : _y += _vY;
		}else{
			visible = false;
		}

		x += _vX/2;
		y += _vY/2;
	}

	public function onFrame($e:*) :void
	{
		if (_tar != null)
		{
			projectile();
		}

		init();
	}

	public override function get x() :Number
	{return _x}
	public override function get y() :Number
	{return _x}
	public function get vX() :Number
	{return _vX}
	public function get vY() :Number
	{return _vY}
	public function get radius() :Number
	{return _radius}
	public function get target() :Enemy
	{return _tar}

	public override function set x($:Number) :void
	{_x = $; init()}
	public override function set y($:Number) :void
	{_y = $; init()}
	public function set vX($:Number) :void
	{_vX = $; init()}
	public function set vY($:Number) :void
	{_vY = $; init()}
	public function set radius($:Number) :void
	{_radius = $; init()}
	public function set target($:Enemy) :void
	{_tar = $}
}

class Enemy extends Sprite
{
	public var _x :Number;
	public var _y :Number;
	public var _vX :Number;
	public var _vY :Number;
	protected var _radius :Number;

	public function Enemy($x:Number, $y:Number)
	{
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);

		_x = $x;
		_y = $y;
		_vX = 5;
		_vY = -10;
		_radius = 10;
	}

	public function addedToStage($e:*) :void
	{
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

		init();

		addEventListener(Event.ENTER_FRAME, onFrame);
	}

	public function init() :void
	{
		graphics.clear();
		graphics.lineStyle(1, 0xFF0000);
		graphics.drawCircle(_x, _y, (_radius*2));
	}

	public function onFrame($e:*) :void
	{
		_x += _vX;
		_y += _vY;

		init();
	}

	public override function get x() :Number
	{return _x}
	public override function get y() :Number
	{return _x}
	public function get vX() :Number
	{return _vX}
	public function get vY() :Number
	{return _vY}
	public function get radius() :Number
	{return _radius}

	public override function set x($:Number) :void
	{_x = $; init()}
	public override function set y($:Number) :void
	{_y = $; init()}
	public function set vX($:Number) :void
	{_vX = $; init()}
	public function set vY($:Number) :void
	{_vY = $; init()}
	public function set radius($:Number) :void
	{_radius = $; init()}
}