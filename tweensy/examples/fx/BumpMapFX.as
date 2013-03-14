package {	import flash.display.*;	import flash.geom.Point;	import flash.utils.getDefinitionByName;		import com.flashdynamix.motion.*;	import com.flashdynamix.motion.effects.BumpMapEffect;	import com.flashdynamix.motion.effects.core.ChannelEffect;	import com.flashdynamix.motion.guides.Orbit2D;	import com.flashdynamix.motion.layers.BitmapLayer;	import com.flashdynamix.utils.SWFProfiler;		import fl.motion.easing.Linear;		/**	 * @author shanem	 */	public class BumpMapFX extends Sprite {
		private var lightBmp : BitmapLayer;		private var textureBmp : BitmapLayer;		private var lightPt : Point;		private var tween : TweensyGroup;
		public function BumpMapFX() {			SWFProfiler.init(this);						tween = new TweensyGroup(false, true);						stage.quality = StageQuality.LOW;						var width : int = 500;			var height : int = 513;						var LightMap : Class = getDefinitionByName("LightMap") as Class;			var BumpMap : Class = getDefinitionByName("BumpMap") as Class;			var TextureMap : Class = getDefinitionByName("TextureMap") as Class;						var lightBmd : BitmapData = new BitmapData(width, height, false, 0xFF000000);			lightBmd.draw(new LightMap(width, height));			var textureBmd : BitmapData = new TextureMap(width, height);						lightBmp = new BitmapLayer(width, height);			textureBmp = new BitmapLayer(width, height);			lightPt = new Point();						textureBmp.draw(textureBmd);						var bme : BumpMapEffect = new BumpMapEffect(new BumpMap(width, height), lightBmd, lightPt);			var ce : ChannelEffect = new ChannelEffect(textureBmd, BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA, null, lightPt);						lightBmp.add(bme);			lightBmp.add(ce);						addChild(textureBmp);			addChild(lightBmp);						lightBmp.blendMode = BlendMode.HARDLIGHT;						var path : Orbit2D = new Orbit2D(lightPt, 230, 200, -65, -50);			tween.to(path, {degree:360 * 3}, 10, Linear.easeNone).repeatType = TweensyTimeline.REPLAY;			tween.onUpdate = onUpdate;		}
		private function onUpdate() : void {			textureBmp.x = lightPt.x;			textureBmp.y = lightPt.y;						lightBmp.render();		}	}}