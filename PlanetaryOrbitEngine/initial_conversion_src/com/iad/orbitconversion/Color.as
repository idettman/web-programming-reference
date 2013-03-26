package com.iad.orbitconversion
{
	public class Color
	{
		public static const black:Color = new Color (0x000000);
		public static const white:Color = new Color (0xFFFFFF);


		public var value:uint = 0x000000;

		public function Color (color:uint)
		{
			value = color;
		}
	}
}
