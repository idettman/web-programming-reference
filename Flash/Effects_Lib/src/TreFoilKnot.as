// http://en.wikipedia.org/wiki/Trefoil_knot
package {
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.SegmentSet;
	import away3d.filters.RadialBlurFilter3D;
	import away3d.primitives.LineSegment;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import frocessing.color.ColorHSV;



	[SWF(width="465", height="465", backgroundColor="0x000000", frameRate="30")]
	public class TreFoilKnot extends View3D
	{
		private var lines:SegmentSet
		private var detail:Number = 200;
		private var counter:Number = 0
		private var shift:Number;

		public function TreFoilKnot()
		{
			//Wonderfl.disable_capture();

			stage.scaleMode = 'noScale'
			stage.align = 'TL'

			addChild(new AwayStats(this,true))
			antiAlias = 8

			scene.addChild(lines = new SegmentSet())

			var p:Number = 2
			var q:Number = 3
			var r:Number

			var radius:Number = 100;
			var angle:Number

			var last:Vector3D
			var now:Vector3D

			var color:ColorHSV = new ColorHSV();

			for (var i:int = 0; i <= detail; i++)
			{
				angle = Math.PI * 4 / detail * i
				r = ((2 + Math.cos((q * angle) / p)))
				color.h = 360 * i / detail

				now = new Vector3D( r * Math.cos(angle), Math.sin((q * angle) / p) * 2, r * Math.sin(angle))
				now.scaleBy(radius)

				if (last) lines.addSegment(new LineSegment(last, now, color.value, color.value, 0))
				last = now
			}

			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame)
			stage.addEventListener(Event.RESIZE, onStageResize)
			onStageResize()

			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage)
		}

		private function onEnterFrame(e:Event):void
		{
			render()
			lines.rotationX +=2
			lines.rotationY --

			shift = ++counter % detail
			for (var i:int = 0; i < detail; i++) lines.getSegment((i + shift) % detail).thickness = (i / detail) * 7 + 1
		}

		private function onStageResize(e:Event = null):void
		{
			width = stage.stageWidth
			height = stage.stageHeight
		}

		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			filters3d = [ new RadialBlurFilter3D(.5, 1.5, 1, -0.5)]
		}
	}
}