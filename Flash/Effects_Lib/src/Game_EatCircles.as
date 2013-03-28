package
{
	import flash.geom.*;
	import flash.events.*;
	import flash.display.*;

	[SWF(frameRate = 60, width = 465, height = 465)]
	public class Game_EatCircles extends Sprite
	{
		public function Game_EatCircles()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		public function addedToStage($e:Event) :void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

			Buffer.buildContext(this);

			_init();
		}

		public function _init() :void
		{
			graphics.clear();
			graphics.lineStyle(1, 0, 0.75);
			graphics.drawRect(0, 0, 464, 464);
		}
	}
}

import flash.text.*;
import flash.geom.*;
import flash.events.*;
import flash.display.*;

class Buffer
{
	public static var instanceUser :Object;
	public static var instanceOutput :Output;
	public static var instanceContext :Object;
	public static var instanceList :Array;
	public static var enemyCount :int;

	public static function buildContext($context:Object) :void
	{
		instanceContext = $context;
		instanceList = [];
		enemyCount = 20;

		instanceList.push(instanceUser = new User());
		for (var $:int = 0; $ < enemyCount; $++)
		{instanceList.push(new Enemy())}

		for (var $i:int = 0; $i < instanceList.length; $i++)
		{$context.addChild(instanceList[$i])}

		$context.addChild(instanceOutput = new Output(""));

		$context.addEventListener(Event.ENTER_FRAME, applyConstraints);
		$context.addEventListener(Event.ENTER_FRAME, gameLogic);
	}

	public static function applyConstraints($e:Event) :void
	{
		for (var $i:int = 0; $i < instanceList.length; $i++)
		{
			var $x :Number = instanceList[$i].x;
			var $y :Number = instanceList[$i].y;
			var $s :Number = instanceList[$i].size;

			if (instanceList[$i] is User)
			{
				if ($x < (0 - $s))
				{instanceList[$i].x = (465 + $s)}
				if ($x > (465 + $s))
				{instanceList[$i].x = (0 - $s)}
				if ($y < (0 - $s))
				{instanceList[$i].y = (465 + $s)}
				if ($y > (465 + $s))
				{instanceList[$i].y = (0 - $s)}
			}
			else if (instanceList[$i] is Enemy)
			{
				if ($x < (0 - $s))
				{instanceList[$i].x = (465 + $s); instanceList[$i].y = (30 + Math.random() * 405)}
				if ($x > (465 + $s))
				{instanceList[$i].x = (0 - $s); instanceList[$i].y = (30 + Math.random() * 405)}
				if ($y < (0 - $s))
				{instanceList[$i].y = (465 + $s)}
				if ($y > (465 + $s))
				{instanceList[$i].y = (0 - $s)}
			}
		}
	}

	public static function gameLogic($e:Event) :void
	{
		for (var $i:int = 0; $i < instanceList.length; $i++)
		{
			if (instanceList[$i] != instanceUser)
			{
				if (calcDistance(instanceUser, instanceList[$i]) < (instanceUser.size + instanceList[$i].size))
				{
					if (instanceUser.size >= instanceList[$i].size)
					{
						instanceContext.removeChild(instanceList[$i]);
						instanceList.splice($i, 1);

						instanceList.push(new Enemy());
						instanceContext.addChild(instanceList[instanceList.length-1]);

						instanceUser.newSize = instanceUser.size + 2;
					}else{
						//gameover
					}
				}
			}
		}
	}

	public static function calcDistance($1:Object, $2:Object) :int
	{
		var $dx :int = ($2.x - $1.x);
		var $dy :int = ($2.y - $1.y);

		return int(Math.sqrt(($dx * $dx) + ($dy * $dy)));
	}
}

class User extends Sprite
{
	private var KEY_W :Boolean;
	private var KEY_A :Boolean;
	private var KEY_S :Boolean;
	private var KEY_D :Boolean;
	private var SHIFT :Boolean;

	protected var _x :Number;
	protected var _y :Number;
	protected var _s :Number;
	protected var _vx :Number;
	protected var _vy :Number;

	public var newSize :Number;

	public function User($x:Number = 232.5, $y:Number = 232.5, $s:Number = 10)
	{
		KEY_W = KEY_A = KEY_S = KEY_D = false;

		_x = $x;
		_y = $y;
		_s = $s;
		_vx = _vy = 0;

		newSize = _s;

		addEventListener(Event.ADDED_TO_STAGE, addedToStage);
	}

