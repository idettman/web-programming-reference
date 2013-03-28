package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import frocessing.color.ColorHSV;


	[SWF(width="465", height="465", frameRate="60")]
	public class PrismColorDrawing extends Sprite
	{
		private static const WIDTH:int = 465;
		private static const HEIGHT:int = 465;
		private var _layer_path:Sprite;
		private var _layer_tmp:Sprite;
		private var _layer_main:BitmapData;
		private var _layer_tmp2:BitmapData;
		private var _particle_list:/*Particle*/Array;
		private var _flag_draw:Boolean = false;
		private var _hsvcolor:ColorHSV;

		public function PrismColorDrawing() {
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			graphics.beginFill(0);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();

			_layer_main = new BitmapData(WIDTH, HEIGHT, true, 0);
			addChild(new Bitmap(_layer_main));

			_layer_path = new Sprite();
			addChild(_layer_path);

			_layer_tmp = new Sprite();
			_layer_tmp2 = new BitmapData(WIDTH, HEIGHT, true, 0);

			_hsvcolor = new ColorHSV();

			_particle_list = [];
			for(var i:int=0; i<300; i++)
			{
				_particle_list.push(new Particle(WIDTH / 2, HEIGHT / 2, 0.01 + 0.0001 * i, 0.90 + i * 0.0001));
			}
			SetParticleColor();

			addEventListener(Event.ENTER_FRAME, EnterFrameHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, MouseUpHandler);
		}

		private function EnterFrameHandler(e:Event):void
		{
			var length:int, i:int;

			length = _particle_list.length;
			for(i = 0; i < length; i++)
			{
				_particle_list[i].Move(stage.mouseX, stage.mouseY);
			}

			_layer_path.graphics.clear();
			_layer_path.graphics.lineStyle(1, 0xffffff);
			for(i = 0; i < length; i++)
			{
				_layer_path.graphics.drawCircle(_particle_list[i].x, _particle_list[i].y, 2);
			}
			_layer_tmp.graphics.clear();
			_layer_tmp.blendMode = "screen";
			if(_flag_draw)
			{
				for(i=0; i<length - 1; i++)
				{
					var p1:Particle = _particle_list[i],
							p2:Particle = _particle_list[i+1];

					_layer_tmp.graphics.beginFill(_particle_list[i].color, 0.4);
					_layer_tmp.graphics.moveTo(p1.prevx, p1.prevy);
					_layer_tmp.graphics.lineTo(p1.x, p1.y);
					_layer_tmp.graphics.lineTo(p2.x, p2.y);
					_layer_tmp.graphics.lineTo(p2.prevx, p2.prevy);
					_layer_tmp.graphics.endFill();
				}
			}

			_layer_tmp2.lock();
			_layer_tmp2.fillRect(_layer_tmp2.rect, 0);
			_layer_tmp2.draw(_layer_tmp);
			_layer_tmp2.unlock();

			_layer_main.lock();
			_layer_main.draw(_layer_tmp2, null, null, "add");
			_layer_main.unlock();
		}

		private function MouseDownHandler(e:MouseEvent):void
		{
			_flag_draw = true;
			SetParticleColor();
		}

		private function MouseUpHandler(e:MouseEvent):void
		{
			_flag_draw = false;
		}

		private function SetParticleColor():void
		{
			var length:int, i:int;

			_hsvcolor.h = Math.random() * 360;

			length = _particle_list.length;
			for(i = 0; i < length; i++)
			{
				_particle_list[i].color = _hsvcolor.value32;
				_hsvcolor.h += 0.5;
			}
		}
	}
}

class Particle {
	private var _x:Number;
	public function get x():Number {return _x;}
	private var _y:Number;
	public function get y():Number {return _y;}

	private var _prevx:Number;
	public function get prevx():Number {return _prevx;}
	private var _prevy:Number;
	public function get prevy():Number{return _prevy;}

	private var _movex:Number;
	private var _movey:Number;

	private var _p1:Number;
	private var _p2:Number;

	private var _color:uint;
	public function set color(val:uint) : void {_color = val;}
	public function get color():uint {return _color;}
	public function Particle(x:Number, y:Number, p1:Number, p2:Number) {
		_movex = 0;
		_movey = 0;
		_x = x;
		_y = y;
		_p1 = p1;
		_p2 = p2;
	}

	public function Move(tx:Number, ty:Number):void
	{
		_prevx = _x;
		_prevy = _y;

		if(!(Math.abs(tx-_x) < 1 && Math.abs(ty - _y)<1))
		{
			_movex += (tx - _x) * _p1;
			_movey += (ty - _y) * _p1;
		}

		_movex *= _p2;
		_movey *= _p2;

		_x += _movex;
		_y += _movey;
	}
}
