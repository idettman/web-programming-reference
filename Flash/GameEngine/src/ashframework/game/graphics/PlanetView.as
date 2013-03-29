/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 6:17 PM
 */
package ashframework.game.graphics
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;


	public class PlanetView extends Mesh
	{
		public function PlanetView (geometry:Geometry, material:MaterialBase = null)
		{
			super (geometry, material);
		}
	}
}
