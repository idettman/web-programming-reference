// forked from Aquioux's Pixelate by Shape#Graphics
package
{
	import com.bit101.components.PushButton;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;


	/**
	 * Pixelate by Shape#Graphics
	 * Practice of strategy pattern
	 * @author Aquioux(Yoshida, Akio)
	 * Picture 「写真素材　足成」　http://www.ashinari.com/
	 */

	[SWF(width="465", height="465", frameRate="30", backgroundColor="#FFFFFF")]
	public class PixelateEffectsByShape extends Sprite
	{
		// Pixelation 共用パラメータ
		private const DEGREE:int = 5;        // 減色の段階数

		// キャンバス
		private var canvas_:Shape;

		// BitmapData
		private var normalBmd_:BitmapData;    // Behavior1 用
		private var smallBmd_:BitmapData;    // Behavior1 以外用

		// 描画データ
		private var normalData_:Vector.<uint>;    // normalBmd_ の vector
		private var smallData_:Vector.<uint>;    // smallBmd_ の vector

		// ソースイメージの Bitmap
		private var sourceBm_:Bitmap;

		// ふるまいクラス群
		private var fill1_:BehaviorFill1;
		private var fill2_:BehaviorFill2;
		private var fill3_:BehaviorFill3;
		private var fill4_:BehaviorFill4;
		private var fillLine1_:BehaviorFillLine1;
		private var fillLine2_:BehaviorFillLine2;
		private var fillLine3_:BehaviorFillLine3;
		private var fillLine4_:BehaviorFillLine4;
		private var line1_:BehaviorLine1;
		private var line2_:BehaviorLine2;
		private var line3_:BehaviorLine3;
		private var line4_:BehaviorLine4;

		// 前回押したボタン
		private var prevButton_:PushButton;

		// コンストラクタ
		public function PixelateEffectsByShape ()
		{
			var url:String = "http://assets.wonderfl.net/images/related_images/c/c2/c2df/c2dfe75aebd8a2d756c59b56e6c141f189aa3987";
			var loader:Loader = new Loader ();
			loader.load (new URLRequest (url), new LoaderContext (true));
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, completeHandler);
		}


		private function completeHandler (event:Event):void
		{
			// ステージサイズ
			var sw:uint = stage.stageWidth;
			var sh:uint = stage.stageHeight;

			// 読み込んだイメージ
			var loadedBmd:BitmapData = event.target.loader.content.bitmapData;

			// 読み込んだイメージから二つの BitmapData を得る
			var normalSize:int = 93;
			normalBmd_ = new BitmapData (normalSize, normalSize);
			normalBmd_.draw (loadedBmd, new Matrix (normalSize / 200, 0, 0, normalSize / 200), null, null, null, true);
			var smallSize:int = 31;
			smallBmd_ = new BitmapData (smallSize, smallSize);
			smallBmd_.draw (loadedBmd, new Matrix (smallSize / 200, 0, 0, smallSize / 200), null, null, null, true);

			// キャンバスの生成
			canvas_ = new Shape ();
			addChild (canvas_);
			// ソースイメージの表示
			sourceBm_ = new Bitmap (loadedBmd);
			addChild (sourceBm_);

			// ピクセル化クラス
			Pixelation.degree = DEGREE;
			smallData_ = Pixelation.pixelate (smallBmd_.clone ());
			normalData_ = Pixelation.pixelate (normalBmd_.clone ());

			// ふるまいクラス群
			fill1_ = new BehaviorFill1 ();
			fill2_ = new BehaviorFill2 ();
			fill3_ = new BehaviorFill3 ();
			fill4_ = new BehaviorFill4 ();
			fillLine1_ = new BehaviorFillLine1 ();
			fillLine2_ = new BehaviorFillLine2 ();
			fillLine3_ = new BehaviorFillLine3 ();
			fillLine4_ = new BehaviorFillLine4 ();
			line1_ = new BehaviorLine1 ();
			line2_ = new BehaviorLine2 ();
			line3_ = new BehaviorLine3 ();
			line4_ = new BehaviorLine4 ();

			// 描画切り替えボタン
			var buttonWidth:int = 50;
			var buttonHeight:int = 18;
			var button11:PushButton = new PushButton (this, sw - buttonWidth * 3, buttonHeight * 0, "Fill", button11Handler);
			var button12:PushButton = new PushButton (this, sw - buttonWidth * 2, buttonHeight * 0, "Fill&Line", button12Handler);
			var button13:PushButton = new PushButton (this, sw - buttonWidth * 1, buttonHeight * 0, "Line", button13Handler);
			var button21:PushButton = new PushButton (this, sw - buttonWidth * 3, buttonHeight * 1, "Fill", button21Handler);
			var button22:PushButton = new PushButton (this, sw - buttonWidth * 2, buttonHeight * 1, "Fill&Line", button22Handler);
			var button23:PushButton = new PushButton (this, sw - buttonWidth * 1, buttonHeight * 1, "Line", button23Handler);
			var button31:PushButton = new PushButton (this, sw - buttonWidth * 3, buttonHeight * 2, "Fill", button31Handler);
			var button32:PushButton = new PushButton (this, sw - buttonWidth * 2, buttonHeight * 2, "Fill&Line", button32Handler);
			var button33:PushButton = new PushButton (this, sw - buttonWidth * 1, buttonHeight * 2, "Line", button33Handler);
			var button41:PushButton = new PushButton (this, sw - buttonWidth * 3, buttonHeight * 3, "Fill", button41Handler);
			var button42:PushButton = new PushButton (this, sw - buttonWidth * 2, buttonHeight * 3, "Fill&Line", button42Handler);
			var button43:PushButton = new PushButton (this, sw - buttonWidth * 1, buttonHeight * 3, "Line", button43Handler);
			button11.width = buttonWidth;
			button11.height = buttonHeight;
			button12.width = buttonWidth;
			button12.height = buttonHeight;
			button13.width = buttonWidth;
			button13.height = buttonHeight;
			button21.width = buttonWidth;
			button21.height = buttonHeight;
			button22.width = buttonWidth;
			button22.height = buttonHeight;
			button23.width = buttonWidth;
			button23.height = buttonHeight;
			button31.width = buttonWidth;
			button31.height = buttonHeight;
			button32.width = buttonWidth;
			button32.height = buttonHeight;
			button33.width = buttonWidth;
			button33.height = buttonHeight;
			button41.width = buttonWidth;
			button41.height = buttonHeight;
			button42.width = buttonWidth;
			button42.height = buttonHeight;
			button43.width = buttonWidth;
			button43.height = buttonHeight;
		}


		// ボタンハンドラ Behavior1
		private function button11Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = fill1_;
			drawPattern1 ();
		}


		private function button12Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = fillLine1_;
			drawPattern1 ();
		}


		private function button13Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = line1_;
			drawPattern1 ();
		}


		// ボタンハンドラ Behavior2
		private function button21Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = fill2_;
			drawPattern2 ();
		}


		private function button22Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = fillLine2_;
			drawPattern2 ();
		}


		private function button23Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = line2_;
			drawPattern2 ();
		}


		// ボタンハンドラ Behavior3
		private function button31Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = fill3_;
			drawPattern3 ();
		}


		private function button32Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = fillLine3_;
			drawPattern3 ();
		}


		private function button33Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = line3_;
			drawPattern3 ();
		}


		// ボタンハンドラ Behavior4
		private function button41Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = fill4_;
			drawPattern3 ();
		}


		private function button42Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = fillLine4_;
			drawPattern3 ();
		}


		private function button43Handler (e:Event):void
		{
			buttonChanged (PushButton (e.target));
			Drawer.behavior = line4_;
			drawPattern3 ();
		}


		// ボタン切り替え
		private function buttonChanged (button:PushButton):void
		{
			if (prevButton_) prevButton_.enabled = true;
			button.enabled = false;
			prevButton_ = button;
		}


		// 描画パターン1
		private function drawPattern1 ():void
		{
			Drawer.interval = 5;
			Drawer.maxEdgeSize = 5;
			Drawer.colorShift = 0.03;
			Drawer.draw (normalData_, canvas_, normalBmd_.rect, DEGREE);
			sourceBm_.bitmapData = normalBmd_;
		}


		// 描画パターン2
		private function drawPattern2 ():void
		{
			Drawer.interval = 15;
			Drawer.maxEdgeSize = 25;
			Drawer.colorShift = 0.3;
			Drawer.draw (smallData_, canvas_, smallBmd_.rect, DEGREE);
			sourceBm_.bitmapData = smallBmd_;
		}


		// 描画パターン3
		private function drawPattern3 ():void
		{
			Drawer.interval = 15;
			Drawer.maxEdgeSize = 15;
			Drawer.colorShift = 0.3;
			Drawer.draw (smallData_, canvas_, smallBmd_.rect, DEGREE);
			sourceBm_.bitmapData = smallBmd_;
		}
	}
}

