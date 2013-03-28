package {
	import flash.events.MouseEvent;
	import flash.utils.Proxy;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.Sprite;
	public class PolygonEdgeRemove extends Sprite {

		/* WIP */

		public var cw:Number =96;
		public var ch:Number = 96;
		public var mwidth:int = 4;
		public var mheight:int = 4;
		public var vecPoint:Vector.<Point>;
		public var vecIndex:Vector.<uint>;

		public var vecTri:Vector.<wTri>;

		public var noMerge:Vector.<Point>;

		public function PolygonEdgeRemove() {

			var i:int;
			var k:int;
			var p:Point;

			vecPoint = new Vector.<Point>;
			vecIndex = new Vector.<uint>;
			vecTri = new Vector.<wTri>;

			noMerge = new Vector.<Point>;

			graphics.clear();
			graphics.lineStyle(2,0);

			for (i = 0; i <mheight; i++)
			{
				for (k = 0; k < mwidth; k++)
				{
					p = new Point(16+k*cw, 16+i*ch);
					vecPoint.push(p);
					graphics.drawCircle(p.x, p.y, 4);

				}//nextk
			}//nexti

			//corners
			// p = vecPoint[0];
			//  p = vecPoint[mwidth-1];
			//  p = vecPoint[(mheight*mwidth)-mwidth];
			//   p = vecPoint[(mheight*mwidth)-1];

			noMerge.push(vecPoint[0]);
			noMerge.push(vecPoint[mwidth-1]);
			noMerge.push(vecPoint[(mheight*mwidth)-mwidth]);
			noMerge.push(vecPoint[(mheight*mwidth)-1] );
			// graphics.drawCircle(p.x,p.y, 8);


			var ei:int;
			var ek:int;
			var yt:int;
			var w:wTri;

			ek = mwidth - 1;
			ei = mheight - 1;

			//        i = mheight-2;
			//       yt = i * mwidth;
			for (i = 0; i < ei; i++)
			{
				yt = i *mwidth;


				for (k = 0; k < ek; k++)
				{
					vecIndex.push(0+k+yt);
					vecIndex.push(1+k+yt);
					vecIndex.push(0+k+mwidth+yt);

					w = new wTri();
					w.v1 = vecPoint[0+k+yt];
					w.v2 = vecPoint[1+k+yt];
					w.v3 = vecPoint[0+k+mwidth+yt];

					vecTri.push(w);
					//  vecTri.push( new wTri( vecPoint[0+k+yt], vecPoint[1+k+yt], vecPoint[0+k+mwidth+yt] ) );


					vecIndex.push(1+k+yt);
					vecIndex.push(1+k+mwidth+yt);
					vecIndex.push(0+k+mwidth+yt);

					// vecTri.push( new wTri( vecPoint[1+k+yt], vecPoint[1+k+mwidth+yt], vecPoint[0+k+mwidth+yt] ) );

					w = new wTri();
					w.v1 = vecPoint[1+k+yt];
					w.v2 = vecPoint[1+k+mwidth+yt];
					w.v3 = vecPoint[0+k+mwidth+yt];
					vecTri.push(w);

				}//nextk

			}//nexti




			stage.addEventListener(MouseEvent.CLICK, mclick);
			stage.addEventListener(Event.ENTER_FRAME, onEnter);
		}//ctor

		public var mc:int = 0;

		public function mclick(e:MouseEvent):void
		{
			// var w:wTri;
			//  w = vecTri[2];
			// collapse(w.v1, w.v2);
			/*
			 switch (mc)
			 {
			 case 0:
			 collapse(vecPoint[1+mwidth], vecPoint[2] );
			 break;

			 case 1:
			 collapse(vecPoint[2+mwidth], vecPoint[2] );
			 break;
			 }
			 */

			mc+=1;
		}//mclick


		public function canMerge(a:Point):Boolean
		{
			var i:int;
			var num:int;
			var p:Point;

			num = noMerge.length;

			for (i = 0; i < num; i++)
			{
				p = noMerge[i];
				if (a == p) { return false;}
			}//nexti
			return true;
		}//canmerge


		public var wt:int = 0;
		public var wk:int = 0;

		public var c1:Point;
		public var c2:Point;

		public function getDist(dx:Number, dy:Number):Number
		{
			return (dx*dx + dy*dy);
		}

		public function onEnter(e:Event):void
		{

			var num:int;
			var i:int;
			var p:Point;
			var w:wTri;
			var k:int;





			//if (mc >= 1) wt += 1;
			if (mc >= 1 && c1 != null) { collapse(c1,c2); wt =0; c1 =null;c2=null; mc = 0;}
			if (mc >=1 && c1 == null)
			{
				mc = 0;
				//  wt = 0;

				if (vecTri.length <= 2) { return;}

				wk = Math.random() * vecTri.length;

				if (vecTri[wk].dead)
				{
					num = vecTri.length;
					for (wk = 0; wk < num; wk++)
					{
						if (vecTri[wk].dead == false) { break;}
					}
					if (wk >= num) { mc =0; return; }
				}
				//wk += 1;
				//if (wk >= vecTri.length) { wk = 0;}

				w = vecTri[wk];
				if (w.dead) { mc = 0; return;}
				// if (w != null)
				// if (w.v1 != w.v2)
				// if (canMerge(w.v1) && canMerge(w.v2))
				{
					// collapse(w.v1, w.v2);

					var da:Number;
					var db:Number;
					var dc:Number;

					da = getDist(w.v1.x-w.v2.x, w.v1.y-w.v2.y);
					db = getDist(w.v1.x-w.v3.x, w.v1.y-w.v3.y);
					dc = getDist(w.v3.x-w.v2.x, w.v3.y-w.v2.y);


					var d:Number;

					d = Math.min(da, db);
					d = Math.min(d, dc);

					if (d == da) { c1 = w.v1; c2 = w.v2; }
					else if (d == db) { c1 = w.v1; c2 = w.v3; }
					else if (d == dc) { c1 = w.v3; c2 = w.v2; }




					//c1 = w.v1;
					//c2 = w.v2;

					//wt = 0;
				}
				// else
				// {wt =10;}

			}


			graphics.clear();

			graphics.lineStyle(1,0);




			num = vecTri.length;

			for (i = 0; i < num; i++)
			{
				w = vecTri[i];
				if (w == null) { continue;}
				if (w.dead) { continue; }

				graphics.beginFill(w.col, 0.5);

				graphics.moveTo(w.v1.x, w.v1.y);
				graphics.lineTo(w.v2.x, w.v2.y);
				graphics.lineTo(w.v3.x, w.v3.y);
				graphics.lineTo(w.v1.x, w.v1.y);

				graphics.endFill();

			}//nexti


			if (c1 != null)
			{
				graphics.lineStyle(10,0);
				graphics.moveTo(c1.x, c1.y);
				graphics.lineTo(c2.x, c2.y);

				graphics.lineStyle(5,0);
				graphics.drawCircle(c1.x, c1.y, 16);
				graphics.drawCircle(c2.x, c2.y, 8);
			}

		}//onenter


		public function collapse(a:Point, b:Point):void
		{
			if (a == null || b == null) { return; }
			if ( a== b) { return;}

			var i:int;
			var num:int;
			var w:wTri;

			num = vecTri.length;

			for (i = 0; i < num; i++)
			{
				w = vecTri[i];

				if (w == null) { continue; }
				if (w.dead) { continue; }

				if (w.v1 != a && w.v2 != a && w.v3 != a) {continue;}

				if (w.v1 == b || w.v2 == b || w.v3 == b) { w.dead =true;continue;}

				if (w.v1 == a) { w.v1 = b;}
				if (w.v2 == a) { w.v2 = b;}
				if (w.v3 == a) { w.v3 = b;}

			}//nexti

		}//collapse


	}//classend
}

import flash.geom.Point;

internal class wTri
{
	public var v1:Point;
	public var v2:Point;
	public var v3:Point;

	public var col:uint = 0;

	public var dead:Boolean = false;

	public function wTri(a:Point=null, b:Point=null, c:Point=null)
	{
		v1 =a; v2 = b; v3 = c;

		col = Math.random() * 0xFFffFFff;
	}//ctor

}//classend

