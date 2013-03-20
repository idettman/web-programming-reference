package lunchwheel
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.textures.BitmapTexture;

	import base.display.AbstractSprite;

	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.actuators.SimpleActuator;
	import com.eclecticdesignstudio.motion.easing.Cubic;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import utils.GeometryUtils;


	public class LunchWheelAltLabelRotation extends AbstractSprite
	{
		// Data variables
		private var _startingIndex:uint;
		private var _circleRadius:Number;
		private var _circleCenter:Point;
		private var _data:Vector.<LunchVo>;
		
		// Away3d variables
		private var _view:View3D;
		private var _lightPicker:StaticLightPicker;
		private var _cameraController:HoverController;
		private var _wheelContainer:ObjectContainer3D;
		
		// Spin variables
		private var _a:Number;
		private var _b:Number;
		private var _rad:Number;
		private var _accr:Number;
		private var _oldRadius:Number;
		private var _dragging:Boolean;
		
		// Test bitmap capture
		private var _testBitmap:Bitmap;
		
		
		override protected function init ():void
		{
			SimpleActuator.updateManually = true;


			_accr = 0;
			_startingIndex = 0;
			_circleRadius = 200;
			_circleCenter = new Point (0, 0);// Centered for away3d
			_testBitmap = new Bitmap ();
			
			initAway3d();
			
			data = new <LunchVo>[
				createLunchData ("The Golf Course"),
				createLunchData ("Chipotle"),
				createLunchData ("The Habbit"),
				createLunchData ("TGI Fridays"),
				createLunchData ("Corner Bakery"),
				createLunchData ("Jacks"),
				createLunchData ("Subway"),
				createLunchData ("Noahs Bagels"),
				createLunchData ("Five Guys")
			];
			
			super.init ();
		}
		
		private function initAway3d ():void
		{
			Parsers.enableAllBundled ();

			_view = new View3D ();
			addChild (_view);
			_view.antiAlias = 16;


			_view.camera.lens = new PerspectiveLens (50);
			_view.camera.lens.far = 8000;
			_view.camera.lens.near = 0.5;

			_wheelContainer = new ObjectContainer3D ();
			_view.scene.addChild (_wheelContainer);
			_cameraController = new HoverController (_view.camera, _wheelContainer, 0, 12, 4000, 12, 90, NaN, NaN, 8, 1.2, false);


			// Create light
			var pointlight_0:PointLight = new PointLight ();
			pointlight_0.castsShadows = true;
			pointlight_0.shadowMapper.depthMapSize = 512;
			pointlight_0.z = -120;
			pointlight_0.x = 10;
			pointlight_0.y = 900;
			pointlight_0.fallOff = 20000;
			pointlight_0.radius = 3000;
			pointlight_0.zOffset = 0;
			pointlight_0.shaderPickingDetails = false;
			pointlight_0.ambient = 0.5;
			pointlight_0.color = 0xFFFFFF;
			pointlight_0.ambientColor = 0xFFFFFF;
			pointlight_0.specular = 1;
			pointlight_0.diffuse = 1;
			pointlight_0.name = "pointlight_0";
			_view.scene.addChild (pointlight_0);
			_lightPicker = new StaticLightPicker ([pointlight_0]);
		}
		
		
		override protected function addListeners ():void
		{
			super.addListeners ();
			_view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener (Event.ENTER_FRAME, enterFrameHandler);
		}
		
		
		private function updateLayout ():void
		{
			var _lunchVo:LunchVo;
			var angle:Number = 0;
			const sum:uint = _data.length;
			const radius:Number = _circleRadius;
			var step:Number, start:Number, n:uint, dx:Number, dy:Number;
			var point1:Point = new Point ();
			var point2:Point = new Point ();
			const THICKNESS:Number = 8;
			
			
			// calculate span of sides
			step = (Math.PI * 2) / sum;
			// calculate starting angle in radians
			start = (angle / 180) * Math.PI;

			point1.x = _circleCenter.x + (Math.cos (start) * radius);
			point1.y = _circleCenter.y + (Math.sin (start) * radius);
			
			
			// create the polygon
			for (n = 1; n <= sum; n++)
			{
				_lunchVo = _data[n - 1];

				dx = _circleCenter.x + Math.cos (start + (step * n)) * radius;
				dy = _circleCenter.y - Math.sin (start + (step * n)) * radius;

				point2.x = dx;
				point2.y = dy;


				var deltaX:Number = point2.x - point1.x;
				var deltaY:Number = point2.y - point1.y;

				var lineLength:Number = Math.sqrt (deltaX * deltaX + deltaY * deltaY);
				
				deltaX /= lineLength;
				deltaY /= lineLength;

				const pVectorX:Number = THICKNESS * deltaY;
				const pVectorY:Number = THICKNESS * deltaX;
				
				var pointVert1:Point = new Point (point1.x - pVectorX, point1.y + pVectorY);
				var pointVert2:Point = new Point (point2.x - pVectorX, point2.y + pVectorY);
				var pointVert3:Point = new Point (point2.x + pVectorX, point2.y - pVectorY);
				var pointVert4:Point = new Point (point1.x + pVectorX, point1.y - pVectorY);


				// Get the length of the polygon segment
				// Distance forumula: d = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)
				var diffX:Number = point2.x - point1.x;
				var diffY:Number = point2.y - point1.y;
				var polySegmentLength:Number = Math.sqrt(diffX * diffX + diffY * diffY);
				var polySegmentAngleInRadians:Number = Math.atan2 (diffY, diffX);
				var polySegmentAngleInDegress:Number = polySegmentAngleInRadians * (180 / Math.PI);
				const RECTANGLE_HEIGHT:Number = polySegmentLength * THICKNESS;
				//trace ("Rectangle TopLeft:", point1 ," Length: ", polySegmentLength, " Angle:", polySegmentAngleInDegress);
				

				// Create rectangle with text and position at polygon segment extruded rectangle
				var testRectangle:Sprite = new Sprite ();
				testRectangle.graphics.beginFill (0x00000000);
				testRectangle.graphics.drawRect (0, 0, polySegmentLength, RECTANGLE_HEIGHT);
				testRectangle.graphics.endFill ();
				testRectangle.x = point1.x;
				testRectangle.y = point1.y;
				testRectangle.rotation = polySegmentAngleInDegress;
				
				var testRectangleLable:TextField = new TextField ();
				testRectangleLable.embedFonts = true;
				testRectangleLable.autoSize = TextFieldAutoSize.LEFT;
				testRectangleLable.multiline = false;
				testRectangleLable.defaultTextFormat = new TextFormat ("RobotoCondensed Regular", 58, 0x00FFFFFF);
				testRectangleLable.text = /*_lunchVo.index.toString() + ". " +*/ _lunchVo.title;
				testRectangleLable.selectable = false;
				testRectangleLable.mouseEnabled = false;
				testRectangleLable.rotation = 90;
				testRectangleLable.x = testRectangleLable.textHeight;
				testRectangle.addChild (testRectangleLable);
				
				
				// Capture bitmap of text label for use as away3d texture
				var bitmapCapture:BitmapData = new BitmapData (256, 256, false, 0x000000);
				
				// Scale the bitmap capture to fit texture bitmap fully 
				var scaleToHeight:Number = bitmapCapture.height / RECTANGLE_HEIGHT;
				
				var m:Matrix = new Matrix();
				m.scale(scaleToHeight, scaleToHeight);
				bitmapCapture.draw (testRectangle, m);
				//_testBitmap.bitmapData = bitmapCapture.clone ();
				//addChild(_testBitmap);
				
				
				// Need to convert rectangle registration point from top-left to centered (Away3d using centered registration oppossed to Flash's top-left)
				var centeredTestRectanglePosition:Point = GeometryUtils.getMidPoint (point1.x, point1.y, polySegmentLength, RECTANGLE_HEIGHT, polySegmentAngleInDegress);
				
				
				var geometry:CubeGeometry = new CubeGeometry (polySegmentLength, 8, RECTANGLE_HEIGHT, 1, 1, 1, false);
				var cubeMesh:Mesh = new Mesh (geometry, new TextureMaterial(new BitmapTexture(bitmapCapture), true, false, true));
				TextureMaterial(cubeMesh.material).lightPicker = _lightPicker;
				
				// Since geometry isn't square on all axis, uvs need to be scaled for cubes aspect ratio
				cubeMesh.geometry.scaleUV (polySegmentLength/RECTANGLE_HEIGHT, 1);
				
				cubeMesh.x = centeredTestRectanglePosition.x;
				cubeMesh.z = centeredTestRectanglePosition.y;
				cubeMesh.rotationY = -polySegmentAngleInDegress;
				_wheelContainer.addChild (cubeMesh);
				

				point1.x = point2.x;
				point1.y = point2.y;
			}
			
			Actuate.tween (_cameraController, 2.5, {distance: 2500, tiltAngle: 88}).ease(Cubic.easeInOut);
		}


		private function createLunchData (title:String):LunchVo
		{
			var lunchVo:LunchVo = new LunchVo ();
			lunchVo.index = _startingIndex;
			lunchVo.title = title;
			_startingIndex++;
			return lunchVo;
		}


		public function get data ():Vector.<LunchVo> { return _data; }

		public function set data (value:Vector.<LunchVo>):void
		{
			_data = value;
			updateLayout ();
		}



		private function enterFrameHandler (e:Event):void
		{
			SimpleActuator.manualUpdate ();

			if (_dragging)
			{
				_a = stage.mouseY - stage.stageHeight/2;
				_b = stage.mouseX - stage.stageWidth/2;
				_rad = Math.atan2(_a, _b) * 180/Math.PI;
				
				if (_rad - _oldRadius > 160 || _rad - _oldRadius < -160)
					_accr = ((0) + _accr);
				else
					_accr = ((_rad - _oldRadius) + _accr) / 2;
				
				_wheelContainer.rotationY += _accr;
				_oldRadius = _rad;
			}
			
			_view.render ();
		}


		private function onMouseUp(event:MouseEvent):void
		{
			_dragging = false;
			//trace ("power:", _a, _b, _accr);
			
			if (Math.abs(_accr) > 3)
			{
				Actuate.tween (_wheelContainer, Math.abs (_accr) * 0.5, {rotationY: _wheelContainer.rotationY + (_accr * 90)}).ease(Cubic.easeOut).onComplete(spinTweenCompleteHandler);
			}
			else
			{
				Actuate.tween (_wheelContainer, Math.abs (_accr) * 0.5, {rotationY: _wheelContainer.rotationY + (_accr * 90)}).ease(Cubic.easeOut);
			}
			
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		
		private function spinTweenCompleteHandler ():void
		{
			//Actuate.tween (_cameraController, 2, { distance: 300 }).ease(Cubic.easeInOut).onComplete(resetCamera);
		}


		private function resetCamera ():void
		{
			//Actuate.tween (_cameraController, 1.5, { distance: 600 }).ease(Cubic.easeInOut).delay(3);
		}
		
		
		private function onMouseDown(event:MouseEvent):void
		{
			Actuate.stop (_wheelContainer);
			
			_a = stage.mouseY - stage.stageHeight/2;
			_b = stage.mouseX - stage.stageWidth/2;
			_oldRadius = Math.atan2(_a, _b) * 180 / Math.PI;
			_dragging = true;
			
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		private function onStageMouseLeave(event:Event):void
		{
			_dragging = false;
			
			//trace ("mouse leave: power:", _a, _b, _accr);
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
	}
}
class LunchVo
{
	public function LunchVo () {}

	public var index:uint;
	public var title:String;
}