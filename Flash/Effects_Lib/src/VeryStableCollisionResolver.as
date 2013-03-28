// forked from owenray's Very stable collision resolver
package
{
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;


	public class VeryStableCollisionResolver extends Sprite
	{
		private var objects:Array = new Array ();
		private var dragging:CollisionObject = null;
		private var grab:Point = new Point ();


		public function VeryStableCollisionResolver ()
		{
			for (var c:int = 0; c < 10; c++)
			{
				var o:CollisionObject = new CollisionObject ();
				addChild (o);
				objects.push (o);
				for (var key:String in objects)
				{
					objects[key].checkCollision (objects);
				}
				o.addEventListener (MouseEvent.MOUSE_DOWN, startDragging);
			}
		}


		private function startDragging (e:MouseEvent):void
		{
			dragging = CollisionObject (e.target);
			grab.x = dragging.mouseX;
			grab.y = dragging.mouseY;
			stage.addEventListener (MouseEvent.MOUSE_UP, stopDragging);
			stage.addEventListener (MouseEvent.MOUSE_MOVE, doDrag);
		}


		private function doDrag (e:MouseEvent):void
		{
			dragging.x = mouseX - grab.x;
			dragging.y = mouseY - grab.y;
			dragging.checkCollision (objects);
		}


		private function stopDragging (e:MouseEvent):void
		{
			stage.removeEventListener (MouseEvent.MOUSE_UP, stopDragging);
			stage.removeEventListener (MouseEvent.MOUSE_MOVE, doDrag);
		}
	}
}
import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.Proxy;
import flash.geom.Rectangle;


class CollisionObject extends Sprite
{
	public function CollisionObject ()
	{
		graphics.beginFill (0xFFFFFF * Math.random ());
		graphics.drawRect (0, 0, 50 + 100 * Math.random (), 50 + 100 * Math.random ());
		x = 400 * Math.random ();
		y = 400 * Math.random ();
	}


	private function hitTestAll (others:Array):CollisionObject
	{
		for (var key:String in others)
		{
			var rt:Rectangle = others[key].getCollisionRect ();
			var r:Rectangle = getCollisionRect ();
			var t:CollisionObject = others[key];
			if (t != this &&
					rt.right > r.left &&
					rt.bottom > r.top &&
					rt.left < r.right &&
					rt.top < r.bottom)
			{
				return others[key];
			}
		}
		return null;
	}


	public function checkCollision (others:Array):void
	{

		var p:Point = new Point (x, y);
		var rad:int = 1;
		var end:Boolean = false;
		var sensivity:int = 20;
		var precision:int = 20;

		//in case there is really no way out..
		var safeEscape:int = 0;

		if (hitTestAll (others))
			while (!end)
			{
				rad += sensivity;
				var Y:Number = rad;

				var pos:Array = new Array ();

				for (var X:Number = 0; X <= Y; X += rad / precision)
				{
					Y = Math.sqrt (Math.pow (rad, 2) - Math.pow (X, 2));
					pos.push (new Point (p.x + X, p.y + Y));
					pos.push (new Point (p.x - X, p.y - Y));
					pos.push (new Point (p.x + X, p.y - Y));
					pos.push (new Point (p.x - X, p.y + Y));

					pos.push (new Point (p.x + Y, p.y + X));
					pos.push (new Point (p.x - Y, p.y - X));
					pos.push (new Point (p.x - Y, p.y + X));
					pos.push (new Point (p.x + Y, p.y - X));
				}
				safeEscape++;
				if (safeEscape == 1000) end = true;
				for (var key:String in pos)
				{
					x = pos[key].x;
					y = pos[key].y;
					if (!hitTestAll (others))
					{
						if (sensivity == 20)
						{
							rad -= 20;
							sensivity = 10;
						}
						else if (sensivity == 10)
						{
							rad -= 11;
							sensivity = 1;
						}
						else
							end = true;
						break;
					}
				}
			}
	}


	public function getCollisionRect ():Rectangle
	{
		return new Rectangle (x,
				y,
				width,
				height);
	}
}