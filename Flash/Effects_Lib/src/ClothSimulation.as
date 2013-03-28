package {
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.display.Sprite;


	[SWF(backgroundColor = "0xff0000", frameRate = "30")]
	public class ClothSimulation extends Sprite {
		public const GRID_SIZE:int = 20;
		public var parts : Object;
		public var mouseParts : Array = new Array();
		public static var tf:TextField;
		public function ClothSimulation()
		{
			parts = new Object();
			tf = new TextField()
			tf.textColor = 0xffffff;
			//addChild(tf);
			tf.width = stage.stageWidth;
			tf.height = stage.stageHeight;
			tf.wordWrap = true;
			tf.text = "start";
			for(var x:int = 0 ; x<GRID_SIZE ; x++)
			{

				for(var y:int = 0 ; y<GRID_SIZE ; y++)
				{


					parts[x.toString()+"X"+y.toString()] = new Particle();
					parts[x.toString()+"X"+y.toString()].x = Math.random()*stage.stageWidth;
					parts[x.toString()+"X"+y.toString()].y = Math.random()*stage.stageHeight;

					parts[x.toString()+"X"+y.toString()].vx = 5*Math.random();
					parts[x.toString()+"X"+y.toString()].vy = 5*Math.random();

					parts[x.toString()+"X"+y.toString()].fx = 0
					parts[x.toString()+"X"+y.toString()].fy=0

				}
			}

			addEventListener(Event.ENTER_FRAME,frameHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler)
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler)
		}

		private function mouseUpHandler(e:MouseEvent) : void
		{

			mouseParts = new Array();
		}

		private function mouseDownHandler(e:MouseEvent) : void
		{
			tf.text="down";
			for(var x:int = 0 ; x<GRID_SIZE ; x++)
			{
				for(var y:int = 0 ; y<GRID_SIZE ; y++)
				{
					var part:Particle = parts[x.toString()+"X"+y.toString()];
					var dx:Number = part.x-this.mouseX
					var dy:Number = part.y-this.mouseY
					var dist:Number = Math.sqrt(dx*dx+dy*dy);
					//  tf.appendText("\n"+dist.toString())
					if(dist<30)
						mouseParts.push(part);
				}
			}

		}

		private function frameHandler(e:Event) :void
		{

			for(var x:int = 0 ; x<GRID_SIZE ; x++)
			{
				for(var y:int = 0 ; y<GRID_SIZE ; y++)
				{
					var part:Particle = parts[x.toString()+"X"+y.toString()];
					var part2:Particle
					var dx:Number
					var dy:Number
					var dist:Number
					var ang:Number
					if(x==0 || x==GRID_SIZE-1 || y==0 || y==GRID_SIZE-1)
					{

						dx = part.x-1.8*(x-GRID_SIZE/2)*(stage.stageWidth/GRID_SIZE)-stage.stageWidth/2
						dy = part.y-1.8*(y-GRID_SIZE/2)*(stage.stageHeight/GRID_SIZE)+400
						dist = Math.sqrt(dx*dx+dy*dy);
						ang = Math.atan2(dy,dx);
						part.fx -=Math.min(dist*0.05,300)*Math.cos(ang);
						part.fy -=Math.min(dist*0.05,300)*Math.sin(ang);
						//                   tf.text = (" "+parts[x.toString()+"X"+y.toString()].fy.toString())
					}
					if(x>0)
					{
						part2 = parts[(x-1).toString()+"X"+y.toString()];
						dx = part.x-part2.x
						dy = part.y-part2.y
						dist = Math.sqrt(dx*dx+dy*dy);
						ang = Math.atan2(dy,dx);
						part.fx -=Math.min(dist*.5,200)*Math.cos(ang);
						part.fy -=Math.min(dist*.5,200)*Math.sin(ang);
						part2.fx +=Math.min(dist*.5,200)*Math.cos(ang);
						part2.fy +=Math.min(dist*.5,200)*Math.sin(ang);
					}
					if(y>0)

					{
						part2 = parts[x.toString()+"X"+(y-1).toString()];
						dx = part.x-part2.x
						dy = part.y-part2.y
						dist = Math.sqrt(dx*dx+dy*dy);
						ang = Math.atan2(dy,dx);
						part.fx -=Math.min(dist*0.5,200)*Math.cos(ang);
						part.fy -=Math.min(dist*0.5,200)*Math.sin(ang);
						part2.fx +=Math.min(dist*0.5,200)*Math.cos(ang);
						part2.fy +=Math.min(dist*0.5,200)*Math.sin(ang);
					}
					part.fy+=4.5

				}
			}
			for each(var pa:Particle in mouseParts)
			{
				dx = pa.x-mouseX
				dy = pa.y-mouseY
				dist = Math.sqrt(dx*dx+dy*dy);
				ang = Math.atan2(dy,dx);
				pa.fx -=Math.min(dist*0.75,50)*Math.cos(ang);
				pa.fy -=Math.min(dist*0.75,50)*Math.sin(ang);
			}

			for each(var p:Particle in parts)
			{
				p.update();
			}

			render();
		}

		private function render():void
		{

			graphics.clear()
			graphics.beginFill(0)
			graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight)
			graphics.endFill();
			graphics.lineStyle(1,0x00ff00)
			for(var x:int = 0 ; x<GRID_SIZE-1 ; x++)
			{
				for(var y:int = 0 ; y<GRID_SIZE-1 ; y++)
				{
					var part:Particle = parts[x.toString()+"X"+y.toString()];
					try{
						/*
						 graphics.drawRect(part.x,part.y,1,1)

						 /*/
						graphics.moveTo(part.x,part.y);
						graphics.lineTo(parts[(x+1).toString()+"X"+y.toString()].x,parts[(x+1).toString()+"X"+y.toString()].y)
						graphics.moveTo(part.x,part.y);
						graphics.lineTo(parts[x.toString()+"X"+(y+1).toString()].x,parts[x.toString()+"X"+(y+1).toString()].y)
						//*/
					}catch(e:Error)
					{

					}

				}

			}
			addChild(tf);
		}


	}
}

class Particle
{
	public var x:Number
	public var y:Number
	public var vx:Number
	public var vy:Number
	public var fx:Number
	public var fy:Number

	public function update():void
	{

		vx+=fx;
		vy+=fy;
		vx*=0.6;
		vy*=0.6;
		x+=vx;
		y+=vy;
		//            FlashTest.tf.appendText(" - "+ fx.toString()+" "+fy.toString())
		fx=0;
		fy=0;

	}


}

