package utils
{
	import flash.external.ExternalInterface;


	public class DebugUtils
	{
		public static function traceToHtml(mesage:String, ...rest):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call ("console.log", mesage + ((rest)? " "+rest.join(" "): ""));
			}
		}
	}
}