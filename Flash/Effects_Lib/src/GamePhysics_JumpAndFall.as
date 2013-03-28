package
{
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author YopSolo
	 * The longer you press the higher you jump
	 * If you want a jump like castlevania plateformers, remove the _onMouseUp listener
	 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	 * here an exemple in action :)
	 * http://www.yopsolo.fr/wp/2012/05/25/platformer-type-2-tile-based-smooth
	 *
	 */
	public class GamePhysics_JumpAndFall extends Sprite
	{
		private const FRAMERATE:int = 48;

		private var _stageW:int;
		private var _stageH:int;
		private var _halfStageW:int;
		private var _halfStageH:int;

		private var _hero:Hero;

		public function GamePhysics_JumpAndFall():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			// config stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.quality = StageQuality.MEDIUM;
			stage.stageFocusRect = false;
			stage.tabChildren = false;

			stage.frameRate = FRAMERATE;

			_stageW = stage.stageWidth;
			_stageH = stage.stageHeight;
			_halfStageW = int(_stageW / 2);
			_halfStageH = int(_stageH / 2);

			var bg:Shape = new Shape()
			bg.graphics.beginFill(0x333333);
			bg.graphics.drawRect(0,0,_stageW, _stageH);
			bg.cacheAsBitmap = true;
			addChild( bg );

			_hero = new Hero(_halfStageW, stage.stageHeight - 96, new Rectangle(0,0,stage.stageWidth, stage.stageHeight) );

			addChild( _hero );

			// add custom menu
			new CustomMenu(this);

			// run app
			run();

		}

		// == APP ==
		private function run():void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown );

			// remove this line to change your jump
			this.stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp );

			addEventListener(Event.ENTER_FRAME, _oef);

			buildTextField(this, 'TIP 4 : Simple Jump and Fall Physics', 2, 2);
			buildTextField(this, 'The longer you press the higher you jump', 2, 18);
			buildTextField(this, 'For a jump like castlevania just remove the mouseUp listener.', 2, 36);
		}


		private function _oef(e:Event):void
		{
			_hero.update();
		}

		private function _onMouseDown(e:MouseEvent):void
		{
			_hero.startJump();
		}

		private function _onMouseUp(e:MouseEvent):void
		{
			_hero.endJump();
		}

		// == COMMON ==
		private function buildTextField(doc:DisplayObjectContainer, txt:String, x:int = 0, y:int = 0):TextField
		{
			var fmt:TextFormat = new TextFormat;
			fmt.color = 0xFFFFFF;
			fmt.font = 'Arial'; //(new FONT_HARMONY() as Font).fontName;
			fmt.size = 11; // 8;

			var tf:TextField = new TextField;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.opaqueBackground = 0x333333; // opaque background allow a perfect font rendering even in StageQuality.LOW mode
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

import flash.display.Shape;
import flash.geom.Rectangle;

internal class Hero extends Shape
{
	public var posX:Number;
	public var posY:Number;

	public var G:Number = .5; // world's GRAVITY
	public var vx:Number = .0; // velocity X axis
	public var vy:Number = .0; // velocity Y axis
	public var onGround:Boolean = false; // my hero start in air

	private var _world:Rectangle;

	public function Hero(pX:int, pY:int, worldRect:Rectangle)
	{
		this.graphics.beginBitmapFill(new XORTexture(128, 128), null, true, true);
		this.graphics.drawCircle(0, 0, 16);
		this.graphics.endFill();
		_world = worldRect;
		_world.bottom -= 16;
		_world.left += 16;
		_world.right -= 16;
		x = posX = pX;
		y = posY = pY;
	}

	public function update():void
	{
		// -- compute new values
		vy += G;

		if (posX + vx > _world.right) {
			vx = -vx * .8;
		}

		if (posX + vx < _world.left) {
			vx = -vx * .8;
		}

		posY += vy;
		posX += vx;
		if (posY > _world.bottom) {
			posY = _world.bottom;
			vy = 0;
			onGround = true;
		}

		// -- apply the values
		y = posY;
		x = posX;
		if (Math.abs(vx) > .25) {
			rotation += (vx * 2.25); // a little trick ^^
		}

	}

	public function startJump():void
	{
		if(onGround)
		{
			vy = -15.0; // arbitrary value
			vx = (stage.mouseX - this.x) / 50;
			onGround = false;
		}
	}

	// -- if you want a full power jump just comment the code bellow
	public function endJump():void
	{
		if(vy < -7.0)
			vy = -7.0; // the minimal height that you want to allow
	}


}

import flash.display.BitmapData;

internal class XORTexture extends BitmapData
{

	public function XORTexture(width:int, height:int)
	{
		super(width, height, false, 0x0);

		var color:uint;
		var rbg_color:uint;
		for (var w:int = 0; w < width; w++)
		{
			for (var h:int = 0; h < height; h++)
			{
				color = w ^ h;
				rbg_color = color << 16 | color << 8 | color;
				this.setPixel(w, h, rbg_color);
			}
		}
	}
}

import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.net.navigateToURL;
import flash.net.URLRequest;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

class CustomMenu
{

	private const NAME:String = "Flash Tips Collection : 'Simple Jump and Fall Physics'";

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