//package {
//import aquioux.display.bitmapDataEffector.GrayScale;
//import aquioux.display.bitmapDataEffector.Posterize;
//import aquioux.display.bitmapDataEffector.Smooth;
import flash.display.BitmapData;
import flash.filters.BitmapFilterQuality;


/**
 * 入力された BitmapData のピクセル情報を取得して、青チャンネルから段階値を取得する
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class Pixelation
{
	/**
	 * 減色の段階数
	 */
	static public function set degree (value:int):void
	{ _degree = value; }


	static private var _degree:int = 5;


	/**
	 * ポジ・ネガ反転
	 */
	static public function set invert (value:Boolean):void
	{ _invert = value; }


	static private var _invert:Boolean = false;


	/**
	 * 段階値取得
	 * @param    bmd    入力 BitmapData
	 * @return    イメージ全 pixel の段階値を格納した配列
	 */
	static public function pixelate (bmd:BitmapData):Vector.<uint>
	{
		// イメージ操作フィルター生成と入力 BitmapData への適用
		// 平滑化
		var smooth:Smooth = new Smooth ();
		smooth.strength = 1;
		smooth.quality = BitmapFilterQuality.HIGH;
		smooth.applyEffect (bmd);
		// グレイスケール
		new GrayScale ().applyEffect (bmd);
		// 減色
		var posterize:Posterize = new Posterize ();
		posterize.degree = _degree + 1;
		posterize.applyEffect (bmd);

		// bmd.getVector
		var pixelVector:Vector.<uint> = bmd.getVector (bmd.rect);
		pixelVector.fixed = true;

		// 減色の段階値を計算
		var val:Number = 0xFF / _degree;
		var len:uint = pixelVector.length;
		var data:Vector.<uint> = new Vector.<uint> ();
		for (var i:int = 0; i < len; i++)
		{
			var result:Number = (pixelVector[i] & 0xFF) / val;
			if (result != int (result)) int (result + 1);
			data.push (_invert ? result : _degree - result);
		}
		data.fixed = true;
		return data;
	}
}
//}

