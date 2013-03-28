package
{
	import flash.display.Shape;
	import com.bit101.components.CheckBox;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	/**
	 * @author YopSolo
	 * It's cool to see stuff changing in a natural way
	 * by changing in mean transform, aka translate, scale or rotate
	 *
	 * A quick tip achieve it, is to use cos, sin, tan operators, Math.PI value etc.
	 *
	 * here an exemple for each transform,
	 */

	public class FlashTip_NaturalMotions extends Sprite
	{

		private const FRAMERATE:int = 48;

		private var _stageW:int;
		private var _stageH:int;
		private var _halfStageW:int;
		private var _halfStageH:int;


		private var _subject:Subject;
		private const STEP:Number = .002;

		private var translate:CheckBox;
		private var scale:CheckBox;
		private var rotate:CheckBox;

		public function FlashTip_NaturalMotions() {
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
			_halfStageW = int(_stageW * .5);
			_halfStageH = int(_stageH * .5);

			var background:Shape = new Shape;
			background.graphics.beginFill( 0x333333 );
			background.graphics.drawRect( 0,0,_stageW, _stageH);
			background.graphics.endFill();
			addChild( background );

			// -- sad subject
			_subject = new Subject( _halfStageW, _halfStageH );
			addChild( _subject );

			// -- ui

			translate =  new CheckBox( this, 10, 50, "TanslateY" );
			translate.selected = true;
			scale = new CheckBox( this, 10, 80, "SacleX/Y" ) ;
			rotate = new CheckBox( this, 10, 110, "RotateZ" ) ;

			// add custom menu
			new CustomMenu(this);

			// run app
			run();

		}

		// == APP ==
		private function run():void

		{

			addEventListener(Event.ENTER_FRAME, _oef);

			buildTextField(this, 'TIP 6 : Natural Motions', 2, 2);
			buildTextField(this, 'Choose witch natural motion that you want to apply, and fork me to create your own :)', 2, 18);
		}


		private function _oef(e:Event):void

		{
			var t:Number = getTimer() * STEP;

			// translate
			if(translate.selected)_subject.y = _subject.oriY + ( 9 * Math.sin(t) );
			// your own natural translate :)

			// scale
			if(scale.selected)_subject.scaleX = _subject.scaleY = 1 + ((Math.cos(t) * Math.sin(t))) * .3;
			// your own natural scale :)


			// rotate
			if(rotate.selected)_subject.rotation = Math.cos(Math.sin(t * 3) + t * 3) * 30;
			// your own natural rotate :)

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
import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.filters.GlowFilter;
import flash.net.navigateToURL;
import flash.net.URLRequest;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;



internal class Subject extends Shape

{

	private var _oriX:Number;
	private var _oriY:Number;
	private var _glow:GlowFilter;

	public function Subject(pX:int, pY:int)

	{
		x = _oriX = pX;
		y = _oriY = pY;

		_glow = new GlowFilter( 0xFFFFFF, 1 , 10, 10, 3, 3 );
		sadFace();
		this.filters = [ _glow ];
	}

	public function sadFace():void
	{
		this.graphics.clear();
		this.graphics.beginFill(0xFFFFFF);
		this.graphics.drawCircle( 0, 0, 30 );
		this.graphics.beginFill(0x333333);
		this.graphics.drawCircle( -10.5, -10, 4);
		this.graphics.drawCircle( 10, -10.5, 4.5);
		this.graphics.endFill();
		this.graphics.lineStyle(3, 0x333333);
		this.graphics.moveTo( -20, 15 );
		this.graphics.curveTo(0,0,20,15);
	}

	public function get oriX():Number  { return _oriX; }
	public function get oriY():Number  { return _oriY; }
}


class CustomMenu
{
	private const NAME:String = "Flash Tips Collection : 'Natural motions'";
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