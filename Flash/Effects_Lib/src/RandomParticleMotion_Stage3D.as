// forked from flashisobar's 2D Particle Random Motion for Stage3D
package
{
	import flash.display.Sprite;


	[SWF(width = "465", height = "465", frameRate = "60")]
	public class RandomParticleMotion_Stage3D extends Sprite
	{
		private var particle2D:Particle2D;

		public function RandomParticleMotion_Stage3D():void
		{
			particle2D = new Particle2D();
			addChild(particle2D);
		}

	}

}

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.Context3DTriangleFace;
import flash.display3D.IndexBuffer3D;
import flash.display3D.Program3D;
import flash.display3D.textures.Texture;
import flash.display3D.textures.TextureBase;
import flash.display3D.VertexBuffer3D;
import flash.events.Event;
import flash.utils.ByteArray;
///import flash.display.Bitmap;
///import flash.display.BitmapData;

/**
 * base 3D
 *
 * @author flashisobar
 */
class Base3D extends Sprite
{
	private var _context3D:Context3D;
	private var _program:Program3D;
	///private var sc:BitmapData　=　new BitmapData(465,　465,　false);

	public function Base3D()
	{
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e:Event = null):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		///addChild(new Bitmap(sc));

		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		prepareStage3D();
	}

	private function prepareStage3D():void
	{
		stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, handleContextCreate);
		stage.stage3Ds[0].requestContext3D();
	}

	/*
	 * configureBackBuffer: enableDepthAndStencil default is true
	 * enableErrorChecking: slow rendering - only turn on when developing/testing
	 */
	private function handleContextCreate(e:Event):void
	{
		_context3D = stage.stage3Ds[0].context3D;
		if (!_context3D) {
			return;
		}
		_context3D.configureBackBuffer(stage.stageWidth, stage.stageHeight, 4, false);
		_context3D.setCulling(Context3DTriangleFace.BACK);
		_context3D.enableErrorChecking = true;
		_program = _context3D.createProgram();

		main();
		start();
	}

	protected function main():void
	{
	}

	protected function render(e:Event = null):void
	{
		clear();
		draw();
		///_context3D.drawToBitmapData(sc);
		present();
	}

	protected function clear(__red:Number=0, __green:Number=0, __blue:Number=0, __alpha:Number=1):void {
		_context3D.clear(__red, __green, __blue, __alpha);
	}

	protected function draw():void
	{

	}

	protected function present():void
	{
		_context3D.present();
	}

	public function pause():void
	{
		removeEventListener(Event.ENTER_FRAME, render);
	}

	public function start():void
	{
		addEventListener(Event.ENTER_FRAME, render);
	}

	/*
	 * 建立頂點"緩衝區"/定義頂點資料/上傳頂點資料
	 * x,y,u,v        : __data32=4
	 * x,y,z,u,v    : __data32=5
	 * x,y,z,r,g,b    : __data32=6
	 */
	public function setVertexData(__vertexData:Vector.<Number>, __data32Per:int):VertexBuffer3D
	{
		var numVertices:int = __vertexData.length/__data32Per;
		// create buffer
		var vertexBuffer3D:VertexBuffer3D = _context3D.createVertexBuffer(numVertices, __data32Per);
		vertexBuffer3D.uploadFromVector(__vertexData, 0, numVertices);
		return vertexBuffer3D;
	}

	/*
	 * 建立索引"緩衝區"/定義索引資料/上傳索引資料
	 */
	public function setIndexData(__indexData:Vector.<uint>):IndexBuffer3D
	{
		// create buffer
		var indexBuffer:IndexBuffer3D = _context3D.createIndexBuffer(__indexData.length);
		indexBuffer.uploadFromVector(__indexData, 0, __indexData.length);
		return indexBuffer;
	}

	/*
	 * 建立貼圖材質
	 */
	public function setTextureData(__bmd:BitmapData):Texture
	{
		var texture:Texture = _context3D.createTexture(__bmd.width, __bmd.height, Context3DTextureFormat.BGRA, false);
		texture.uploadFromBitmapData(__bmd);
		return texture;
	}

	/*
	 * 設定暫存器
	 */
	public function setVertexBuffer(__index:int, __buffer:VertexBuffer3D, __bufferOffset:int=0, __format:String="float4"):void
	{
		_context3D.setVertexBufferAt(__index, __buffer, __bufferOffset, __format);
	}

	/*
	 * 設定貼圖材質取樣暫存器
	 */
	public function setTexture(__sampler:int, __texture:TextureBase):void
	{
		_context3D.setTextureAt(__sampler, __texture);
	}

	/*
	 * 設定頂點及片段著色器
	 */
	public function setShaders(__vertexProgram:ByteArray, __fragmentProgram:ByteArray):void
	{
		_program.upload(__vertexProgram, __fragmentProgram);
		_context3D.setProgram(_program);
	}

	public function get context3D():Context3D
	{
		return _context3D;
	}

	public function set context3D(value:Context3D):void
	{
		_context3D = value;
	}

}

