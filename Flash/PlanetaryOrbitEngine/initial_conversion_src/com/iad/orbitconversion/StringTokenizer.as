package com.iad.orbitconversion
{
	public class StringTokenizer
	{
		private var _currentStringPosition:uint = 0;
		private var _splitString:Array;


		public function StringTokenizer (string:String)
		{
			//"p(0.0,0.0,0.0) v(0.0,0.0,0.0) 1000.0 00ff00 15.0"
			reset ();
			_splitString = string.split (" ");
		}

		public function reset ():void
		{
			_currentStringPosition = 0;
		}

		public function nextToken ():String
		{
			var token:String = _splitString[_currentStringPosition];

			if (_currentStringPosition < (_splitString.length - 1))
				_currentStringPosition++;

			return token;
		}
	}
}
