package {
	import flash.display.*;
	import flash.filters.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;


	// From wonderfl.net
	//http://wonderfl.net/c/vYYZ
	public class ElementAutoPanning extends Sprite
	{
		public static var PANEL_TARGET :Object;
		public static var PANEL_STATE :Boolean;

		private var _output :Output;
		private var _panel :Panel;


		public function ElementAutoPanning()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);

			PANEL_STATE = false;

			_output = new Output("GUI Concept #2\n----------------------\n\nClick on any panel to observe auto-panning,\nuseful for large quantity of GUI elements or images\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe solution for this can be applied to n-dimensional objects\nand implements as follows for two-dimensional objects:\n\n> (observe ''fullTransition'' function starting @ line 126)");
		}

		public function addedToStage($e:*) :void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

			addChild(_output);

			for (var $x:int = 1; $x<=3; $x++)
			{
				for (var $y:int = 1; $y<=3; $y++)
				{
					_panel = new Panel(($x*93), ($y*93), 93, 93, ((93*3)-5), ((93*3)- 5));

					addChild(_panel);
				}
			}

			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		public function onMouseDown($e:MouseEvent) :void
		{
			for (var $:int = 0; $<numChildren; $++)
			{
				(getChildAt($) != PANEL_TARGET && getChildAt($) != _output) ? ((PANEL_STATE) ? addEventListener(Event.ENTER_FRAME, onFrame) : (removeEventListener(Event.ENTER_FRAME, onFrame), getChildAt($).visible = false)) : null;
			}
		}

		public function onFrame($e:*) :void
		{
			for (var $:int = 0; $<numChildren; $++)
			{
				(getChildAt($) != PANEL_TARGET && getChildAt($) != _output) ? ((PANEL_STATE) ? null : (getChildAt($).visible = true)) : null;
			}
		}
	}
}

import flash.display.*;
import flash.filters.*;
import flash.events.*;
import flash.utils.*;
import flash.geom.*;
import flash.text.*;

class Panel extends Sprite
{
	protected var _color :Number;
	protected var _closedX :Number;
	protected var _closedY :Number;
	protected var _openX :Number;
	protected var _openY :Number;
	protected var _width :Number;
	protected var _height :Number;
	protected var _openWidth :Number;
	protected var _openHeight :Number;
	protected var _closedWidth :Number;
	protected var _closedHeight :Number;
	protected var _transition :Boolean;

	public function Panel($closedX:Number, $closedY:Number, $openX:Number, $openY:Number, $openWidth:Number, $openHeight:Number)
	{
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);

		_color = 0xCCCCCC;
		_closedX = $closedX;
		_closedY = $closedY;
		_openX = $openX;
		_openY = $openY;
		_width = (($openWidth / 3) - 5);
		_height = (($openHeight / 3) -5);
		_openWidth = $openWidth;
		_openHeight = $openHeight;
		_closedWidth = _width;
		_closedHeight = _height;
		_transition = false;

		x = _closedX;
		y = _closedY;
	}

	public function addedToStage($e:*) :void
	{
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

		init();

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	}

	public function init() :void
	{
		graphics.clear();
		graphics.beginFill(_color);
		graphics.drawRect(0, 0, _width, _height);
		graphics.endFill();
	}

	public function fullTransition() :void
	{
		var $a :Boolean;
		var $b :Boolean;
		var $c :Boolean;
		var $d :Boolean;

		switch (_transition)
		{
			case true: //opened -> closed
				(x <= _closedX) ? (x += int(((_closedX+2) - x)/2)) : $a = true;
				(y <= _closedY) ? (y += int(((_closedY+2) - y)/2)) : $b = true;
				(width >= _closedWidth) ? (width -= int((width - (_closedWidth-2))/2)) : $c = true;
				(height >= _closedHeight) ? (height -= int((height - (_closedHeight-2))/2)) : $d = true;

				($a == true && $b == true && $c == true && $d == true) ? (_transition = ElementAutoPanning.PANEL_STATE = false, removeEventListener(Event.ENTER_FRAME, mouseDownBuffer)) : null;
				break;

			case false: //closed -> opened
				(x >= _openX) ? (x -= int((x - (_openX-2))/2)) : $a = true;
				(y >= _openY) ? (y -= int((y - (_openY-2))/2)) : $b = true;
				(width <= _openWidth) ? (width += int(((_openWidth+2) - width)/2)) : $c = true;
				(height <= _openHeight) ? (height += int(((_openHeight+2) - height)/2)) : $d = true;

				($a == true && $b == true && $c == true && $d == true) ? (_transition = ElementAutoPanning.PANEL_STATE = true, removeEventListener(Event.ENTER_FRAME, mouseDownBuffer)) : null;
				break;
		}
	}

	public function mouseDownBuffer($e:*) :void
	{
		fullTransition();
	}

	public function onMouseOver($e:MouseEvent) :void
	{
		(color != 0x999999) ? color = 0xBBBBBB : null;
	}

	public function onMouseDown($e:MouseEvent) :void
	{
		color = 0x999999;
		ElementAutoPanning.PANEL_TARGET = this;
		addEventListener(Event.ENTER_FRAME, mouseDownBuffer);
	}

	public function onMouseOut($e:MouseEvent) :void
	{
		(color != 0x999999) ? color = 0xCCCCCC : null;
	}

	public function onMouseUp($e:MouseEvent) :void
	{
		color = 0xCCCCCC;
	}

	public override function get width() :Number
	{return _width}
	public override function get height() :Number
	{return _height}
	public function get color() :Number
	{return _color}

	public override function set width($:Number) :void
	{_width = $; init()}
	public override function set height($:Number) :void
	{_height = $; init()}
	public function set color($:Number) :void
	{_color = $; init()}
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

		multiline = true;
		autoSize = "left";
		selectable = mouseEnabled = false;
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