// forked from l.dijkman's forked from: リマソン第２弾 (定義編)
// http://cstep.luberth.com 
// http://luberth.com/plotter/triangle.bas
// http://www.luberth.com/plotter/ditwasplotter.htm
// http://www.youtube.com/watch?v=yC9srOxNSFs
// flash as3 triange math example
// Tangential Knife control.  Tangental Knife control.
// http://www.youtube.com/watch?v=EuVlpr0rbMU
// rotate knive in direction off move
// computer motion controlled
// calculate direction of movement
// calculate vector direction
// calculate vector angle
// calculate vector length
// calculate vector degrees
// calculate mouse angle detection
// http;//cstep.luberth.com
// 

// forked from tenasaku's limacon ?
// Created: 2010-03-04 by tenasaku
package{


	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	//import net.wonderfl.utils.WonderflSWFUrl;


	[SWF(width="465",height="465",backgroundColor="#000000")]
	public class FindTriangleInCircle extends Sprite
	{
		private var _banner:TextField;
		private var _tf:TextField;
		private var Li:Limacon;
		private var Ray:Sprite;


		public function FindTriangleInCircle():void
		{
			Li = new Limacon(232, 90, 0);
			Li.color = 0x800000;
			Li.thickness = 2;
			Li.x = 232;
			Li.y = 232;
			Li.showCircle = true;
			Li.circleColor = 0x000000;
			Li.draw();
			addChild(Li);
			// ガイド用の直線
			Ray = new Sprite();
			Ray.graphics.clear();
			addChild(Ray);
			// 見出し用テキストフィールド
			_banner = new TextField();
			_banner.background = true;
			_banner.backgroundColor = 0x00ffff;
			_banner.text = "Can Anyone create a Flash SVG or HPGL plot file read view example ?!\n " ;//+ String() + "";
			_banner.x = 10;
			_banner.y = 2;
			_banner.textColor = 0x800000;
			_banner.width = 360;
			_banner.height = 20;
			_banner.alpha = 0.6
			addChild(_banner);


			var sp:Sprite = new Sprite;
			var tf = new TextField;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.width = 200;
			tf.htmlText = "<u><b>Http://CStep.Luberth.com</b></u>";
			tf.y = 420;
			tf.x = 300;
			sp.graphics.beginFill(0, 0);
			sp.buttonMode = true;
			sp.graphics.drawRect(0, 0, tf.width, tf.height);
			sp.addEventListener(MouseEvent.CLICK, function () {
				navigateToURL(new URLRequest("Http://cstep.luberth.com"), "_blank");
			});
			sp.addChild(tf);
			addChild(sp);


			var sp:Sprite = new Sprite;
			var tf = new TextField;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.width = 200;
			tf.htmlText = "<u><b>Fork it & play with the source\nWonderFl build flash online\nClean my messy code</b></u>";
			tf.y = 420;
			tf.x = 30;
			sp.graphics.beginFill(0, 0);
			sp.buttonMode = true;
			sp.graphics.drawRect(0, 0, tf.width, tf.height);
			sp.addEventListener(MouseEvent.CLICK, function () {
				navigateToURL(new URLRequest("http://wonderfl.net/c/eDHa/fork"),"_blank");
			});
			sp.addChild(tf);
			addChild(sp);



			_tf = new TextField();
			_tf.text = "";
			_tf.x = 16;
			_tf.y = 40;
			_tf.width = 200;
			_tf.textColor = 0x000080;
			addChild(_tf);

			addEventListener(Event.ENTER_FRAME, _as_time_passes);
		}


		private function draw_ray():void {
			var dx:Number = mouseX - 232; // <dx,dy> is the orientation of the line
			var dy:Number = mouseY - 232;
			var nx:Number; // <nx,ny> is the orthogonal direction
			var ny:Number;
			var Ax:Number; // at <Ax,Ay>, the line crosses the boundary.
			var Ay:Number;
			var Bx:Number; // <Bx,By> is the other cross point.
			var By:Number;

			var compasx:Number;
			var compasy:Number;
			var deg:int;
			var rang:Number;
			var radius:Number;


			Ray.graphics.clear();
			Ray.graphics.lineStyle(1,0xff0000);
			// Draw only if <dx,dy> is not the zero vector...
			if (( dx != 0 ) || (dy != 0)) {


				Ray.graphics.moveTo(232,232);
				Ray.graphics.lineTo(mouseX,mouseY);
				Ray.graphics.lineTo(mouseX,232);
				Ray.graphics.lineTo(232,232);

				//now i want  to draw a second compas like line
				//that is drawn by the degrees given by the mouse
				//so in top left screen a compas line
				//calculated from degrees given bij mouse
				Ray.graphics.moveTo(232+175-30,232-175);
				Ray.graphics.lineTo(232+175+30,232-175);

				Ray.graphics.moveTo(232+175,232-175+30);
				Ray.graphics.lineTo(232+175,232-175-30);


				Ray.graphics.moveTo(232+175-30,232+150);
				Ray.graphics.lineTo(232+175+30,232+150);

				Ray.graphics.moveTo(232+175,232+150+30);
				Ray.graphics.lineTo(232+175,232+150-30);
				//now i want  to draw a second compas like line
				//that is drawn by the degrees given by the mouse
				//so in top left screen a compas line
				//calculated from degrees given bij mouse

				//next draws top left compas from degrees given

				deg = Math.round(Math.atan2(-(mouseY-232), mouseX-232) / Math.PI*180);
				if (deg < 0) deg = deg + 360;  // no negative degint

				rang = - deg * Math.PI*2 / 360;
				radius = 30;
				compasx = radius * Math.cos(rang);
				compasy = radius * Math.sin(rang);
				//draw compas line      compasx compasy
				Ray.graphics.moveTo(232+175,232-175);
				Ray.graphics.lineTo(232+175+compasx,232-175+compasy);

				rang = deg * Math.PI*2 / 360;
				radius = 30;
				compasx = radius * Math.cos(rang);
				compasy = radius * Math.sin(rang);
				Ray.graphics.moveTo(232+175,232+150);
				Ray.graphics.lineTo(232+175+compasx,232+150+compasy);
			}
		}

		// マウスがステージにあれば原点から直線を引き、
		// 方向(角度)をテキストフィールドに表示します
		private function _as_time_passes(e:Event):void {
			var deg:int;
			//public var compasx;
			//public var compasy;
			//var radius;
			//var rang;

			draw_ray();

			deg = Math.round(Math.atan2(-(mouseY-232), mouseX-232) / Math.PI*180);

			if (deg < 0) deg = deg + 360;  // no negative degree

			_tf.text = "direction = " + String(deg) + " deg \n"
					+ "X = " + String(mouseX-232) + "\n"
					+ "Y = " + String(-mouseY+232)+ "\n"
					+ "Lenght = " + String( Math.sqrt((mouseX-232) * (mouseX-232) + (-mouseY+232) * (-mouseY+232))) + "\n";



		}

	} // end of class Main
} // end of package

