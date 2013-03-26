/* Copyright (c) 2012 EL-EMENT saharan
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation  * files (the "Software"), to deal in the Software
 * without restriction, including without limitation the rights to use, copy,  * modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
 * whom the Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 * ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package com.element.oimo.physics.dynamics {
	import com.element.oimo.math.Mat33;
	import com.element.oimo.math.Mat44;
	import com.element.oimo.math.Quat;
	import com.element.oimo.math.Vec3;
	import com.element.oimo.physics.collision.shape.Shape;
	import com.element.oimo.physics.constraint.joint.Joint;


	/**
	 *It is the class of the rigid body.
	 * Rigid body has the shape of a singular or plural for processing the collision,
	 * You can set the parameters individually.
	 * @author saharan
	 */
	public class RigidBody {
		/**
		 * It is a kind of rigid body that represents the rigid body dynamic。
		 */
		public static const BODY_DYNAMIC:uint = 0x0;
		
		/**
		 * It is a kind of rigid body that represents the rigid body static。
		 */
		public static const BODY_STATIC:uint = 0x1;
		
		/**
		 * The maximum number of shapes that can be added to a single rigid body.
		 */
		public static const MAX_SHAPES:uint = 64;
		
		/**
		 * The maximum number of joints that can be connected to a single rigid body.
		 */
		public static const MAX_JOINTS:uint = 512;
		
		/**
		 * I represent the kind of rigid.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 *
		 * If you want to change the type of a rigid body, be sure to
		 * Please specify the type you want to set the argument of setupMass method.
		 */
		public var type:uint;
		
		/**
		 * It is the world coordinate of the center of gravity。
		 */
		public var position:Vec3;
		
		/**
		 * This translational velocity.
		 */
		public var linearVelocity:Vec3;
		
		/**
		 * It is a quaternion representing the attitude.
		 */
		public var orientation:Quat;
		
		/**
		 * The rotation matrix representing the orientation.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 *
		 * Rotation matrix is recalculated from the quaternion at each step.
		 */
		public var rotation:Mat33;
		
		/**
		 * Angular velocity
		 */
		public var angularVelocity:Vec3;


		/**
		 * Isaac: Addition for easy integration with Away3d
		 */
		public var matrix3d:Mat44;

		/**
		 * It is the mass.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 *
		 * Mass Calling setupMass method,
		 * Recalculated automatically from the shape that is included.
		 */
		public var mass:Number;
		
		/**
		 * It is the reciprocal of the mass.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 *
		 * Mass Calling setupMass method,
		 * Recalculated automatically from the shape that is included.
		 */
		public var invertMass:Number;
		
		/**
		 * This is the inverse matrix of the inertia tensor in the world system.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 *
		 * Inverse of the inertia tensor in world system, for each step
		 * Is recalculated from the reciprocal of the inertia tensor of the initial state and the attitude.
		 */
		public var invertInertia:Mat33;
		
		/**
		 * It is the inertia tensor of the initial state.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 *
		 * If you call the inertia tensor setupMass method,
		 * Recalculated automatically from the shape that is included.
		 */
		public var localInertia:Mat33;
		
		/**
		 * This is the inverse matrix of the inertia tensor in the initial state.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 *
		 * If you call the inertia tensor setupMass method,
		 * Recalculated automatically from the shape that is included.
		 */
		public var invertLocalInertia:Mat33;
		
		/**
		 * An array of shapes that are included in the body.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 */
		public var shapes:Vector.<Shape>;
		
		/**
		 * It is the number of shapes that are included in the rigid body.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 */
		public var numShapes:uint;
		
		/**
		 * An array of joints that are connected to the rigid body.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 */
		public var joints:Vector.<Joint>;
		
		/**
		 * It is the number of joints that are connected to the rigid body.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 */
		public var numJoints:uint;
		
		/**
		 * It is this rigid world that has been added.
		 <strong> This variable * Please do not change from the outside. </ strong>
		 */
		public var parent:World;



		public var id:String = "";

		
		/**
		 * I want to create a new object RigidBody.
		 * You can also specify a rotational component.
		 *  @ Param rad rotation angle in radians
		 *	 X component of the rotation axis * @ param ax
		 *	 Y component of the rotation axis * @ param ay
		 *	 Z component of the rotation axis * @ param az
		 */
		public function RigidBody(rad:Number = 0, ax:Number = 0, ay:Number = 0, az:Number = 0) {
			position = new Vec3();
			linearVelocity = new Vec3();
			// Isaac addition
			matrix3d = new Mat44 ();
			var len:Number = ax * ax + ay * ay + az * az;
			if (len > 0) {
				len = 1 / Math.sqrt(len);
				ax *= len;
				ay *= len;
				az *= len;
			}
			var sin:Number = Math.sin(rad * 0.5);
			var cos:Number = Math.cos(rad * 0.5);
			orientation = new Quat(cos, sin * ax, sin * ay, sin * az);
			rotation = new Mat33();
			angularVelocity = new Vec3();
			invertInertia = new Mat33();
			localInertia = new Mat33();
			invertLocalInertia = new Mat33();
			shapes = new Vector.<Shape>(MAX_SHAPES, true);
			joints = new Vector.<Joint>(MAX_JOINTS, true);
		}
		
		/**
		 * I want to add a shape to the body.
		 * If you add a shape, please call the setupMass method before the start of the next step.
		 * @ Param shape the shape you want to add
		 */
		public function addShape(shape:Shape):void {
			if (numShapes == MAX_SHAPES) {
				throw new Error("Maximum shape limit, more shapes cannot be added");
			}
			if (shape.parent) {
				throw new Error("I can not add more than one shape to rigid");
			}
			shapes[numShapes++] = shape;
			shape.parent = this;
			if (parent) {
				parent.addShape(shape);
			}
		}
		
		/**
		 * I remove the shape from the rigid body.
		 * If you specify the index of the shape to be removed, we remove it using only the index.
		 * If you delete a form, please call the setupMass method before the start of the next step.
		 * @ Param shape the shape that you want to delete
		 * @ param index The index of the shape that you want to remove
		 */
		public function removeShape(shape:Shape, index:int = -1):void {
			if (index < 0) {
				for (var i:int = 0; i < numShapes; i++) {
					if (shape == shapes[i]) {
						index = i;
						break;
					}
				}
				if (index == -1) {
					return;
				}
			} else if (index >= numShapes) {
				throw new Error("削除する形状のインデックスが範囲外です");
			}
			var remove:Shape = shapes[index];
			remove.parent = null;
			if (parent) {
				parent.removeShape(remove);
			}
			numShapes--;
			for (var j:int = index; j < numShapes; j++) {
				shapes[j] = shapes[j + 1];
			}
			shapes[numShapes] = null;
		}
		
		/**
		 * I calculate the coordinates of the center of gravity, mass, inertia tensor, etc..
		 * If you specify * BODY_STATIC to type, this rigid body is fixed to the space.
		 * @ Param type the type of rigid body
		 */
		public function setupMass(type:uint = BODY_DYNAMIC):void {
			this.type = type;
			position.init();
			mass = 0;
			localInertia.init(0, 0, 0, 0, 0, 0, 0, 0, 0);
			var invRot:Mat33 = new Mat33(); // = rotation ^ -1
			invRot.transpose(rotation);
			var tmpM:Mat33 = new Mat33();
			var tmpV:Vec3 = new Vec3();
			var denom:Number = 0;
			for (var i:int = 0; i < numShapes; i++) {
				var shape:Shape = shapes[i];
				// relativeRotation = (rotation ^ -1) * shape.rotation
				shape.relativeRotation.mul(invRot, shape.rotation);
				position.add(position, tmpV.scale(shape.position, shape.mass));
				denom += shape.mass;
				mass += shape.mass;
				// inertia = rotation * localInertia * (rotation ^ -1)
				tmpM.mul(shape.relativeRotation, tmpM.mul(shape.localInertia, tmpM.transpose(shape.relativeRotation)));
				localInertia.add(localInertia, tmpM);
			}
			position.scale(position, 1 / denom);
			invertMass = 1 / mass;
			var xy:Number = 0;
			var yz:Number = 0;
			var zx:Number = 0;
			for (var j:int = 0; j < numShapes; j++) {
				shape = shapes[j];
				var relPos:Vec3 = shape.localRelativePosition;
				relPos.sub(shape.position, position).mulMat(invRot, relPos);
				shape.updateProxy();
				localInertia.e00 += shape.mass * (relPos.y * relPos.y + relPos.z * relPos.z);
				localInertia.e11 += shape.mass * (relPos.x * relPos.x + relPos.z * relPos.z);
				localInertia.e22 += shape.mass * (relPos.x * relPos.x + relPos.y * relPos.y);
				xy -= shape.mass * relPos.x * relPos.y;
				yz -= shape.mass * relPos.y * relPos.z;
				zx -= shape.mass * relPos.z * relPos.x;
			}
			localInertia.e01 = xy;
			localInertia.e10 = xy;
			localInertia.e02 = zx;
			localInertia.e20 = zx;
			localInertia.e12 = yz;
			localInertia.e21 = yz;
			invertLocalInertia.invert(localInertia);
			if (type == BODY_STATIC) {
				invertMass = 0;
				invertLocalInertia.init(0, 0, 0, 0, 0, 0, 0, 0, 0);
			}
			var r00:Number = rotation.e00;
			var r01:Number = rotation.e01;
			var r02:Number = rotation.e02;
			var r10:Number = rotation.e10;
			var r11:Number = rotation.e11;
			var r12:Number = rotation.e12;
			var r20:Number = rotation.e20;
			var r21:Number = rotation.e21;
			var r22:Number = rotation.e22;
			var i00:Number = invertLocalInertia.e00;
			var i01:Number = invertLocalInertia.e01;
			var i02:Number = invertLocalInertia.e02;
			var i10:Number = invertLocalInertia.e10;
			var i11:Number = invertLocalInertia.e11;
			var i12:Number = invertLocalInertia.e12;
			var i20:Number = invertLocalInertia.e20;
			var i21:Number = invertLocalInertia.e21;
			var i22:Number = invertLocalInertia.e22;
			var e00:Number = r00 * i00 + r01 * i10 + r02 * i20;
			var e01:Number = r00 * i01 + r01 * i11 + r02 * i21;
			var e02:Number = r00 * i02 + r01 * i12 + r02 * i22;
			var e10:Number = r10 * i00 + r11 * i10 + r12 * i20;
			var e11:Number = r10 * i01 + r11 * i11 + r12 * i21;
			var e12:Number = r10 * i02 + r11 * i12 + r12 * i22;
			var e20:Number = r20 * i00 + r21 * i10 + r22 * i20;
			var e21:Number = r20 * i01 + r21 * i11 + r22 * i21;
			var e22:Number = r20 * i02 + r21 * i12 + r22 * i22;
			invertInertia.e00 = e00 * r00 + e01 * r01 + e02 * r02;
			invertInertia.e01 = e00 * r10 + e01 * r11 + e02 * r12;
			invertInertia.e02 = e00 * r20 + e01 * r21 + e02 * r22;
			invertInertia.e10 = e10 * r00 + e11 * r01 + e12 * r02;
			invertInertia.e11 = e10 * r10 + e11 * r11 + e12 * r12;
			invertInertia.e12 = e10 * r20 + e11 * r21 + e12 * r22;
			invertInertia.e20 = e20 * r00 + e21 * r01 + e22 * r02;
			invertInertia.e21 = e20 * r10 + e21 * r11 + e22 * r12;
			invertInertia.e22 = e20 * r20 + e21 * r21 + e22 * r22;
		}
		
		/**
		 * We calculate the change in velocity of the rigid body by an external force.
		 * This method is called automatically when the step of the world called,
		 * You do not need to be called from the outside usually.
		 *
		 * @ param timeStep Time step size
		 * @ Param gravity gravity
		 */
		public function updateVelocity(timeStep:Number, gravity:Vec3):void {
			if (type == BODY_DYNAMIC) {
				linearVelocity.x += gravity.x * timeStep;
				linearVelocity.y += gravity.y * timeStep;
				linearVelocity.z += gravity.z * timeStep;
			}
		}
		
		/**
		 * The time integral of the rigid body motion, such as the shape information is updated.
		 * This method is called automatically when the step of the world called,
		 * You do not need to be called from the outside usually.
		 * @ param timeStep Time step size
		 */
		public function updatePosition(timeStep:Number):void {
			var s:Number;
			var x:Number;
			var y:Number;
			var z:Number;
			if (type == BODY_STATIC) {
				linearVelocity.x = 0;
				linearVelocity.y = 0;
				linearVelocity.z = 0;
				angularVelocity.x = 0;
				angularVelocity.y = 0;
				angularVelocity.z = 0;
			} else if (type == BODY_DYNAMIC) {
				position.x += linearVelocity.x * timeStep;
				position.y += linearVelocity.y * timeStep;
				position.z += linearVelocity.z * timeStep;
				/*var ax:Number = angularVelocity.x;
				var ay:Number = angularVelocity.y;
				var az:Number = angularVelocity.z;
				var len:Number = Math.sqrt(ax * ax + ay * ay + az * az);
				var theta:Number = len * timeStep;
				if (len > 0) len = 1 / len;
				ax *= len;
				ay *= len;
				az *= len;
				var sin:Number = Math.sin(theta * 0.5);
				var cos:Number = Math.cos(theta * 0.5);
				var q:Quat = new Quat(cos, ax * sin, ay * sin, az * sin);
				orientation.mul(q, orientation);*/
				var ax:Number = angularVelocity.x;
				var ay:Number = angularVelocity.y;
				var az:Number = angularVelocity.z;
				var os:Number = orientation.s;
				var ox:Number = orientation.x;
				var oy:Number = orientation.y;
				var oz:Number = orientation.z;
				timeStep *= 0.5;
				s = (-ax * ox - ay * oy - az * oz) * timeStep;
				x = (ax * os + ay * oz - az * oy) * timeStep;
				y = (-ax * oz + ay * os + az * ox) * timeStep;
				z = (ax * oy - ay * ox + az * os) * timeStep;
				os += s;
				ox += x;
				oy += y;
				oz += z;
				s = 1 / Math.sqrt(os * os + ox * ox + oy * oy + oz * oz);
				orientation.s = os * s;
				orientation.x = ox * s;
				orientation.y = oy * s;
				orientation.z = oz * s;
			} else {
				throw new Error("The rigid body type is undefined");
			}
			s = orientation.s;
			x = orientation.x;
			y = orientation.y;
			z = orientation.z;
			var x2:Number = 2 * x;
			var y2:Number = 2 * y;
			var z2:Number = 2 * z;
			var xx:Number = x * x2;
			var yy:Number = y * y2;
			var zz:Number = z * z2;
			var xy:Number = x * y2;
			var yz:Number = y * z2;
			var xz:Number = x * z2;
			var sx:Number = s * x2;
			var sy:Number = s * y2;
			var sz:Number = s * z2;
			rotation.e00 = 1 - yy - zz;
			rotation.e01 = xy - sz;
			rotation.e02 = xz + sy;
			rotation.e10 = xy + sz;
			rotation.e11 = 1 - xx - zz;
			rotation.e12 = yz - sx;
			rotation.e20 = xz - sy;
			rotation.e21 = yz + sx;
			rotation.e22 = 1 - xx - yy;
			var r00:Number = rotation.e00;
			var r01:Number = rotation.e01;
			var r02:Number = rotation.e02;
			var r10:Number = rotation.e10;
			var r11:Number = rotation.e11;
			var r12:Number = rotation.e12;
			var r20:Number = rotation.e20;
			var r21:Number = rotation.e21;
			var r22:Number = rotation.e22;
			var i00:Number = invertLocalInertia.e00;
			var i01:Number = invertLocalInertia.e01;
			var i02:Number = invertLocalInertia.e02;
			var i10:Number = invertLocalInertia.e10;
			var i11:Number = invertLocalInertia.e11;
			var i12:Number = invertLocalInertia.e12;
			var i20:Number = invertLocalInertia.e20;
			var i21:Number = invertLocalInertia.e21;
			var i22:Number = invertLocalInertia.e22;
			var e00:Number = r00 * i00 + r01 * i10 + r02 * i20;
			var e01:Number = r00 * i01 + r01 * i11 + r02 * i21;
			var e02:Number = r00 * i02 + r01 * i12 + r02 * i22;
			var e10:Number = r10 * i00 + r11 * i10 + r12 * i20;
			var e11:Number = r10 * i01 + r11 * i11 + r12 * i21;
			var e12:Number = r10 * i02 + r11 * i12 + r12 * i22;
			var e20:Number = r20 * i00 + r21 * i10 + r22 * i20;
			var e21:Number = r20 * i01 + r21 * i11 + r22 * i21;
			var e22:Number = r20 * i02 + r21 * i12 + r22 * i22;
			invertInertia.e00 = e00 * r00 + e01 * r01 + e02 * r02;
			invertInertia.e01 = e00 * r10 + e01 * r11 + e02 * r12;
			invertInertia.e02 = e00 * r20 + e01 * r21 + e02 * r22;
			invertInertia.e10 = e10 * r00 + e11 * r01 + e12 * r02;
			invertInertia.e11 = e10 * r10 + e11 * r11 + e12 * r12;
			invertInertia.e12 = e10 * r20 + e11 * r21 + e12 * r22;
			invertInertia.e20 = e20 * r00 + e21 * r01 + e22 * r02;
			invertInertia.e21 = e20 * r10 + e21 * r11 + e22 * r12;
			invertInertia.e22 = e20 * r20 + e21 * r21 + e22 * r22;
			for (var i:int = 0; i < numShapes; i++) {
				var shape:Shape = shapes[i];
				var relPos:Vec3 = shape.relativePosition;
				var lRelPos:Vec3 = shape.localRelativePosition;
				var relRot:Mat33 = shape.relativeRotation;
				var rot:Mat33 = shape.rotation;
				var lx:Number = lRelPos.x;
				var ly:Number = lRelPos.y;
				var lz:Number = lRelPos.z;
				relPos.x = lx * r00 + ly * r01 + lz * r02;
				relPos.y = lx * r10 + ly * r11 + lz * r12;
				relPos.z = lx * r20 + ly * r21 + lz * r22;
				shape.position.x = position.x + relPos.x;
				shape.position.y = position.y + relPos.y;
				shape.position.z = position.z + relPos.z;
				e00 = relRot.e00;
				e01 = relRot.e01;
				e02 = relRot.e02;
				e10 = relRot.e10;
				e11 = relRot.e11;
				e12 = relRot.e12;
				e20 = relRot.e20;
				e21 = relRot.e21;
				e22 = relRot.e22;
				rot.e00 = r00 * e00 + r01 * e10 + r02 * e20;
				rot.e01 = r00 * e01 + r01 * e11 + r02 * e21;
				rot.e02 = r00 * e02 + r01 * e12 + r02 * e22;
				rot.e10 = r10 * e00 + r11 * e10 + r12 * e20;
				rot.e11 = r10 * e01 + r11 * e11 + r12 * e21;
				rot.e12 = r10 * e02 + r11 * e12 + r12 * e22;
				rot.e20 = r20 * e00 + r21 * e10 + r22 * e20;
				rot.e21 = r20 * e01 + r21 * e11 + r22 * e21;
				rot.e22 = r20 * e02 + r21 * e12 + r22 * e22;
				shape.updateProxy();
			}

			// Isaac: Addition for integration with away3d
			matrix3d.copyMat33 (rotation);
			matrix3d.e03 = position.x;
			matrix3d.e13 = position.y;
			matrix3d.e23 = position.z;
		}


		public var collisionCallback:Function;
		public function onCollision(childCollision:Shape, otherCollision:Shape):void
		{
			if (collisionCallback)
			{
				collisionCallback (childCollision, otherCollision);
			}
			//trace ("detector: numContactInfos:", s1.parent.id, s2.parent.id);
		}


		public function applyImpulse(position:Vec3, force:Vec3):void {
			linearVelocity.x += force.x * invertMass;
			linearVelocity.y += force.y * invertMass;
			linearVelocity.z += force.z * invertMass;
			var rel:Vec3 = new Vec3();
			rel.sub(position, this.position).cross(rel, force).mulMat(invertInertia, rel);
			angularVelocity.x += rel.x;
			angularVelocity.y += rel.y;
			angularVelocity.z += rel.z;
		}
		
	}

}