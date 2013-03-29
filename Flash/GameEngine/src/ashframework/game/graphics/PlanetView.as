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
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.primitives.SphereGeometry;


	public class PlanetView extends Mesh
	{
		public function PlanetView ()
		{
			var geometry:Geometry = new SphereGeometry ();
			var material:MaterialBase = new ColorMaterial (0xFF0000);
			
			super (geometry, material);
		}
	}
}
