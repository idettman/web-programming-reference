

function addEvent (obj, evType, fn, useCapture)
{
	if (obj.addEventListener)
	{
		obj.addEventListener (evType, fn, useCapture);
		return true;
	}
	else if (obj.attachEvent)
	{
		return obj.attachEvent ("on" + evType, fn);
	}
}

/**
 * addEvent(window, 'load', init);
 */
