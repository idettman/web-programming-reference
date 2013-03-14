package hype.framework.canvas.encoder {
	import flash.geom.Rectangle;

	import hype.framework.canvas.IEncodable;


	/**
	 * @author bhall
	 */
	public interface ICanvasEncoder {
		function encode(canvas:IEncodable, crop:Rectangle=null):void;
		function get fileExtension():String;
	}
}