//package {
//import aquioux.display.colorUtil.CycleRGB;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Rectangle;


/**
 * Pixelation で得られたデータを描画
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class Drawer
{
	/**
	 * タイルの間隔
	 */
	static public function set interval (value:uint):void
	{
		_maxEdgeSize = _interval = value;
	}


	static private var _interval:int = 5;


	/**
	 * タイルの辺の最大値
	 * タイル間隔を超える値の設定を可とする
	 * この値を設定した後に _interval を設定すると無効になるので注意
	 */
	static public function set maxEdgeSize (value:uint):void
	{ _maxEdgeSize = value; }


	static private var _maxEdgeSize:uint = 5;


	/**
	 * 表示色の変動値
	 */
	static public function set colorShift (value:Number):void
	{ _colorShift = value; }


	static private var _colorShift:Number = 0.1;


	/**
	 * 描画ふるまいクラス
	 */
	static public function set behavior (value:IBehavior):void
	{ _behavior = value; }


	static private var _behavior:IBehavior;


	/**
	 * 描画
	 * @param    data    表示のためのデータ
	 * @param    canvas    表示カンバス
	 * @param    rect    表示領域
	 */
	static public function draw (data:Vector.<uint>, canvas:Shape, rect:Rectangle, degree:int):void
	{
		if (!_behavior) throw new Error ("描画ふるまいクラスが割り当てられていません。");
		var width:int = rect.width;
		var angle:Number = Math.random () * 360;
		var g:Graphics = canvas.graphics;
		var len:uint = data.length;
		g.clear ();
		for (var i:int = 0; i < len; i++)
		{
			var currentDegree:uint = data[i];
			var currentEdgeSize:Number = currentDegree * (_maxEdgeSize / degree);
			var currentShift:Number = (_interval - currentEdgeSize) / 2;
			var posX:Number = (i % width) * _interval + currentShift;
			var posY:Number = ((i / width) >> 0) * _interval + currentShift;
			if (currentEdgeSize != 0)
			{
				var color:uint = CycleRGB.getColor (angle);
				_behavior.execute (g, posX, posY, currentEdgeSize, color);
			}
			angle += _colorShift;
		}
	}
}
//}

