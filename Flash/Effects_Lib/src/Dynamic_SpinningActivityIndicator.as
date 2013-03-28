package
{
	import com.bit101.components.HSlider;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.Label;
	import com.bit101.components.TextArea;
	import flash.display.Sprite;


	[SWF(frameRate="60")]
	public class Dynamic_SpinningActivityIndicator extends Sprite
	{
		private var spinner:Spinner;
		private var uiContainer:Object;
		private var uiPosition:Number;
		private var codeField:TextArea;
		public function Dynamic_SpinningActivityIndicator()
		{
			spinner = addChild(new Spinner(13, 7, 4, 10)) as Spinner;
			spinner.x = stage.stageWidth/2+90;
			spinner.y = stage.stageHeight/2;
			spinner.spin();

			uiContainer = {};
			uiPosition = 20;
			addSlider(13, 5, 18, "lineCount");
			addSlider(7, 0, 30, "length");
			addSlider(4, 2, 20, "thickness");
			addSlider(10, 0, 40, "radius");
			addSlider(1, 0, 1, "roundness");
			addSlider(1, 0.5, 2.2, "speed");
			addSlider(1, 0, 1, "trail");
			addSlider(0.25, 0, 1, "opacity");
			addSlider(0, 0, 360, "rotation");
			addColorChooser(0x000000, "color");
			addCheckBox(false, "shadow");

			codeField = new TextArea(this, 20, uiPosition, "");
			codeField.width = 160;
			codeField.editable = false;
			updateCode();
		}
		private function addSlider(defaultValue:Number, startValue:Number, endValue:Number, property:String):void
		{
			uiContainer[property] = new HSlider(this, 80, uiPosition, function():void{
				spinner[property] = uiContainer[property].value*0.01*(endValue-startValue)+startValue;
				updateCode();
			});
			if(defaultValue <= startValue)
				uiContainer[property].value = 0;
			else if(defaultValue >= endValue)
				uiContainer[property].value = 100;
			else
				uiContainer[property].value = (defaultValue-startValue)/(endValue-startValue)*100;
			new Label(this, 20, uiPosition-5, property);
			uiPosition += 20;
		}
		private function addColorChooser(defaultValue:uint, property:String):void
		{
			uiContainer[property] = new ColorChooser(this, 80, uiPosition, defaultValue, function():void{
				spinner[property] = uiContainer[property].value;
				updateCode();
			});
			new Label(this, 20, uiPosition-5, property);
			uiPosition += 25;
		}
		private function addCheckBox(defaultValue:Boolean, property:String):void
		{
			uiContainer[property] = new CheckBox(this, 20, uiPosition, property, function():void{
				spinner[property] = uiContainer[property].selected;
				updateCode();
			});
			uiContainer[property].selected = defaultValue;
			uiPosition += 20;
		}
		private function updateCode():void
		{
			codeField.text = "import spin.Spinner;\nvar spinner:Spinner = addChild(new Spinner("
					+spinner.lineCount
					+", "+spinner.length
					+", "+spinner.thickness
					+", "+spinner.radius
					+", "+spinner.roundness
					+", "+"0x"+spinner.color.toString(16).toUpperCase()
					+", "+spinner.speed
					+", "+spinner.trail
					+", "+spinner.opacity
					+", "+spinner.shadow+"));\nspinner.rotation = "+spinner.rotation+";";
		}

	}
}
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;
import flash.utils.getTimer;
/**
 * A spinning activity indicator
 */
