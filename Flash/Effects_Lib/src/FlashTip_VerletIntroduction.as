package
{

	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author YopSolo
	 * It's an introduction to Verlet
	 * 1 VPoint class
	 * 1 VLine Class
	 * 1 choose a bitmap renderer but you can use the regular Flash graphic API
	 *
	 * Enjoy :)
	 */

	public class FlashTip_VerletIntroduction extends Sprite
	{

		private const FRAMERATE:int = 60;
		private const COLS:int = 20;
		private const ROWS:int = 18;
		private const SIZE:int = 7;
		private var points:Vector.<VPoint>;
		private var lines:Vector.<VLine>;
		private var _dat:Bresenham;

		public function FlashTip_VerletIntroduction():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{

			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.quality = StageQuality.MEDIUM;
			stage.stageFocusRect = false;
			stage.tabChildren = false;
			stage.frameRate = FRAMERATE;

			new CustomMenu(this);

			_dat = new Bresenham(stage.stageWidth * .5, stage.stageHeight * .5, false, 0x333333);
			var bmp:Bitmap = new Bitmap(_dat);
			bmp.scaleX = bmp.scaleY = 2;
			addChild(bmp);

			points = new Vector.<VPoint>(COLS * ROWS, true);
			lines = new Vector.<VLine>((COLS - 1) * ROWS + (ROWS - 1) * COLS);

			// creating the grid
			var i:int = 0;
			for (var r:int = 0; r < ROWS; r++)
			{
				for (var c:int = 0; c < COLS; c++)
				{
					points[r * COLS + c] = new VPoint(c * SIZE, r * SIZE);
					if (c > 0)
					{
						lines[i++] = new VLine(points[r * COLS + c - 1], points[r * COLS + c]);
					}

					if (r > 0)
					{
						lines[i++] = new VLine(points[r * COLS + c], points[(r - 1) * COLS + c]);
					}
				}
			}
			this.addEventListener(Event.ENTER_FRAME, _oef);
			//
			buildTextField(this, 'TIP 7 : Verlet introduction', 2, 2);
		}

		private function _oef(e:Event):void
		{
			var t:int = points.length;
			var i:int;
			points[0].setPos((mouseX - (COLS * SIZE)) * .5, 0);
			points[COLS - 1].setPos((mouseX + (COLS * SIZE)) * .5, 0);
			for (i = COLS; i < t; i++)
			{
				points[i].y += .1; // pulling down all the point
				points[i].update();
			}

			t = lines.length;
			for ( var j:int = 0; j < 10; j++)
			{
				for (i = 0; i < t; i++)
				{
					lines[i].contract(); // update the constraint between 2 VPoint
				}
			}

			//-- render
			_dat.lock();
			_dat.fillRect(_dat.rect, 0x333333);
			for (i = 0; i < t; i++)
			{
				_dat.line(lines[i].a.x, lines[i].a.y, lines[i].b.x, lines[i].b.y, 0xCCCC80);
			}
			_dat.unlock();
		}

		private function buildTextField(doc:DisplayObjectContainer, txt:String, x:int = 0, y:int = 0):TextField
		{
			var fmt:TextFormat = new TextFormat;
			fmt.color = 0xFFFFFF;
			fmt.font = 'Arial'; //(new FONT_HARMONY() as Font).fontName;
			fmt.size = 11; // 8;
			var tf:TextField = new TextField;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.opaqueBackground = 0x0; // opaque background allow a perfect font rendering even in StageQuality.LOW mode
			tf.selectable = false;
			//tf.embedFonts = true;
			tf.defaultTextFormat = fmt;
			tf.text = txt;
			tf.x = x;
			tf.y = y;

			doc.addChild(tf);

			return tf;
		}

	}
}

import flash.display.*;
import flash.geom.*;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

/*
 A Bitmapdata with bresenham line method
 */
class Bresenham extends BitmapData
{
	// http://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
	public function Bresenham(width:uint, height:uint, transparent:Boolean = true, color:uint = 0)
	{
		super(width, height, transparent, color);
	}

	public function line(x0:int, y0:int, x1:int, y1:int, color:uint = 0):void
	{
		var dx:int = x1 - x0;
		var dy:int = y1 - y0;
		var sx:int = dx >= 0 ? 1 : -1;
		var sy:int = dy >= 0 ? 1 : -1;
		dx = dx >= 0 ? dx : -dx;
		dy = dy >= 0 ? dy : -dy;
		var err:int = dx - dy, e2:int;

		while (true)
		{
			setPixel32(x0, y0, color);
			if (x0 == x1 && y0 == y1)
				break;

			e2 = err << 1;
			if (e2 > -dy)
			{
				err -= dy;
				x0 += sx;
			}

			if (e2 < dx)
			{
				err += dx;
				y0 += sy;
			}
		}
	}

}

/*
 Vline is the link between 2 VPoint
 */
class VLine
{
	public var a:VPoint;
	public var b:VPoint;
	private var _d:Number;

	public function VLine(pA:VPoint, pB:VPoint)
	{
		a = pA;
		b = pB;
		var dx:Number = a.x - b.x;
		var dy:Number = a.y - b.y;
		_d = Math.sqrt(dx * dx + dy * dy);
	}


	public function contract():void
	{
		var dx:Number = b.x - a.x;
		var dy:Number = b.y - a.y;
		var d:Number = Math.sqrt(dx * dx + dy * dy);
		var diff:Number = _d - d;
		var offx:Number = (diff * dx / d) * .5;
		var offy:Number = (diff * dy / d) * .5;
		a.x -= offx;
		a.y -= offy;
		b.x += offx;
		b.y += offy;
	}
}

/*
 A Regular Flash point with additional oldX and oldY properties
 */
class VPoint extends Point
{
	private var oldx:Number;
	private var oldy:Number;

	public function VPoint(x:Number, y:Number)
	{
		setPos(x, y);
	}

	public function setPos(x:Number, y:Number):void
	{
		this.x = oldx = x;
		this.y = oldy = y;
	}

	public function update():void
	{
		var tempx:Number = x;
		var tempy:Number = y;
		x += x - oldx;
		y += y - oldy;
		oldx = tempx;
		oldy = tempy;
	}
}



import flash.events.ContextMenuEvent;
import flash.net.navigateToURL;
import flash.net.URLRequest;

class CustomMenu
{

	private const NAME:String = "Flash Tips Collection : 'Verlet introduction'";
	public function CustomMenu(ref:Sprite):void
	{
		var appContextMenu:ContextMenu = new ContextMenu;
		appContextMenu.hideBuiltInItems();
		var cmi:ContextMenuItem = new ContextMenuItem(NAME);
		var credits:ContextMenuItem = new ContextMenuItem("by YopSolo");
		appContextMenu.customItems.push(cmi);
		appContextMenu.customItems.push(credits);
		cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _onClickCollection);
		credits.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _onClickCredits);
		ref.contextMenu = appContextMenu;
	}

	private function _onClickCollection(e:ContextMenuEvent):void
	{
		navigateToURL(new URLRequest('http://www.yopsolo.fr/wp/2012/01/14/flash-tips-collection/'), '_blank');
	}

	private function _onClickCredits(e:ContextMenuEvent):void
	{
		navigateToURL(new URLRequest('http://www.yopsolo.fr'), '_blank');
	}
}