//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラスの interface
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
interface IBehavior
{
	/**
	 * ふるまいの実行（描画のための Rectangle を生成）
	 * @param    degree    段階
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    interval    タイルの間隔
	 * @return    描画のための Rectangle
	 */
	function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void;
}
//}

//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Fill）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorFill1 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		canvas.beginFill (color);
		canvas.drawRect (posX, posY, size, size);
		canvas.endFill ();
	}
}
//}
//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Fill）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorFill2 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		posX += ((Math.random () * 4 >> 0) - 2);
		posY += ((Math.random () * 4 >> 0) - 2);
		canvas.beginFill (color, 0.25);
		canvas.drawRect (posX, posY, size, size);
		canvas.endFill ();
	}
}
//}
//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Fill）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorFill3 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		var val:Number = size / 2;
		posX += val;
		posY += val;
		posX += ((Math.random () * 4 >> 0) - 2);
		posY += ((Math.random () * 4 >> 0) - 2);
		canvas.beginFill (color, 0.5);
		canvas.drawCircle (posX, posY, size * 0.75);
		canvas.endFill ();
	}
}
//}
//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Fill）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorFill4 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		canvas.beginFill (color);
		canvas.drawTriangles (Vector.<Number> ([posX, posY, posX + size, posY, posX + size, posY + size]));
		canvas.endFill ();
	}
}
//}

//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Fill & Line）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorFillLine1 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		canvas.beginFill (color, 0.25);
		canvas.lineStyle (0, color, 0.75);
		canvas.drawRect (posX, posY, size, size);
		canvas.endFill ();
	}
}
//}
//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Fill & Line）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorFillLine2 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		posX += ((Math.random () * 4 >> 0) - 2);
		posY += ((Math.random () * 4 >> 0) - 2);
		canvas.beginFill (color, 0.25);
		canvas.lineStyle (0, color, 0.5);
		canvas.drawRect (posX, posY, size, size);
		canvas.endFill ();
	}
}
//}
//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Fill & Line）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorFillLine3 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		var val:Number = size / 2;
		posX += val;
		posY += val;
		canvas.beginFill (color, 0.75);
		canvas.lineStyle (0, 0x0, 0.75);
		canvas.drawCircle (posX, posY, val);
		canvas.endFill ();
	}
}
//}
//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Fill & Line）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorFillLine4 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		canvas.beginFill (color, 0.25);
		canvas.lineStyle (0, color, 0.75);
		canvas.drawRect (posX, posY, size, size);
		canvas.moveTo (posX, posY);
		canvas.lineTo (posX + size, posY + size);
		canvas.moveTo (posX + size, posY);
		canvas.lineTo (posX, posY + size);
		canvas.endFill ();
	}
}
//}

//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Line）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorLine1 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		canvas.lineStyle (0, color);
		canvas.drawRect (posX, posY, size, size);
	}
}
//}
//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Line）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorLine2 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		posX += ((Math.random () * 6 >> 0) - 3);
		posY += ((Math.random () * 6 >> 0) - 3);
		canvas.lineStyle (0, color, 0.75);
		canvas.drawRect (posX, posY, size, size);
	}
}
//}
//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Line）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorLine3 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		var val:Number = size / 2;
		posX += val;
		posY += val;
		canvas.lineStyle (4, color, 0.5);
		canvas.drawCircle (posX, posY, size * 0.75);
	}
}
//}
//package {
import flash.display.Graphics;
import flash.geom.Rectangle;


