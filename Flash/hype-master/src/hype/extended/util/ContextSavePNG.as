package hype.extended.util {
	import flash.display.Stage;

	import hype.framework.canvas.encoder.PNGCanvasEncoder;
	import hype.framework.display.BitmapCanvas;


	/**
	 * Just a wrapper around the ContextSaveImage class to stay
	 * backwards compatible with v1.1.1
	 */
	public class ContextSavePNG extends ContextSaveImage {
		
		/**
		 * Constructor
		 * 
		 * @param canvas The BitmapCanvas class to capture
		 * @param stage The stage (optional if canvas is currently added to the stage)
		 */
		public function ContextSavePNG(canvas:BitmapCanvas, stage:Stage=null) {
			super(canvas, PNGCanvasEncoder, stage);
		}
	}
}