/* ===================== */

import flash.display.Sprite;
class Limacon extends Sprite {
	public var d:Number; // Set by the constructor.
	public var a:Number; // ditto.
	public var phi:Number; // ditto. These three parameters are mandatory.
	public var thickness:uint; // default: 2
	public var color:uint; // default: 0x000000 ( black )
	public var showCircle:Boolean=true; // Want the circle displayed? (defalut: false)
	public var showLine:Boolean; // Want the diameter displayed? (defalut: false)
	public var circleColor:uint; // default: 0xffffff ( white )
	public var lineColor:uint; // default: 0xffffff ( white )
	// Draws the curve using given parameters

	public var compasx:Number;
	public var compasy:Number;
	public var deg:int;
	public var rang:Number;
	public var radius:Number;

	public function draw():void {
		var i:int;
		var t:Number;
		var r:Number;
		this.graphics.clear();
		this.graphics.lineStyle(thickness, color);

		//if ( showCircle ) {
		this.circleColor = 0xbbbbbb;
		this.graphics.lineStyle(1, this.circleColor);
		this.graphics.drawCircle(0 , 0, 100);
		this.graphics.drawCircle(0 , 0, 100*Math.sqrt(2));
		this.showCircle = true;
		// }

	}
	// Constructor...
	public function Limacon(_d:Number, _a:Number, _phi:Number):void {
		//this.d = _d;
		//this.a = _a;
		//this.phi = _phi;
		// this.thickness = 0;
		this.showCircle = false;
		// this.showLine = false;
		this.color = 0x00ff00;
		this.circleColor = 0x333333;
		// this.lineColor = 0xff00ff;
	}
}
