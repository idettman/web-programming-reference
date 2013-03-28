package
{
	import com.bit101.components.*;

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;


	[SWF(width=465, height=465, frameRate=60)]
	public class ParticleProperties_SandWaterWall extends Sprite
	{
		private var _CANVAS:BitmapData = new BitmapData (stage.stageWidth, stage.stageHeight, false, 0);

		private var _B0:PushButton;
		private var _B1:PushButton;
		private var _B2:PushButton;
		private var _B3:PushButton;
		private var _B4:PushButton;

		private var _CLICK:Boolean = false;
		private var _COLOR:uint = 0x836034;
		private var _BX:int = 0;
		private var _BY:int = 0;


		public function ParticleProperties_SandWaterWall ():void
		{

			addChild (new Bitmap (_CANVAS));

			_B0 = new PushButton (this, 15, 5, "ERASE");
			_B1 = new PushButton (this, 125, 5, "WALL");
			_B2 = new PushButton (this, 235, 5, "SAND");
			_B3 = new PushButton (this, 345, 5, "WATER");
			//_B4 = new PushButton ( this,  15 , 50, "REPORT" ) ;
			_B1.enabled = false;

			_B0.addEventListener (MouseEvent.CLICK, function ():void
			{
				_COLOR = 0x000000;
				_B0.enabled = false;
				_B1.enabled = true;
				_B2.enabled = true;
				_B3.enabled = true;
				_B4.enabled = true;
			});
			_B1.addEventListener (MouseEvent.CLICK, function ():void
			{
				_COLOR = 0x836034;
				_B0.enabled = true;
				_B1.enabled = false;
				_B2.enabled = true;
				_B3.enabled = true;
				_B4.enabled = true;
			});
			_B2.addEventListener (MouseEvent.CLICK, function ():void
			{
				_COLOR = 0xF7E779;
				_B0.enabled = true;
				_B1.enabled = true;
				_B2.enabled = false;
				_B3.enabled = true;
				_B4.enabled = true;
			});
			_B3.addEventListener (MouseEvent.CLICK, function ():void
			{
				_COLOR = 0x80A2F0;
				_B0.enabled = true;
				_B1.enabled = true;
				_B2.enabled = true;
				_B3.enabled = false;
				_B4.enabled = true;
			});
			//_B4.addEventListener ( MouseEvent.CLICK , function ():void { _COLOR = 0x80F2F0 ; _B0.enabled = true  ; _B1.enabled = true  ; _B2.enabled = true  ; _B3.enabled = true ;  _B4.enabled = false ; } ) ;
			stage.addEventListener (MouseEvent.MOUSE_DOWN, function ():void { _CLICK = true; });
			stage.addEventListener (MouseEvent.MOUSE_UP, function ():void { _CLICK = false; });
			addEventListener (Event.ENTER_FRAME, RUN);

		}


		public function RUN (e:Event):void
		{

			_CANVAS.lock ();

			////////////////////////////////////
			for (var I:int = 200; I < 250; ++I)
			{

				if (Math.random () < .1)
				{
					_CANVAS.setPixel (I, 30, 0xF7E779);
				}

			}
			for (var IX:int = 0; IX < stage.stageWidth; ++IX)
			{

				if (Math.random () < .1 / 2)
				{
					_CANVAS.setPixel (IX, 30, 0x80A2F0);
				}

			}

			////////////////////////////////////
			if (_CLICK && 60 < mouseY && 60 < _BY)
			{

				for (var J:int = 0; J < 20; ++J)
				{
					var R:Number = J / 20;
					_CANVAS.fillRect (new Rectangle (_BX * R + mouseX * ( 1 - R ), _BY * R + mouseY * ( 1 - R ), 5, 5), _COLOR);
				}

			}
			_BX = mouseX;
			_BY = mouseY;

			////////////////////////////////////
			for (var X:int = 0; X < _CANVAS.width; ++X)
			{

				for (var Y:int = _CANVAS.height - 1; Y >= 0; --Y)
				{

					var C:uint = _CANVAS.getPixel (X, Y);
					if (C == 0)
					{
						continue;
					}

					if (C == 0xF7E779)
					{

						var T:uint;
						var TX:int;

						{//落下
							T = _CANVAS.getPixel (X, Y + 1);
							if (T == 0)
							{
								_CANVAS.setPixel (X, Y, T);
								_CANVAS.setPixel (X, Y + 1, C);
								continue;
							}

							//水より砂の方が重い,適当な確率で場所の置換を許す。
							if (T == 0x80A2F0 && Math.random () < .5)
							{
								_CANVAS.setPixel (X, Y, T);
								_CANVAS.setPixel (X, Y + 1, C);
								continue;
							}
						}

						{//左右移動
							TX = X + Math.floor (Math.random () * 7) - 3;
							T = _CANVAS.getPixel (TX, Y);
							if (T == 0)
							{
								_CANVAS.setPixel (X, Y, T);
								_CANVAS.setPixel (TX, Y, C);
								continue;
							}

							//水より砂の方が重い,適当な確率で場所の置換を許す。
							if (T == 0x80A2F0 && Math.random () < .8)
							{
								_CANVAS.setPixel (X, Y, T);
								_CANVAS.setPixel (TX, Y, C);
								continue;
							}
							if (T == 0x80f2F0 && Math.random () < .8)
							{
								_CANVAS.setPixel (X, Y, T);
								_CANVAS.setPixel (TX, Y, C);
								continue;
							}
						}

					}

					if (C == 0x80A2F0)
					{

						{//落下
							T = _CANVAS.getPixel (X, Y + 1);
							if (T == 0)
							{
								_CANVAS.setPixel (X, Y, T);
								_CANVAS.setPixel (X, Y + 1, C);
								continue;
							}
						}

						{//左右移動
							TX = X + Math.floor (Math.random () * 7) - 3;
							T = _CANVAS.getPixel (TX, Y);
							if (T == 0)
							{
								_CANVAS.setPixel (X, Y, T);
								_CANVAS.setPixel (TX, Y, C);
								continue;
							}
						}
						if (T == 0x80f2F0 && Math.random () < .8)
						{
							_CANVAS.setPixel (X, Y, T);

							continue;
						}
						if (C == 0x80F2F0)
						{

							{//左右移動
								TX = X + Math.floor (Math.random () * 7) - 3;
								T = _CANVAS.getPixel (TX, Y);
								if (T == 0)
								{
									_CANVAS.setPixel (X, Y, T);
									_CANVAS.setPixel (TX, Y, C);
									continue;
								}
							}
						}
					}
				}

				_CANVAS.unlock ();

			}

		}

	}
}