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
package com.element.oimo.physics.constraint.joint {
	import com.element.oimo.math.Vec3;


	/**
	 * The class of common settings that are used during the initialization of the joint.
	 * Variable of this class can be used to copy, it is not with a direct reference.
	 * @author saharan
	 */
	public class JointConfig {
		/**
		 * Position relative to the initial state is connected to the rigid one.
		 */
		public var localRelativeAnchorPosition1:Vec3;
		
		/**
		 * Position relative to the initial state is connected to the two rigid bodies.
		 */
		public var localRelativeAnchorPosition2:Vec3;
		
		/**
		 * The axis of rotation of the rigid body in the initial state for one.
		 * This option is only available in some joints.
		 */
		public var localAxis1:Vec3;
		
		/**
		 * The axis of rotation of the initial state for the two rigid bodies.
		 * This option is only available in some joints.
		 */
		public var localAxis2:Vec3;
		
		/**
		 * 接続された剛体同士が衝突するかどうかを表します。
		 */
		public var allowCollide:Boolean;
		
		/**
		 * 新しく JointConfig オブジェクトを作成します。
		 */
		public function JointConfig() {
			localRelativeAnchorPosition1 = new Vec3();
			localRelativeAnchorPosition2 = new Vec3();
			localAxis1 = new Vec3();
			localAxis2 = new Vec3();
		}
		
	}

}