package {
	
	
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Quad;
	import com.eclecticdesignstudio.motion.MotionPath;
	import com.eclecticdesignstudio.utils.FPSCounter;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.filters.BlurFilter;
	
	
	/**
	 * @author Joshua Granick
	 */
	public class Example extends Sprite {
		
		
		private var FPS:FPSCounter;
		
		
		public function Example () {
			
			initialize ();
			construct ();
			
		}
		
		
		private function animateCircle (circle:Sprite):void {
			
			// create a duration between 1.5 and 6 seconds for the animation
			
			var duration:Number = 1.5 + Math.random () * 4.5;
			
			// get a random end position on the stage
			
			var targetX:Number = Math.random () * stage.stageWidth;
			var targetY:Number = Math.random () * stage.stageHeight;
			
			// create bezier paths for random, but curved, movement
			// the first half of each bezier has a different control point than the second half to try to create variety
			
			var bezierX:MotionPath = new MotionPath ().bezier (targetX / 2, targetX - 100).bezier (targetX, targetX + 100);
			var bezierY:MotionPath = new MotionPath ().bezier (targetY / 2, targetY + 100).bezier (targetY, targetY - 100);
			
			// animate the circle's (x, y) coordinates using our new motion paths
			
			Actuate.motionPath (circle, duration, { x: bezierX, y: bezierY } ).ease (Quad.easeInOut);
			
			// create a blur amount between 6 and 36
			
			var blur:Number = 6 + Math.random () * 30;
			
			// animate the BlurFilter that is attached to each circle, and call the animateCircle function again when it is all finished 
			
			Actuate.effects (circle, duration).filter (BlurFilter, { blurX: blur, blurY: blur } ).onComplete (animateCircle, circle);
			
		}
		
		
		private function construct ():void {
			
			var creationDelay:Number;
			
			for (var i:uint = 0; i < 60; i++) {
				
				// create a delay between 0 and 10 seconds
				
				creationDelay = Math.random () * 10;
				
				// run a timer using this delay to space out when each circle should be created, for variety
				
				Actuate.timer (creationDelay).onComplete (createCircle);
				
			}
			
			addChild (FPS);
			
		}
		
		
		private function createCircle ():void {
			
			// create a random size between 5 and 40 pixels
			
			var size:Number = 5 + Math.random () * 35;
			
			// create a new circle using a random color and the size we defined
			
			var circle:Sprite = new Sprite ();
			circle.graphics.beginFill (Math.random () * 0xFFFFFF);
			circle.graphics.drawCircle (0, 0, size);
			
			// position it somewhere random on the stage and add a BlurFilter
			
			circle.x = Math.random () * stage.stageWidth;
			circle.y = Math.random () * stage.stageHeight;
			circle.alpha = 0;
			circle.filters = [ new BlurFilter () ];
			
			// add the circle at the bottom of the display list
			
			addChildAt (circle, 0);
			
			// fade the circle from an alpha of zero (invisible) to an alpha value between 0.2 and 0.8
			
			Actuate.tween (circle, 2, { alpha: 0.2 + Math.random () * 0.6 } );
			
			animateCircle (circle);
			
		}
		
		
		private function initialize ():void {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			FPS = new FPSCounter ();
			
		}
		
		
	}
	
	
}