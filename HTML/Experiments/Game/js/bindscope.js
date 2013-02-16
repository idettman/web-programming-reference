
// Allows context to be set for event handler functions
Function.prototype.bindContext = function ()
{
	// when adding functions using prototype, "this" is the
	// object which the new function was called on
	var callingFunction = this;

	// pass the desired scope object as the first arg
	var scope = arguments[0];

	// create a new arguments array with the first arg removed
	var otherArgs = [];
	for (var i = 1; i < arguments.length; i++)
	{
		otherArgs.push (arguments[i]);
	}

	// return a function remembering to include the event
	return function (e)
	{
		// Add the event object to the arguments array
		otherArgs.push (e || window.event);
		// Array is in the wrong order so flip it
		otherArgs.reverse ();

		// Now use apply to set scope and arguments
		callingFunction.apply (scope, otherArgs);
	}
}
