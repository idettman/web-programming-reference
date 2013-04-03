/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 4/2/13
 * Time: 12:00 PM
 */
package
{
	import flash.geom.Vector3D;


	public class Force
	{
		private var name:String;
		private var vector:Vector3D;


		public function Force (name:String, vector:Vector3D)
		{
			this.name = name;
			this.vector = vector;
		}


		public function act (obj:OrbitalBody):void
		{
			if (typeof obj.forceStore[name] !== 'object')
			{
				obj.forceStore[name] = vector;
				obj.forceChanged = true;
			}
		}


		public function stop (obj:OrbitalBody):void
		{
			if (typeof obj.forceStore[name] === 'object')
			{
				delete obj.forceStore[name];
				obj.forceChanged = true;
			}
		}

	}
}
