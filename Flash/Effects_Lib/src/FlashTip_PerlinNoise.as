// forked from YoupSolo's Flash Tip Collection - Tip 5 - PerlinNoise goodness
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
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * @author YopSolo
	 * not really a flash tip, just perlin noise goodness :)
	 */

	public class FlashTip_PerlinNoise extends Sprite
	{
		private const FRAMERATE:int = 30;

		private var _stageW:int;
		private var _stageH:int;
		private var _dat:BitmapData;
		private var _offsets:Array;
		private var _speeds:Vector.<Point>;
		private const _nbOctaves:int = 3;

		public function FlashTip_PerlinNoise():void
		{
			if (stage)
			{
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			// config stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			stage.stageFocusRect = false;
			stage.tabChildren = false;

			stage.frameRate = FRAMERATE;

			_stageW = stage.stageWidth;
			_stageH = stage.stageHeight;

			var bg:Shape = new Shape();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRect(0,0,_stageW, _stageH);
			bg.cacheAsBitmap = true;
			addChild( bg );

			// add custom menu
			new CustomMenu(this);

			// run app
			run();

		}

		// == APP ==
		private function run():void
		{
			_dat = new BitmapData(_stageW >> 1, _stageH >> 1, true);
			var bitmap:Bitmap = new Bitmap(_dat);
			bitmap.scaleX = bitmap.scaleY = 2;
			addChild(bitmap);

			_offsets = [];
			_speeds = new Vector.<Point>(3, true);

			for (var o:int=0; o<_nbOctaves; o++)
			{
				_offsets[o] = new Point(0,0);
			}
			_speeds[0] = new Point(-2.6,-1.1);
			_speeds[1] = new Point(-0.5,1.6);
			_speeds[2] = new Point(2.1,0.5);

			addEventListener(Event.ENTER_FRAME, _oef);
			//buildTextField(this, 'TIP 5 : perlin Noise goodness', 2, 2);
		}


		private function _oef(e:Event):void
		{
			for (var o:int=0; o<_nbOctaves; o++)
			{
				_offsets[o].x +=  _speeds[o].x;
				_offsets[o].y +=  _speeds[o].y;
			}
			_dat.perlinNoise(194,162,_nbOctaves,9383,false,false,13,false,_offsets);
		}

		// == COMMON ==
		private function buildTextField(doc:DisplayObjectContainer, txt:String, x:int = 0, y:int = 0):TextField
		{
			var fmt:TextFormat = new TextFormat  ;
			fmt.color = 0xFFFFFF;
			fmt.font = 'Arial';//(new FONT_HARMONY() as Font).fontName;
			fmt.size = 11;// 8;

			var tf:TextField = new TextField  ;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.opaqueBackground = 0x333333;// opaque background allow a perfect font rendering even in StageQuality.LOW mode
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

import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.net.navigateToURL;
import flash.net.URLRequest;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

class CustomMenu
{

	private const NAME:String = "Flash Tips Collection : 'Perlin noise goodness'";

	public function CustomMenu(ref:Sprite):void
	{
		var appContextMenu:ContextMenu = new ContextMenu  ;
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