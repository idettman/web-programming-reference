// forked from qizh's Really private namespace test
package
{
	import flash.display.Sprite;
	import flash.text.TextField;


	public class ReallyPrivateNamespaceTest extends Sprite
	{
		public function ReallyPrivateNamespaceTest ()
		{
			const tf:TextField = new TextField ();
			tf.wordWrap = true;
			tf.width = 465;
			tf.height = 465;
			addChild (tf);

			const obj:ClassWithSecret = new ClassWithSecret ();

			tf.appendText (obj.doAction ());

			const exclusiveNS:Namespace = obj.getNS ("password");
			tf.appendText ("\n" + obj.exclusiveNS::doAction ());
		}
	}
}
class ClassWithSecret
{
	private namespace exclusive;
	public function getNS (password:String):Namespace
	{
		if (password == "password") return exclusive;
		else return null;
	}


	exclusive function doAction ():String
	{
		return "exclusive thing";
	}


	public function doAction ():String
	{
		return "ordinary thing";
	}
}