internal class Spinner extends Sprite
{
	/**
	 * Rounds per second
	 */
	public var speed:Number;
	/**
	 * Afterglow (0..1)
	 */
	public var trail:Number;
	/**
	 * Opacity of the lines (0..1)
	 */
	public var opacity:Number;
	private static var dropShadowFilter:DropShadowFilter = new DropShadowFilter(2, 90, 0x000000, 1, 2, 2, 1, 2, false, false, false);
	private var _lineCount:int;
	private var _length:Number;
	private var _thickness:Number;
	private var _radius:Number;
	private var _roundness:Number;
	private var _color:uint;
	private var _shadow:Boolean;
	private var lines:Array;
	private var prevTime:int;
	private var lightPosition:Number;
	/**
	 * Create a Spinner instance
	 * @param lineCount The number of lines to draw
	 * @param length The length of each line
	 * @param thickness The line thickness
	 * @param radius The radius of the inner circle
	 * @param roundness Roundness (0..1)
	 * @param color The color of the line (0xRRGGBB)
	 * @param speed Rounds per second
	 * @param trail Afterglow (0..1)
	 * @param opacity Opacity of the lines (0..1)
	 * @param shadow Drop the shadow
	 */
	public function Spinner(lineCount:uint = 12, length:Number = 7, thickness:Number = 5, radius:Number = 10, roundness:Number = 1, color:uint = 0x000000, speed:Number = 1, trail:Number = 1, opacity:Number = 0.25, shadow:Boolean = false)
	{
		this._length = length;
		this._thickness = thickness;
		this._radius = radius;
		this._roundness = roundness;
		this._color = color;
		this._shadow = shadow;
		this.lineCount = lineCount;
		this.speed = speed;
		this.trail = trail;
		this.opacity = opacity;
		this.lightPosition = 0;
		animate(null);
	}
	/**
	 * The number of lines to draw
	 */
	public function set lineCount(value:int):void
	{
		this._lineCount = value;
		removeChildren();
		lines = [];
		for(var i:int=0; i<value; ++i)
		{
			lines.push(addChild(new Line));
			Line(lines[i]).rotation = 360/value*i;
		}
		update();
	}
	public function get lineCount():int
	{
		return this._lineCount;
	}
	/**
	 * The length of each line
	 */
	public function set length(value:Number):void
	{
		this._length = value;
		update();
	}
	public function get length():Number
	{
		return this._length;
	}
	/**
	 * The line thickness
	 */
	public function set thickness(value:Number):void
	{
		this._thickness = value;
		update();
	}
	public function get thickness():Number
	{
		return this._thickness;
	}
	/**
	 * The radius of the inner circle
	 */
	public function set radius(value:Number):void
	{
		this._radius = value;
		update();
	}
	public function get radius():Number
	{
		return this._radius;
	}
	/**
	 * Roundness (0..1)
	 */
	public function set roundness(value:Number):void
	{
		this._roundness = value;
		update();
	}
	public function get roundness():Number
	{
		return this._roundness;
	}
	/**
	 * The color of the line (0xRRGGBB)
	 */
	public function set color(value:uint):void
	{
		this._color = value;
		update();
	}
	public function get color():uint
	{
		return this._color;
	}
	/**
	 * Drop the shadow
	 */
	public function set shadow(value:Boolean):void
	{
		this._shadow = value;
		update();
	}
	public function get shadow():Boolean
	{
		return this._shadow;
	}
	/**
	 * Start spin
	 */
	public function spin():void
	{
		prevTime = getTimer();
		addEventListener(Event.ENTER_FRAME, animate);
	}
	/**
	 * Pause spin
	 */
	public function pause():void
	{
		removeEventListener(Event.ENTER_FRAME, animate);
	}
	private function animate(e:Event):void
	{
		var currentTime:int = getTimer();
		for(var i:int=1; i<_lineCount; ++i)
			Line(lines[int(i+lightPosition*_lineCount)%_lineCount]).alpha = trail==0?opacity:Math.max(i/_lineCount-1+trail, 0)/trail*(1-opacity)+opacity;
		Line(lines[int(lightPosition*_lineCount)%_lineCount]).alpha = 1;
		lightPosition = (lightPosition+(currentTime-prevTime)*speed*0.001)%1;
		prevTime = currentTime;
		update();
	}
	private function update():void
	{
		var line:Line;
		var lineCount:int = this.lines.length;
		for(var i:int=0; i<lineCount; ++i)
		{
			line = lines[i];
			line.length = _length;
			line.thickness = _thickness;
			line.radius = _radius;
			line.roundness = _roundness;
			line.color = _color;
			line.filters = _shadow?[dropShadowFilter]:null;
			line.update();
		}
	}
}
import flash.display.Shape;
internal class Line extends Shape
{
	public var length:Number;
	public var thickness:Number;
	public var radius:Number;
	public var roundness:Number;
	public var color:uint;
	public function Line()
	{
	}
	public function update():void
	{
		var ellipseRadius:Number = roundness*thickness;
		graphics.clear();
		graphics.beginFill(color);
		graphics.drawRoundRect(radius, -thickness*0.5, length+thickness, Math.max(ellipseRadius, thickness), ellipseRadius, ellipseRadius);
	}
}