import com.adobe.utils.AGALMiniAssembler;
import com.bit101.components.NumericStepper;
import com.bit101.components.PushButton;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.ByteArray;
import flash.utils.getTimer;
//import net.hires.debug.Stats;

/**
 * stage3D: 16383*100 particles random motion
 * 2D particle: z = 0, w = 1
 * enableDepthAndStencil = false
 *
 * @author flashisobar
 */
class Particle2D extends Base3D
{
	static public const NUM_PARTICLES:uint = 16383; // max: 16383
	static public const NUM_BUFFERS_MAX:uint = 100; // max: 100

	private var vertexShader:ByteArray;
	private var fragmentShader:ByteArray;
	private var matrix3d:Matrix3D;
	private var w:int = 400;
	private var h:int = 400;
	private var size:Number = 1;
	private var transformConstants:Vector.<Number>;
	private var distance:Vector.<Number>;

	// buffers
	private var vertexParticleBuffers:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>();
	private var posBuffers:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>();
	private var disBuffers:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>();
	private var indexBuffers:Vector.<IndexBuffer3D> = new Vector.<IndexBuffer3D>();

	private var totalNumBuffers:uint = 1;
	private var btn_create:PushButton;
	private var stepper:NumericStepper;
	private var t:uint;
	private var _text:TextField;

	public function Particle2D()
	{

	}

