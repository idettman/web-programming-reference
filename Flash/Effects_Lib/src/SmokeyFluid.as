package
{
	import flash.display.MovieClip;

	import flash.events.Event;

	import flash.events.KeyboardEvent;

	import flash.events.MouseEvent;


	public class SmokeyFluid extends MovieClip
	{
		var densityGrid:Array;
		var boxWidth:int = 5;
		var myDT:Number = 0.016667
		var mouse:Boolean = false;


		public function SmokeyFluid ()
		{
			init ();
		}


		function init ()
		{
			///Make density grid
			densityGrid = [];

			for (var i:int = 0; i < stage.stageWidth / boxWidth; i++)
			{

				var arr:Array = [];

				for (var j:int = 0; j < stage.stageHeight / boxWidth; j++)
				{

					var b:MovieClip = new MovieClip ();

					b.graphics.beginFill (0x990000, 1);

					b.graphics.drawRect (0, 0, boxWidth, boxWidth);

					b.graphics.endFill ();

					addChild (b);
					b.x = i * boxWidth;

					b.y = j * boxWidth;

					b.alpha = 0;

					arr.push (b);

					b.mouseEnabled = false;

				}

				densityGrid.push (arr);

			}

			////////////

			addEventListener (Event.ENTER_FRAME, Update);

			stage.addEventListener (KeyboardEvent.KEY_DOWN, KeyDown);

			stage.addEventListener (MouseEvent.MOUSE_DOWN, mouseDown);

			stage.addEventListener (MouseEvent.MOUSE_UP, mouseUp);

		}


		function Update (event:Event)
		{

			Step (myDT);

		}


		function KeyDown (event:KeyboardEvent)
		{

		}


		function mouseDown (event:MouseEvent)
		{

			mouse = true;

		}


		function mouseUp (event:MouseEvent)
		{

			mouse = false;

		}


		function Step (dt)
		{

			var d:Array = densityGrid;

			for (var i:int = 1; i < densityGrid.length - 1; i++)
			{

				for (var j:int = 1; j < densityGrid[i].length - 1; j++)
				{

					if (mouse == true)
					{

						if (Math.abs (d[i][j].x - mouseX) < boxWidth && Math.abs (d[i][j].y - mouseY) < boxWidth)
						{

							d[i][j].alpha = 4;

						}

					}

					d[i][j].alpha += 10 * dt * (d[i - 1][j].alpha + d[i + 1][j].alpha + 2 * d[i][j + 1].alpha - 4 * d[i][j].alpha );

				}

			}

		}

	}

}