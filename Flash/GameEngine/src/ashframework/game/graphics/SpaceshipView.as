/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 4:24 PM
 */
package ashframework.game.graphics
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;


	public class SpaceshipView extends Mesh
	{

		public function SpaceshipView ()
		{
			var geometry:Geometry = new CubeGeometry ();
			var material:ColorMaterial = new ColorMaterial (0xFF0000);

			super (geometry, material);
		}
	}
}
