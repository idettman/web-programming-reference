package
{
	import base.display.AbstractSprite;

	import flare.vis.Visualization;
	import flare.vis.data.Data;
	import flare.vis.operator.encoder.ColorEncoder;
	import flare.vis.operator.label.Labeler;
	import flare.vis.operator.label.RadialLabeler;
	import flare.vis.operator.layout.PieLayout;

	import flash.geom.Rectangle;
	import flash.text.TextFormat;


	public class FlareTest extends AbstractSprite
	{
		public var visualization:Visualization;


		public function FlareTest ()
		{
			super ();
		}


		override protected function init ():void
		{
			super.init ();

			var data:Data = new Data();
			for (var i:uint=0; i<16; ++i) {
				data.addNode({
					id: String.fromCharCode("A".charCodeAt(0)+i),
					value: 100*Math.random()
				});
			}

			visualization = new Visualization (data);
			visualization.bounds = new Rectangle(0,0,1024-150,760-100);
			visualization.data.nodes.setProperty("lineAlpha", 1);
			visualization.operators.add(new PieLayout("data.value", 0.7));
			visualization.operators.add(new ColorEncoder("data.value","nodes","fillColor"));
			// Add text labels. The LAYER constant indicates labels should be
			// placed in separate layer of the visualization
			visualization.operators.add(new RadialLabeler("data.id", false, new TextFormat("Arial",15,0,true), null, Labeler.LAYER));
			visualization.operators.last.radiusOffset = 15;
			visualization.update ();


			visualization.x = 75;
			visualization.y = 50;
			addChild (visualization);
		}
	}
}