	public function addedToStage($e:Event) :void
	{
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

		_init();

		addEventListener(Event.ENTER_FRAME, _update);
		addEventListener(Event.ENTER_FRAME, _animate);
		addEventListener(Event.ENTER_FRAME, _update);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	public function _init() :void
	{
		graphics.clear();
		graphics.lineStyle(1, 0x00B300, 0.75);
		graphics.drawCircle(_x, _y, _s);
	}

	public function _update($e:Event) :void
	{
		if (KEY_W)
		{_vy = (SHIFT) ? -1.5 : -1}
		if (KEY_A)
		{_vx = (SHIFT) ? -1.5 : -1}
		if (KEY_S)
		{_vy = (SHIFT) ? 1.5 : 1}
		if (KEY_D)
		{_vx = (SHIFT) ? 1.5 : 1}
		if (!KEY_W || !KEY_A || !KEY_S || !KEY_D)
		{
			if (_vx > 0)
			{_vx -= 0.025}
			else if (_vx < 0)
			{_vx += 0.025}

			if (_vy > 0)
			{_vy -= 0.025}
			else if (_vy < 0)
			{_vy += 0.025}
		}

		_x += _vx;
		_y += _vy;
		_init();
	}

	public function _animate($e:Event) :void
	{
		if (_s != newSize)
		{
			if (_s < (newSize + 2))
			{
				size += 1.01;
			}else{
				size = newSize;
			}
		}
	}

	public function onKeyDown($e:KeyboardEvent) :void
	{
		switch ($e.keyCode)
		{
			case 87: //w
				KEY_W = true;
				break;
			case 65: //a
				KEY_A = true;
				break;
			case 83: //s
				KEY_S = true;
				break;
			case 68: //d
				KEY_D = true;
				break;
			case 16: //shift
				SHIFT = true;
				break;
		}

		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}

	public function onKeyUp($e:KeyboardEvent) :void
	{
		switch ($e.keyCode)
		{
			case 87: //w
				KEY_W = false;
				break;
			case 65: //a
				KEY_A = false;
				break;
			case 83: //s
				KEY_S = false;
				break;
			case 68: //d
				KEY_D = false;
				break;
			case 16: //shift
				SHIFT = false;
				break;
		}
	}

	public function get vx() :Number
	{ return _vx }
	public function get vy() :Number
	{ return _vy }
	public function get size() :Number
	{ return _s }
	public override function get x() :Number
	{ return _x }
	public override function get y() :Number
	{ return _y }

	public function set vx($:Number) :void
	{ _vx = $; _init() }
	public function set vy($:Number) :void
	{ _vy = $; _init() }
	public function set size($:Number) :void
	{ _s = $; _init() }
	public override function set x($:Number) :void
	{ _x = $; _init() }
	public override function set y($:Number) :void
	{ _y = $; _init() }
}

class Enemy extends Sprite
{
	private var sizeDisplay :Boolean;
	private var sizeOutput :Output;

	protected var _x :Number;
	protected var _y :Number;
	protected var _s :Number;
	protected var _vx :Number;
	protected var _vy :Number;

	public function Enemy()
	{
		_x = ((Math.random() * -1) * 100);
		_y = (30 + int(Math.random() * 405));
		_s = (5 + int(Math.random() * 30));
		_vx = (-2 + int(Math.random() * 4));
		_vy = 0;

		while (_vx == 0)
		{_vx = (-2 + int(Math.random() * 4))}

		sizeDisplay = false;
		sizeOutput = new Output("" + (_s > 10) ? "" : _s.toString());

		addEventListener(Event.ADDED_TO_STAGE, addedToStage);
	}

	public function addedToStage($e:Event) :void
	{
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

		addChild(sizeOutput);

		_init();

		addEventListener(Event.ENTER_FRAME, _update);
	}

	public function _init() :void
	{
		graphics.clear();
		graphics.lineStyle(1, 0, 0.75);
		graphics.beginFill(0xFFFFFF);
		graphics.drawCircle(_x, _y, _s);
		graphics.endFill();

		if (sizeDisplay)
		{
			sizeOutput.content = "" + _s;
			sizeOutput.x = _x - (sizeOutput.width / 2);
			sizeOutput.y = _y - (sizeOutput.height / 2);
		}
	}

	public function _update($e:Event) :void
	{
		_x += _vx;
		_y += _vy;

		if (Buffer.instanceUser.size >= _s)
		{sizeDisplay = false; sizeOutput.content = ""}
		else {sizeDisplay = true}

		_init();
	}

	public function get vx() :Number
	{ return _vx }
	public function get vy() :Number
	{ return _vy }
	public function get size() :Number
	{ return _s }
	public override function get x() :Number
	{ return _x }
	public override function get y() :Number
	{ return _y }

	public function set vx($:Number) :void
	{ _vx = $; _init() }
	public function set vy($:Number) :void
	{ _vy = $; _init() }
	public function set size($:Number) :void
	{ _s = $; _init() }
	public override function set x($:Number) :void
	{ _x = $; _init() }
	public override function set y($:Number) :void
	{ _y = $; _init() }
}

class Output extends TextField
{
	private var textFormat :TextFormat;

	protected var _x :Number;
	protected var _y :Number;
	protected var _font :String;
	protected var _content :String;

	public function Output($content:String, $x:Number = 1, $y:Number = 0, $font:String = "Helvetica")
	{
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);

		_x = $x;
		_y = $y;
		_font = $font;
		_content = $content;

		selectable = mouseEnabled = false;
		autoSize = TextFieldAutoSize.CENTER;
		antiAliasType = AntiAliasType.ADVANCED;
	}

	public function _init() :void
	{
		x = _x;
		y = _y;
		text = _content;
		textFormat = new TextFormat(_font);
		setTextFormat(textFormat);
	}

	public function addedToStage($e:Event) :void
	{
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

		_init();
	}

	public function get font() :String
	{ return _font }
	public function get nWidth() :Number
	{ return width }

	public function set font($:String) :void
	{ _font = $; _init() }
	public function set content($:String) :void
	{ _content = $; _init() }
}