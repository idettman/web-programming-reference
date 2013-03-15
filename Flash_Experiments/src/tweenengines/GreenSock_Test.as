/**
 * User: Isaac
 * Date: 3/13/13
 * Time: 9:42 PM
 */
package tweenengines
{
	import base.display.AbstractSprite;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quart;

	import flash.display.Shape;


	public class GreenSock_Test extends AbstractSprite
	{
		public var redCircle:Shape;
		public var circles:Vector.<Shape>;
		
		public function GreenSock_Test ()
		{
			super ();
		}
		
		
		public var tweenTimeScale:Number = 1;
		

		override protected function init ():void
		{
			super.init ();

			redCircle = new Shape ();
			redCircle.graphics.beginFill (0xFF0000);
			redCircle.graphics.drawCircle (0, 0, 100);
			redCircle.graphics.endFill ();
			addChild (redCircle);

			circles = new Vector.<Shape> (100, true);
			for (var i:int = 0; i < circles.length; i++)
			{
				circles[i] = makeCircle();
				addChild (circles[i]);
				TweenMax.to (circles[i], 4+Math.random()*20, {x: Math.random () * 1000, y: Math.random () * 700, ease: Quart.easeInOut, delay: Math.random () * 4});
			}
			
			
			TweenLite.to (redCircle, 4, {x: 1000, y: 500, onComplete: initialTweenCompleteHandler});
		}
		
		private function makeCircle():Shape
		{
			var circle:Shape = new Shape ();
			circle.graphics.beginFill (0xF00606);
			circle.graphics.drawCircle (0, 0, 10+Math.random()*2);
			circle.graphics.endFill ();
			return circle;
		}


		private function initialTweenCompleteHandler ():void
		{
			TweenMax.to (this, 1.6, {tweenTimeScale: 0.29, onUpdate: updateTimeScale, ease: Elastic.easeOut, onComplete:resetTimeScale});
			TweenMax.to (redCircle, 9, {x: 0, y: 0, scaleX: 7, scaleY: 7, ease: Elastic.easeIn, onComplete: resetCircle});
		}


		private function resetCircle ():void
		{
			TweenMax.to (redCircle, 40, {x: 800, y: 500, scaleX: 0.5, scaleY: 0.5, ease: Elastic.easeIn});
		}


		private function resetTimeScale ():void
		{
			TweenMax.to (this, 15, {tweenTimeScale: 15, onUpdate: updateTimeScale, ease: Quart.easeIn});
		}
		
		
		private function updateTimeScale ():void
		{
			TweenMax.globalTimeScale (tweenTimeScale);
		}
	}
}