	override protected function main():void
	{
		//this.addChild(new Stats);
		createUI();

		// set vertex/index data
		for (var i:int = 0; i < totalNumBuffers; i++ ) {
			createVertexData();
		}

		// set constants for setProgramConstantsFromMatrix
		transformConstants = new <Number>[0, 0, 0, 1]; // vc4

		// AGAL code
		var assembler:AGALMiniAssembler = new AGALMiniAssembler();
		var code:String = '';
		code += "mov vt0.zw vc4.zw\n";           // vt0 = [0,0,0,1]: z = 0 and size = 1 for 2D particle
		code += "add vt0.xy va0.xy va2.xy\n";    // random position: vt0 = va0 + va2

		code += "div vt1.x vc5.y va3.z\n";       // t/dZ
		code += "frc vt1.x vt1.x\n";             // vt1.x = get value from 0 to 1
		code += "mul vt2.xy va3.xy vt1.xx\n";    // vt2.xy = va3.xy * vt1.xx;
		code += "add vt0.xy vt0.xy vt2.xy\n";    // move: vt0.xy = vt0.xy + vt2.xy

		code += "m44 op, vt0, vc0\n";            // m44: vt0 * vc0
		code += "mov v0, va1\n";
		vertexShader = assembler.assemble(Context3DProgramType.VERTEX, code);

		code = "mov oc, v0";                    // output color: v0
		fragmentShader = assembler.assemble(Context3DProgramType.FRAGMENT, code);
		setShaders(vertexShader, fragmentShader);

		// set projection view or scale
		matrix3d = new Matrix3D();
		//matrix3d.appendRotation(45, Vector3D.Z_AXIS);
		matrix3d.appendScale(1 / w, 1 / h, 1);

		/*
		 * The Matrix3D object you want to upload into constant registers.
		 * Matrix3Ds are always 4×4 matrices so four registers are needed to store their constants.
		 * vc0, vc1, vc2, vc3
		 */
		context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix3d, true); // vc0,vc1,vc2,vc3
		context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, transformConstants); // vc4
	}

	// UI: text+button+stepper
	private function createUI():void
	{
		_text = new TextField();
		_text.defaultTextFormat = new TextFormat("Arial", 11, 0xFFFFFF);
		_text.width = 240;
		_text.height = 100;
		_text.selectable = false;
		_text.mouseEnabled = false;
		_text.text = "particle size:";
		_text.filters = [new DropShadowFilter(1, 45, 0x0, 1, 0, 0)];

		_text.x = stage.stageWidth - 330;
		addChild(_text);

		btn_create = new PushButton(this, stage.stageWidth - 180, 0, "create particle:" + NUM_PARTICLES * totalNumBuffers, handleCreate);
		btn_create.width = 180;
		stepper = new NumericStepper(this, stage.stageWidth - 260, 2, handleStepper);
		stepper.width = 60;
		stepper.value = size;
	}

	private function handleStepper(e:Event):void
	{
		if (e.target.value < 1)
			e.target.value = 1;
		size = e.target.value;
	}

	private function handleCreate(e:MouseEvent):void
	{
		if (totalNumBuffers > NUM_BUFFERS_MAX) {
			return;
		}
		++totalNumBuffers;
		createVertexData();
		btn_create.label = "create particle:"+String(NUM_PARTICLES * totalNumBuffers);
	}

	private function createVertexData():void
	{
		/*
		 * batch and easy create particle
		 */
		var vertexParticle:VertexBuffer3D;
		var indexParticle:IndexBuffer3D;
		var pos:VertexBuffer3D;
		var dis:VertexBuffer3D;
		var vertices:Vector.<Number> = new Vector.<Number>();
		var index:Vector.<uint> = new Vector.<uint>();
		var distance:Vector.<Number> = new Vector.<Number>();
		var postions:Vector.<Number> = new Vector.<Number>();
		var r:Number, g:Number, b:Number, color:Number;
		var s:uint;
		var xPos:Number, yPos:Number, dX:Number, dY:Number, dZ:Number;
		var idx:uint = 0;
		var stime:int = getTimer();
		for (var i:int = 0; i < NUM_PARTICLES; i++) {
			xPos = yPos = 0;
			color = Math.random() * 0xFFFFFF;
			//color = 0xFFFFFF;
			r = (color >> 16) / 255;
			g = (color >> 8 & 0xFF) / 255;
			b = (color & 0xFF) / 255;
			vertices.push(-size, +size, r, g, b);
			vertices.push(+size, +size, r, g, b);
			vertices.push(+size, -size, r, g, b);
			vertices.push(-size, -size, r, g, b); // 共四組
			s = 4 * i;
			index.push(s, s + 1, s + 2, s + 2, s + 3, s);

			xPos = Math.random() * w * 2 -w;
			yPos = Math.random() * h * 2 -h;
			postions.push(xPos, yPos);
			postions.push(xPos, yPos);
			postions.push(xPos, yPos);
			postions.push(xPos, yPos);

			// distance
			dX = 2 * w * Math.random() - w;
			dY = 2 * h * Math.random() - h;
			dZ = 50 * Math.random() + 100;
			distance.push(
					dX, dY, dZ,
					dX, dY, dZ,
					dX, dY, dZ,
					dX, dY, dZ
			); // 四組與頂點(vertices)一樣
		}

		vertexParticle = setVertexData(vertices, 5); // 一次上傳一個頂點含有五個 Number(x,y,r,g,b) 資料
		pos = setVertexData(postions, 2);
		dis = setVertexData(distance, 3);
		indexParticle = setIndexData(index);

		vertexParticleBuffers.push(vertexParticle);
		posBuffers.push(pos);
		disBuffers.push(dis);
		indexBuffers.push(indexParticle);
		trace("Time:" + (getTimer() - stime));
		// =========================================================

	}

	/*
	 -0.5, 0.5, 0, 0, 1, // x,y,r,g,b
	 0.5, 0.5, 0, 0, 1,
	 0.5, -0.5, 0, 0, 1,
	 -0.5, -0.5, 0, 0, 1
	 */
	private function createParticle(xPos:Number, yPos:Number, color:uint):Vector.<Number>
	{
		var r:Number = (color >> 16) / 255;
		var g:Number = (color >> 8 & 0xFF) / 255;
		var b:Number = (color & 0xFF) / 255;
		return Vector.<Number>([xPos - size, yPos + size, r, g, b, xPos + size, yPos + size, r, g, b, xPos + size, yPos - size, r, g, b, xPos - size, yPos - size, r, g, b]);
	}

	override protected function draw():void
	{
		if (totalNumBuffers < 1)
		{
			return;
		}
		context3D.clear(.4);
		++t;
		context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, new <Number>[1, t, 1, 1]);// vc5
		var i:int;
		for (i = 0; i < totalNumBuffers; i++ ) {
			// set register
			setVertexBuffer(0, vertexParticleBuffers[i], 0, Context3DVertexBufferFormat.FLOAT_2); // register0: va0(xy)
			setVertexBuffer(1, vertexParticleBuffers[i], 2, Context3DVertexBufferFormat.FLOAT_3); // register1: va1(color)
			setVertexBuffer(2, posBuffers[i], 0, Context3DVertexBufferFormat.FLOAT_2); // register2: va2
			setVertexBuffer(3, disBuffers[i], 0 , Context3DVertexBufferFormat.FLOAT_3);// register3: va3
			context3D.drawTriangles(indexBuffers[i]);
		}

	}
}