/**
 * 描画ふるまいクラス（Line）
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class BehaviorLine4 implements IBehavior
{
	/**
	 * ふるまいの実行
	 * @param    canvas    表示 Graphics
	 * @param    posX    開始X座標
	 * @param    posY    開始Y座標
	 * @param    size    辺の長さ
	 * @param    color    色
	 */
	public function execute (canvas:Graphics, posX:int, posY:int, size:int, color:uint):void
	{
		posX += ((Math.random () * 6 >> 0) - 3);
		posY += ((Math.random () * 6 >> 0) - 3);
		var val:Number = size / 2;
		canvas.lineStyle (2, color);
		canvas.moveTo (posX + val, posY);
		canvas.lineTo (posX + val, posY + size);
		canvas.moveTo (posX, posY + val);
		canvas.lineTo (posX + size, posY + val);
	}
}
//}

//package aquioux.display.bitmapDataEffector {
import flash.display.BitmapData;


/**
 * BitmapDataEffector 用 interface
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
interface IEffector
{
	function applyEffect (value:BitmapData):BitmapData;
}
//}
//package aquioux.display.bitmapDataEffector {
import flash.display.BitmapData;
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;


/**
 * ColorMatrixFilter による BitmapData のグレイスケール化（NTSC 系加重平均による）
 * 参考：Foundation ActionScript 3.0 Image Effects(P106)
 *         http://www.amazon.co.jp/gp/product/1430218711?ie=UTF8&tag=laxcomplex-22
 * @author YOSHIDA, Akio (Aquioux)
 */

/*public*/
class GrayScale implements IEffector
{
	private const R:Number = EffectorUtils.LUM_R;
	private const G:Number = EffectorUtils.LUM_G;
	private const B:Number = EffectorUtils.LUM_B;

	private const MATRIX:Array = [
		R, G, B, 0, 0,
		R, G, B, 0, 0,
		R, G, B, 0, 0,
		0, 0, 0, 1, 0
	];
	private const FILTER:ColorMatrixFilter = new ColorMatrixFilter (MATRIX);

	private const ZERO_POINT:Point = EffectorUtils.ZERO_POINT;

	/*
	 * 効果適用
	 * @param    value    効果対象 BitmapData
	 */
	public function applyEffect (value:BitmapData):BitmapData
	{
		value.applyFilter (value, value.rect, ZERO_POINT, FILTER);
		return value;
	}
}
//}
//package aquioux.display.bitmapDataEffector {
import flash.display.BitmapData;
import flash.geom.Point;


/**
 * paletteMap による BitmapData の減色
 * 「実践画像処理入門」 培風館　内村圭一・上瀧剛　P16　「2.5 濃度値の量子化による減色処理」
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class Posterize implements IEffector
{
	/*
	 * 減色の段階
	 * @param    value    段階
	 */
	public function set degree (value:uint):void
	{
		// value の有効範囲は 2 ～ 256
		if (value < 2) value = 2;
		if (value > 256) value = 256;

		if (_gradation)
		{
			_gradation.fixed = false;
			_gradation.length = 0;
		}
		else
		{
			_gradation = new Vector.<uint> ();
		}

		var prevVal:uint = 0xFF;
		for (var i:int = 0; i < 256; i++)
		{
			var val:uint = uint (i / (256 / value)) * 255 / (value - 1);
			rArray_[i] = val << 16;
			gArray_[i] = val << 8;
			bArray_[i] = val;

			if (prevVal != val)
			{
				_gradation.push (val);
				prevVal = val;
			}
		}
		_gradation.fixed = true;
	}


	// 減色化によって計算された gradation の値を格納する Vector
	// degree を set することではじめて有効になる
	// length は degree になる
	public function get gradation ():Vector.<uint> { return _gradation; }


	private var _gradation:Vector.<uint>;

	// paletteMap の引数となる各 Channel 用の Array
	private var rArray_:Array = [];
	private var gArray_:Array = [];
	private var bArray_:Array = [];

	private const ZERO_POINT:Point = EffectorUtils.ZERO_POINT;

	/*
	 * コンストラクタ
	 */
	public function Posterize ()
	{
		degree = 8;    // degree のデフォルト
	}


	/*
	 * 効果適用
	 * @param    value    効果対象 BitmapData
	 */
	public function applyEffect (value:BitmapData):BitmapData
	{
		value.paletteMap (value, value.rect, ZERO_POINT, rArray_, gArray_, bArray_);
		return value;
	}
}
//}
//package aquioux.display.bitmapDataEffector {
import flash.display.BitmapData;
import flash.filters.BitmapFilterQuality;
import flash.filters.BlurFilter;
import flash.geom.Point;


