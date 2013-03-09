﻿package away3dlite.loaders{	import away3dlite.arcane;	import away3dlite.containers.*;	import away3dlite.core.base.*;	import away3dlite.core.utils.*;	import away3dlite.loaders.data.*;	import flash.geom.*;	import flash.utils.*;	use namespace arcane;	    /**    * File loader for the 3DS file format.    */	public class Max3DS extends AbstractParser	{		/** @private */        arcane override function prepareData(data:*):void        {			max3ds = Cast.bytearray(data);			max3ds.endian = Endian.LITTLE_ENDIAN;						//first chunk is always the primary, so we simply read it and parse it			var chunk:Chunk3ds = new Chunk3ds();			readChunk(chunk);			parse3DS(chunk);						//build the meshes			buildMeshes();						//build materials			buildMaterials();        }        		/** An array of bytes from the 3ds files. */		private var max3ds:ByteArray;		private var _materialData:MaterialData;		private var _face:Face;		private var _meshData:MeshData;		private var _geometryData:GeometryData;		private var _meshDictionary:Dictionary = new Dictionary();		private var _moveVector:Vector3D = new Vector3D();				//>----- Color Types --------------------------------------------------------				private const AMBIENT:String = "ambient";		private const DIFFUSE:String = "diffuse";		private const SPECULAR:String = "specular";				//>----- Main Chunks --------------------------------------------------------				//private const PRIMARY:int = 0x4D4D;		private const EDIT3DS:int = 0x3D3D;  // Start of our actual objects		private const KEYF3DS:int = 0xB000;  // Start of the keyframe information				//>----- General Chunks -----------------------------------------------------				//private const VERSION:int = 0x0002;		//private const MESH_VERSION:int = 0x3D3E;		//private const KFVERSION:int = 0x0005;		private const COLOR_F:int = 0x0010;		private const COLOR_RGB:int = 0x0011;		//private const LIN_COLOR_24:int = 0x0012;		//private const LIN_COLOR_F:int = 0x0013;		//private const INT_PERCENTAGE:int = 0x0030;		//private const FLOAT_PERC:int = 0x0031;		//private const MASTER_SCALE:int = 0x0100;		//private const IMAGE_FILE:int = 0x1100;		//private const AMBIENT_LIGHT:int = 0X2100;				//>----- Object Chunks -----------------------------------------------------				private const MESH:int = 0x4000;		private const MESH_OBJECT:int = 0x4100;		private const MESH_VERTICES:int = 0x4110;		//private const VERTEX_FLAGS:int = 0x4111;		private const MESH_FACES:int = 0x4120;		private const MESH_MATER:int = 0x4130;		private const MESH_TEX_VERT:int = 0x4140;		//private const MESH_XFMATRIX:int = 0x4160;		//private const MESH_COLOR_IND:int = 0x4165;		//private const MESH_TEX_INFO:int = 0x4170;		//private const HEIRARCHY:int = 0x4F00;				//>----- Material Chunks ---------------------------------------------------				private const MATERIAL:int = 0xAFFF;		private const MAT_NAME:int = 0xA000;		private const MAT_AMBIENT:int = 0xA010;		private const MAT_DIFFUSE:int = 0xA020;		private const MAT_SPECULAR:int = 0xA030;		//private const MAT_SHININESS:int = 0xA040;		//private const MAT_FALLOFF:int = 0xA052;		//private const MAT_EMISSIVE:int = 0xA080;		//private const MAT_SHADER:int = 0xA100;		private const MAT_TEXMAP:int = 0xA200;		private const MAT_TEXFLNM:int = 0xA300;		//private const OBJ_LIGHT:int = 0x4600;		//private const OBJ_CAMERA:int = 0x4700;				//>----- KeyFrames Chunks --------------------------------------------------				private const ANIM_HEADER:int = 0xB00A;		private const ANIM_OBJ:int = 0xB002;		private const ANIM_NAME:int = 0xB010;		private const ANIM_PIVOT:int = 0xB013;		//private const ANIM_POS:int = 0xB020;		//private const ANIM_ROT:int = 0xB021;		//private const ANIM_SCALE:int = 0xB022;    	    	/**    	 * Array of mesh data objects used for storing the parsed 3ds data structure.    	 */		private var meshDataList:Array = [];				/**		 * Read id and length of 3ds chunk		 * 		 * @param chunk 		 * 		 */				private function readChunk(chunk:Chunk3ds):void		{			chunk.id = max3ds.readUnsignedShort();			chunk.length = max3ds.readUnsignedInt();			chunk.bytesRead = 6;		}				/**		 * Skips past a chunk. If we don't understand the meaning of a chunk id,		 * we just skip past it.		 * 		 * @param chunk		 * 		 */				private function skipChunk(chunk:Chunk3ds):void		{			max3ds.position += chunk.length - chunk.bytesRead;			chunk.bytesRead = chunk.length;		}				/**		 * Read the base 3DS object.		 * 		 * @param chunk		 * 		 */				private function parse3DS(chunk:Chunk3ds):void		{			while (chunk.bytesRead < chunk.length)			{				var subChunk:Chunk3ds = new Chunk3ds();				readChunk(subChunk);				switch (subChunk.id)				{					case EDIT3DS:						parseEdit3DS(subChunk);						break;					case KEYF3DS:						parseKey3DS(subChunk);						break;					default:						skipChunk(subChunk);				}				chunk.bytesRead += subChunk.length;			}		}				/**		 * Read the Edit chunk		 * 		 * @param chunk		 * 		 */		private function parseEdit3DS(chunk:Chunk3ds):void		{			while (chunk.bytesRead < chunk.length)			{				var subChunk:Chunk3ds = new Chunk3ds();				readChunk(subChunk);				switch (subChunk.id)				{					case MATERIAL:						parseMaterial(subChunk);						break;					case MESH:						_meshData = new MeshData();						readMeshName(subChunk);        				_meshData.geometry = _geometryLibrary.addGeometry(_meshData.name);        				_geometryData = _meshData.geometry;						parseMesh(subChunk);						meshDataList.push(_meshData);												if (centerMeshes) {							_geometryData.maxX = -Infinity;							_geometryData.minX = Infinity;							_geometryData.maxY = -Infinity;							_geometryData.minY = Infinity;							_geometryData.maxZ = -Infinity;							_geometryData.minZ = Infinity;							var i:int = _meshData.geometry.vertices.length/3;							var vertexX:Number;							var vertexY:Number;							var vertexZ:Number;			                while (i--) {			                	vertexX = _meshData.geometry.vertices[i*3];			                	vertexY = _meshData.geometry.vertices[i*3+1];			                	vertexZ = _meshData.geometry.vertices[i*3+2];								if (_geometryData.maxX < vertexX)									_geometryData.maxX = vertexX;								if (_geometryData.minX > vertexX)									_geometryData.minX = vertexX;								if (_geometryData.maxY < vertexY)									_geometryData.maxY = vertexY;								if (_geometryData.minY > vertexY)									_geometryData.minY = vertexY;								if (_geometryData.maxZ < vertexZ)									_geometryData.maxZ = vertexZ;								if (_geometryData.minZ > vertexZ)									_geometryData.minZ = vertexZ;			                }						}												break;					default:						skipChunk(subChunk);				}								chunk.bytesRead += subChunk.length;			}		}				/**		 * Read the Key chunk		 * 		 * @param chunk		 * 		 */		private function parseKey3DS(chunk:Chunk3ds):void		{			while (chunk.bytesRead < chunk.length)			{				var subChunk:Chunk3ds = new Chunk3ds();				readChunk(subChunk);				switch (subChunk.id)				{					case ANIM_HEADER:						testChunk(subChunk);						break;					case ANIM_OBJ:						parseAnimation(subChunk);						break;					default:						skipChunk(subChunk);				}								chunk.bytesRead += subChunk.length;			}		}				private function testChunk(chunk:Chunk3ds):void		{			max3ds.position += chunk.length - chunk.bytesRead;			chunk.bytesRead = chunk.length;		}				private function parseMaterial(chunk:Chunk3ds):void		{			while (chunk.bytesRead < chunk.length)			{				var subChunk:Chunk3ds = new Chunk3ds();				readChunk(subChunk);				switch (subChunk.id)				{					case MAT_NAME:						readMaterialName(subChunk);						break;					case MAT_AMBIENT:						readColor(AMBIENT);						break;					case MAT_DIFFUSE:						readColor(DIFFUSE);						break;					case MAT_SPECULAR:						readColor(SPECULAR);						break;					case MAT_TEXMAP:						parseMaterial(subChunk);						break;					case MAT_TEXFLNM:						readTextureFileName(subChunk);						break;					default:						skipChunk(subChunk);				}				chunk.bytesRead += subChunk.length;			}		}				private function parseAnimation(chunk:Chunk3ds):void		{			while (chunk.bytesRead < chunk.length) {				var subChunk:Chunk3ds = new Chunk3ds();				readChunk(subChunk);				switch (subChunk.id) {					case ANIM_NAME:						readAnimationName(subChunk);						break;					case ANIM_PIVOT:						readPivot(subChunk);						break;					/*					case ANIM_POS:						readPosTrack(subChunk);						break;					case ANIM_ROT:						readRotTrack(subChunk);						break;					case ANIM_SCALE:						readScaleTrack(subChunk);						break;					*/					default:						skipChunk(subChunk);				}								chunk.bytesRead += subChunk.length;			}		}				private function readAnimationName(chunk:Chunk3ds):void		{			_meshData = _meshDictionary[readASCIIZString(max3ds)] as MeshData;			chunk.bytesRead += _meshData.name.length + 1;						var flags1:int = max3ds.readUnsignedShort();			flags1;			chunk.bytesRead += 2;						var flags2:int = max3ds.readUnsignedShort();			flags2;			chunk.bytesRead += 2;						var heirarchy:int = max3ds.readUnsignedShort();			heirarchy;			chunk.bytesRead += 2;		}				private function readPivot(chunk:Chunk3ds):void		{			var x:Number = max3ds.readFloat();			var y:Number = max3ds.readFloat();			var z:Number = max3ds.readFloat();			_meshData.transform.appendTranslation(-z, y, -x);			chunk.bytesRead = chunk.length;		}		/*		private function readPosTrack(chunk:Chunk3ds):void		{			max3ds.position += 10;						var numFrames:uint = max3ds.readUnsignedShort();						max3ds.position += 2;						for (var i:int = 0; i < numFrames; ++i)			{				max3ds.readUnsignedShort();				max3ds.readUnsignedInt();				var x:Number = max3ds.readFloat();				var y:Number = max3ds.readFloat();				var z:Number = max3ds.readFloat();				_meshData.transform.appendTranslation(-z, y, -x);			}						chunk.bytesRead = chunk.length;		}				private function readRotTrack(chunk:Chunk3ds):void		{			max3ds.position += 10;						var numFrames:uint = max3ds.readUnsignedShort();						max3ds.position += 2;						for (var i:int = 0; i < numFrames; ++i)			{				max3ds.readUnsignedShort();				max3ds.readUnsignedInt();				var rot:Number = max3ds.readFloat()*180/Math.PI;				var x:Number = max3ds.readFloat();				var y:Number = max3ds.readFloat();				var z:Number = max3ds.readFloat();				_meshData.transform.prependRotation(rot, new Vector3D(-z, y, -x));			}						chunk.bytesRead = chunk.length;		}				private function readScaleTrack(chunk:Chunk3ds):void		{			max3ds.position += 10;						var numFrames:uint = max3ds.readUnsignedShort();						max3ds.position += 2;						for (var i:int = 0; i < numFrames; ++i)			{				max3ds.readUnsignedShort();				max3ds.readUnsignedInt();				var x:Number = max3ds.readFloat();				var y:Number = max3ds.readFloat();				var z:Number = max3ds.readFloat();				_meshData.transform.prependScale(-z, y, -x);			}						chunk.bytesRead = chunk.length;		}		*/		private function readMaterialName(chunk:Chunk3ds):void		{			_materialData = _materialLibrary.addMaterial(readASCIIZString(max3ds));						chunk.bytesRead = chunk.length;		}				private function readColor(type:String):void		{			if (shading)        		_materialData.materialType = MaterialData.SHADING_MATERIAL;        	else            	_materialData.materialType = MaterialData.COLOR_MATERIAL;						var color:int;			var chunk:Chunk3ds = new Chunk3ds();			readChunk(chunk);			switch (chunk.id)			{				case COLOR_RGB:					color = readColorRGB(chunk);					break;				case COLOR_F:				// TODO: write implentation code					Debug.trace("COLOR_F not implemented yet");					skipChunk(chunk);					break;				default:					skipChunk(chunk);					Debug.trace("unknown ambient color format");			}						switch (type)			{				case AMBIENT:					_materialData.ambientColor = color;					break;				case DIFFUSE:					_materialData.diffuseColor = color;					break;				case SPECULAR:					_materialData.specularColor = color;					break;			}		}				private function readColorRGB(chunk:Chunk3ds):int		{			var color:int = 0;						for (var i:int = 0; i < 3; ++i)			{				var c:int = max3ds.readUnsignedByte();				color += c*Math.pow(0x100, 2-i);				chunk.bytesRead++;			}						return color;		}				private function readTextureFileName(chunk:Chunk3ds):void		{			_materialData.textureFileName = readASCIIZString(max3ds);			_materialData.materialType = MaterialData.TEXTURE_MATERIAL;						chunk.bytesRead = chunk.length;		}				private function parseMesh(chunk:Chunk3ds):void		{			while (chunk.bytesRead < chunk.length)			{				var subChunk:Chunk3ds = new Chunk3ds();				readChunk(subChunk);				switch (subChunk.id)				{					case MESH_OBJECT:						parseMesh(subChunk);						break;					case MESH_VERTICES:						readMeshVertices(subChunk);						break;					case MESH_FACES:						readMeshFaces(subChunk);						parseMesh(subChunk);						break;					case MESH_MATER:						readMeshMaterial(subChunk);						break;					case MESH_TEX_VERT:						readMeshTexVert(subChunk);						break;					/*					case MESH_XFMATRIX:						readMeshMatrix(subChunk);						break;					*/					default:						skipChunk(subChunk);				}				chunk.bytesRead += subChunk.length;			}		}				private function readMeshName(chunk:Chunk3ds):void		{			_meshDictionary[_meshData.name = readASCIIZString(max3ds)] = _meshData;			chunk.bytesRead += _meshData.name.length + 1;						Debug.trace(" + Build Mesh : " + _meshData.name);		}				private function readMeshVertices(chunk:Chunk3ds):void		{			var numVerts:int = max3ds.readUnsignedShort();			chunk.bytesRead += 2;						for (var i:int = 0; i < numVerts; ++i)			{				_meshData.geometry.vertices.push(max3ds.readFloat()*scaling, -max3ds.readFloat()*scaling, -max3ds.readFloat()*scaling);				chunk.bytesRead += 12;			}		}				private function readMeshFaces(chunk:Chunk3ds):void		{			var numFaces:int = max3ds.readUnsignedShort();			chunk.bytesRead += 2;			for (var i:int = 0; i < numFaces; ++i)			{				_geometryData.indices.push(max3ds.readUnsignedShort(), max3ds.readUnsignedShort(), max3ds.readUnsignedShort());				_geometryData.faceLengths.push(3);				max3ds.readUnsignedShort();				chunk.bytesRead += 8;								_geometryData.faces.push(new FaceData());			}		}					/**		 * Read the Mesh Material chunk		 * 		 * @param chunk		 * 		 */		private function readMeshMaterial(chunk:Chunk3ds):void		{			var meshMaterial:MeshMaterialData = new MeshMaterialData();			meshMaterial.symbol = readASCIIZString(max3ds);			chunk.bytesRead += meshMaterial.symbol.length +1;						var numFaces:int = max3ds.readUnsignedShort();			chunk.bytesRead += 2;			for (var i:int = 0; i < numFaces; ++i)			{				meshMaterial.faceList.push(max3ds.readUnsignedShort());				chunk.bytesRead += 2;			}						_meshData.geometry.materials.push(meshMaterial);		}				private function readMeshTexVert(chunk:Chunk3ds):void		{			var numUVs:int = max3ds.readUnsignedShort();			chunk.bytesRead += 2;						for (var i:int = 0; i < numUVs; ++i)			{				_meshData.geometry.uvtData.push(max3ds.readFloat(), 1-max3ds.readFloat(), 0);				chunk.bytesRead += 8;			}		}				/**		 * Reads a null-terminated ascii string out of a byte array.		 * 		 * @param data The byte array to read from.		 * @return The string read, without the null-terminating character.		 * 		 */				private function readASCIIZString(data:ByteArray):String		{			//var readLength:int = 0; // length of string to read			var l:int = data.length - data.position;			var tempByteArray:ByteArray = new ByteArray();						for (var i:int = 0; i < l; ++i)			{				var c:int = data.readByte();								if (c == 0)				{					break;				}				tempByteArray.writeByte(c);			}						var asciiz:String = "";			tempByteArray.position = 0;			for (i = 0; i < tempByteArray.length; ++i)			{				asciiz += String.fromCharCode(tempByteArray.readByte());			}			return asciiz;		}				private function buildMeshes():void		{						for each (var _meshData:MeshData in meshDataList)			{				//create Mesh object				var mesh:Mesh = new Mesh();				mesh.name = _meshData.name;				mesh.transform.matrix3D = _meshData.transform;								_geometryData = _meshData.geometry;								//set materialdata for each face				var _faceData:FaceData;				for each (var _meshMaterialData:MeshMaterialData in _geometryData.materials) {					for each (var _faceListIndex:int in _meshMaterialData.faceList) {						_faceData = _geometryData.faces[_faceListIndex] as FaceData;						_faceData.materialData = materialLibrary[_meshMaterialData.symbol];					}				}								for each(_faceData in _geometryData.faces) {					//set face materials					_materialData = _faceData.materialData;					mesh._faceMaterials.push(_materialData.material);				}								//store mesh material reference for later setting by the materialLibrary				if (_materialData)					_materialData.meshes.push(mesh);								mesh._vertices = _geometryData.vertices;				mesh._uvtData = _geometryData.uvtData;				mesh._indices = _geometryData.indices;				mesh._faceLengths = _geometryData.faceLengths;								mesh.buildFaces();								//store element material reference for later setting by the materialLibrary				for each (_face in mesh._faces)					if ((_materialData = _geometryData.faces[_face.faceIndex].materialData))						_materialData.faces.push(_face);								//center vertex points in mesh for better bounding radius calulations				if (centerMeshes) {					var i:int = mesh._vertices.length/3;					_moveVector.x = (_geometryData.maxX + _geometryData.minX)/2;					_moveVector.y = (_geometryData.maxY + _geometryData.minY)/2;					_moveVector.z = (_geometryData.maxZ + _geometryData.minZ)/2;	                while (i--) {	                	mesh._vertices[i*3] -= _moveVector.x;	                	mesh._vertices[i*3+1] -= _moveVector.y;						mesh._vertices[i*3+2] -= _moveVector.z;	                }	                mesh.transform.matrix3D.appendTranslation(_moveVector.x, _moveVector.y, _moveVector.z);				}								mesh.type = ".3ds";				(_container as ObjectContainer3D).addChild(mesh);			}		}            	/**    	 * Controls the use of shading materials when color textures are encountered. Defaults to false.    	 */        public var shading:Boolean = false;            	/**    	 * A scaling factor for all geometry in the model. Defaults to 1.    	 */        public var scaling:Number = 1;            	/**    	 * Controls the automatic centering of geometry data in the model, improving culling and the accuracy of bounding dimension values.    	 */        public var centerMeshes:Boolean;        		/**		 * Creates a new <code>Max3DS</code> object.		 */		public function Max3DS()		{			super();						_container = new ObjectContainer3D();			_container.name = "max3ds";						_container.materialLibrary = _materialLibrary;			_container.geometryLibrary = _geometryLibrary;						binary = true;		}	}}class Chunk3ds{		public var id:int;	public var length:int;	public var bytesRead:int;	 }