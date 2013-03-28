// forked from romatica's いい感じのランダム曲線を引きたい
/**
 ***************************************************************
 * CurveMotion.as
 * @author itoz(http://www.romatica.com/)
 * いい感じのランダム曲線を引きたい
 * TODO　: 曲線上をトゥイーンする座標を得る
 ***************************************************************
 */
package {
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="486", height="486")]

	public class CurveMotion extends Sprite {

		private var debug : Boolean = true;
		private var _debugTextArr : Array = [];
		private var pnt1 : Point;
		private var pnt2 : Point;
		private var handlePointArr : Array;
		private var rndHandlePointArr : Array;
		private var midPointArr : Array;

		public function CurveMotion()
		{


			var _tf : TextField = addChild( new TextField( ) ) as TextField;
			_tf.width = 486;
			_tf.appendText("いい感じの曲線をランダムで引きたい！\n");
			_tf.appendText ( "あちこちクリック！(CLICK STAGE!)\n");
			_tf.appendText ( "TODO　: 曲線上をトゥイーンする座標を得る");
			pnt1 = new Point( );
			pnt2 = new Point( );
			handlePointArr = [];
			rndHandlePointArr = [];
			midPointArr = [];
			stage.addEventListener( MouseEvent.CLICK, onCreatePoint );
		}


		private function onCreatePoint(event : MouseEvent) : void
		{
			handlePointArr = [];
			midPointArr = [];
			rndHandlePointArr = [];
			for (var i : int = 0; i < _debugTextArr.length; i++) {
				removeChild( _debugTextArr[i] as TextField );
				_debugTextArr[i] = null;
			}
			_debugTextArr = [];
			pnt2.x = mouseX;
			pnt2.y = mouseY;
			motionStart( );
		}


		private function motionStart() : void
		{
			this.graphics.clear( );

			var xx : Number = pnt1.x - pnt2.x;
			var yy : Number = pnt1.y - pnt2.y;

			var dist : Number = Point.distance( pnt1, pnt2 );

			var handlePointNum : int = int( Math.random( ) * 3 ) + 2;
			var stepNum : Number = 1 / handlePointNum;
			for (var i : int = 0; i <= handlePointNum; i++) {
				var ff : Number = 1 - (i * stepNum);
				var hand : Point = Point.interpolate( pnt1, pnt2, ff );
				handlePointArr.push( hand );
				var rndMidPointLeng : Number = dist / (handlePointNum + 1) ;
				rndMidPointLeng = rndMidPointLeng * (Math.random( ) * 0.8) + (rndMidPointLeng * 0.5);
				if(i == 0 || i == handlePointNum) {
					rndMidPointLeng = 0;
				}
				var rndHandPoint : Point = Point.polar( rndMidPointLeng, Math.random( ) * (Math.PI * 2) );
				rndHandPoint.x += hand.x;
				rndHandPoint.y += hand.y;
				rndHandlePointArr.push( rndHandPoint );
				if(debug) {
					this.graphics.beginFill( 0x00ff00 );
					this.graphics.drawRect( hand.x - 1, hand.y - 1, 2, 2 );
					this.graphics.endFill( );

					this.graphics.beginFill( 0x000099 );
					this.graphics.drawCircle( rndHandPoint.x - 1, rndHandPoint.y - 1, 2 );
					this.graphics.endFill( );

					this.graphics.lineStyle( 0.1, 0xcccccc );
					this.graphics.drawCircle( hand.x, hand.y, rndMidPointLeng );
					this.graphics.endFill( );
				}
			}
			//　
			var mMax : int = rndHandlePointArr.length;
			for (var n : int = 0; n < mMax; n++) {
				var handle : Point = rndHandlePointArr[n];
				var nextHandle : Point;
				var midX : Number ;
				var midY : Number ;
				var midPoint : Point;
				switch (n)
				{
					case mMax - 1:
						midPointArr.push( pnt2 );
						break;
					default:
						nextHandle = rndHandlePointArr[n + 1];
						midX = (nextHandle.x - handle.x) / 2 + handle.x;
						midY = ( nextHandle.y - handle.y) / 2 + handle.y;
						midPoint = new Point( midX, midY );
						midPointArr.push( midPoint );
						break;
				}
			}
			if(debug) {
				for (var z : int = 0; z < midPointArr.length; z++) {
					var _tf : TextField = addChild( new TextField( ) ) as TextField;
					var trgP : Point
					switch(z)
					{
						case 0:
							trgP = pnt1;
							_tf.text = "start";
							_tf.x = pnt1.x;
							_tf.y = pnt1.y;
							break;

						case midPointArr.length - 1:
							trgP = midPointArr[z];
							_tf.text = "end";
							_tf.x = trgP.x;
							_tf.y = trgP.y;
							break;
						default:
							trgP = midPointArr[z];
							_tf.text = String( z );
							_tf.x = trgP.x;
							_tf.y = trgP.y;
							break;
					}

					_debugTextArr.push( _tf );
					this.graphics.beginFill( 0xcc00cc );
					this.graphics.drawRect( trgP.x - 2, trgP.y - 2, 4, 4 );
					this.graphics.endFill( );
				}



				this.graphics.lineStyle( 0.1, 0xaaaaaa );
				this.graphics.lineTo( _tf.x, _tf.y );
				for (var ii : int = 0; ii < rndHandlePointArr.length; ii++) {
					var tg:Point = rndHandlePointArr[ii];

					if(ii == 0)  this.graphics.moveTo( tg.x, tg.y );
					if(ii != rndHandlePointArr.length - 1) {
						var nex:Point = rndHandlePointArr[ii + 1]
						this.graphics.lineTo( nex.x, nex.y );
					}
				}
				this.graphics.endFill( );

				this.graphics.lineStyle( 0.1, 0xcccccc );
				this.graphics.moveTo( pnt1.x, pnt1.y );
				this.graphics.lineTo( pnt2.x, pnt2.y );
				this.graphics.endFill( );

				for (var e : int = 0; e < midPointArr.length - 1; e++) {
					var nextL : Point = midPointArr[e + 1]
					this.graphics.lineStyle( 1.5, 0xcc3333 );
					if(e == 0) {
						this.graphics.moveTo( pnt1.x, pnt1.y )    ;
					}
					this.graphics.curveTo( rndHandlePointArr[e + 1].x, rndHandlePointArr[e + 1].y, nextL.x, nextL.y );
				}
				this.graphics.endFill( );
			}
			pnt1 = new Point(Math.random()*486,Math.random()*486);

		}

	}
}