/**
 * BlurFilter による平滑化
 * @author YOSHIDA, Akio (Aquioux)
 */

/*public*/
class Smooth implements IEffector
{
	/*
	 * ぼかしの強さ
	 * @param    value    数値
	 */
	public function set strength (value:Number):void
	{
		filter_.blurX = filter_.blurY = value;
	}


	/*
	 * ぼかしの質
	 * @param    value    数値
	 */
	public function set quality (value:int):void
	{
		filter_.quality = value;
	}


	// ブラーフィルタ
	private var filter_:BlurFilter;

	private const ZERO_POINT:Point = EffectorUtils.ZERO_POINT;

	/*
	 * コンストラクタ
	 */
	public function Smooth ()
	{
		filter_ = new BlurFilter (2, 2, BitmapFilterQuality.MEDIUM);
	}


	/*
	 * 効果適用
	 * @param    value    効果対象 BitmapData
	 */
	public function applyEffect (value:BitmapData):BitmapData
	{
		value.applyFilter (value, value.rect, ZERO_POINT, filter_);
		return value;
	}
}
//}
//package aquioux.display.bitmapDataEffector {
import flash.geom.Point;


/**
 * bitmapDataEffector パッケージ内のクラスで共通に使う定数など
 * @author YOSHIDA, Akio (Aquioux)
 */
/*public*/
class EffectorUtils
{
	// BitmapData が備える各種メソッドの destPoint 用
	static public const ZERO_POINT:Point = new Point (0, 0);

	// グレイスケール用の各チャンネルの重みづけ
	// NTSC系加重平均法（YIQ,YCbCr も同じ）
	static public const LUM_R:Number = 0.298912;
	static public const LUM_G:Number = 0.586611;
	static public const LUM_B:Number = 0.114478;
}
//}

//package aquioux.display.colorUtil {
/**
 * コサインカーブで色相環的な RGB を計算
 * @author Aquioux(YOSHIDA, Akio)
 */
/*public*/
class CycleRGB
{
	/**
	 * 32bit カラーのためのアルファ値（0～255）
	 */
	static public function get alpha ():uint
	{ return _alpha; }


	static public function set alpha (value:uint):void
	{
		_alpha = (value > 0xFF) ? 0xFF : value;
	}


	private static var _alpha:uint = 0xFF;

	private static const PI:Number = Math.PI;        // 円周率
	private static const DEGREE120:Number = PI * 2 / 3;    // 120度（弧度法形式）

	/**
	 * 角度に応じた RGB を得る
	 * @param    angle    HSV のように角度（度数法）を指定
	 * @return    色（0xNNNNNN）
	 */
	public static function getColor (angle:Number):uint
	{
		var radian:Number = angle * PI / 180;
		var r:uint = (Math.cos (radian) + 1) * 0xFF >> 1;
		var g:uint = (Math.cos (radian + DEGREE120) + 1) * 0xFF >> 1;
		var b:uint = (Math.cos (radian - DEGREE120) + 1) * 0xFF >> 1;
		return r << 16 | g << 8 | b;
	}


	/**
	 * 角度に応じた RGB を得る（32bit カラー）
	 * @param    angle    HSV のように角度（度数法）を指定
	 * @return    色（0xNNNNNNNN）
	 */
	public static function getColor32 (angle:Number):uint
	{
		return _alpha << 24 | getColor (angle);
	}
}
//}
