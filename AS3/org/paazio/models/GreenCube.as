/*
package org.paazio.models {
	// http://www.rozengain.com/blog/2008/01/02/export-your-blender-objects-straight-to-away3d-papervision3d-and-sandy/
	// Papervision3D 2.0
	
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.proto.MaterialObject3D;

	public class GreenCube extends TriangleMesh3D {
		private var ve:Array;
		private var fa:Array;

		public function GreenCube(material : MaterialObject3D ) {
			super( material, new Array(), new Array() );
			ve = this.geometry.vertices;
			fa = this.geometry.faces;
			v(1.000000,-1.000000,1.000000);
			v(1.000000,-1.000000,-1.000000);
			v(-1.000000,-1.000000,-1.000000);
			v(-1.000000,-1.000000,1.000000);
			v(1.000000,1.000000,0.999999);
			v(0.999999,1.000000,-1.000001);
			v(-1.000000,1.000000,-1.000000);
			v(-1.000000,1.000000,1.000000);

			f2(0,1,2);
			f2(4,7,6);
			f2(0,4,5);
			f2(1,5,6);
			f2(2,6,7);
			f2(4,0,3);

			this.x = -0.052487;
			this.y = 0.000000;
			this.z = -0.052487;

			this.rotationX = 29.448419;
			this.rotationY = 56.238763;
			this.rotationZ = -57.629366;

			this.scaleX = 1.000000;
			this.scaleY = 1.000000;
			this.scaleZ = 1.000000;

			this.geometry.ready = true;
		}
		public function v(x:Number, y:Number, z:Number):void
		{
			ve.push(new Vertex3D(x, y, z));
		}

		public function f(vertexIndex1:Number, vertexIndex2:Number, vertexIndex3:Number, uv00:Number, uv01:Number, uv10:Number, uv11:Number, uv20:Number, uv21:Number, normalx:Number, normaly:Number, normalz:Number):void
		{
			var face : Triangle3D = new Triangle3D(this, [ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]], null, [ new NumberUV(uv00, uv01), new NumberUV(uv10, uv11), new NumberUV(uv20, uv21) ] );
			face.faceNormal = new Number3D(normalx,normaly,normalz);
			fa.push(face);
		}

		public function f2(vertexIndex1:Number, vertexIndex2:Number, vertexIndex3:Number):void
		{
			var face:Triangle3D = new Triangle3D(this, [ve[vertexIndex1], ve[vertexIndex2], ve[vertexIndex3]], null, []);
			fa.push(face);
		}

	}
}
*/
