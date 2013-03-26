package utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;


	public class DisplayListUtils
	{
		public static function stopAndRemoveChildren (container:DisplayObjectContainer/*, levelIndent:uint = 0*/):void
		{
			// trace ("\n", container.name, " > stop and remove children : total=", container.numChildren);
			if (container is MovieClip)	MovieClip (container).stop ();

			for (var child:DisplayObject, i:int = container.numChildren-1; i >= 0; i--)
			{
				child = container.getChildAt (i);

				if (child is DisplayObjectContainer)
				{
					if (child is MovieClip) MovieClip (child).stop ();

					if (DisplayObjectContainer(child).numChildren)
						stopAndRemoveChildren (DisplayObjectContainer (child)/*, levelIndent+1*/);
				}

				/*var indentSpaces:String = "";
				 for (var j:int = 0; j < levelIndent; j++) indentSpaces+= "  ";
				 if (child) trace (container.name, indentSpaces, " -> remove child:", child.name);
				 else trace (container.name, indentSpaces, "  -> remove child : NULL");
				 */

				child = null;
				container.removeChildAt (i);
			}
		}


		public static function stopChildMovieClips(container:DisplayObjectContainer):void
		{
			if (container is MovieClip) MovieClip (container).stop ();

			for (var child:DisplayObject, i:int = container.numChildren-1; i >= 0; i--)
			{
				child = container.getChildAt (i);

				if (child is DisplayObjectContainer)
				{
					if (child is MovieClip)
					{
						MovieClip (child).stop ();
					}

					stopChildMovieClips (DisplayObjectContainer (child));
				}
			}
		}

		public static function playChildMovieClips(container:DisplayObjectContainer):void
		{
			if (container is MovieClip) MovieClip (container).play ();

			for (var child:DisplayObject, i:int = container.numChildren-1; i >= 0; i--)
			{
				child = container.getChildAt (i);

				if (child is DisplayObjectContainer)
				{
					if (child is MovieClip)
					{
						MovieClip (child).play ();
					}

					playChildMovieClips (DisplayObjectContainer (child));
				}
			}
		}


		public static function calculateDisplayListDepth (displayObj:DisplayObject):uint
		{
			return checkForParent (displayObj);
		}


		private static function checkForParent(displayObj:DisplayObject, levelDepth:uint = 0):uint
		{
			if (displayObj.parent)
			{
				levelDepth++;
				return checkForParent (displayObj.parent, levelDepth);
			}
			else
			{
				return levelDepth;
			}
		}
	}



}
