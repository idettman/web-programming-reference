// Request Animation Frame Polyfill

(function() {
	var lastTime = 0;
	var vendors = ['ms', 'moz', 'webkit', 'o'];
	for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
		window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
		window.cancelAnimationFrame =
			window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
	}

	if (!window.requestAnimationFrame)
		window.requestAnimationFrame = function(callback, element) {
			var currTime = new Date().getTime();
			var timeToCall = Math.max(0, 16 - (currTime - lastTime));
			var id = window.setTimeout(function() { callback(currTime + timeToCall); },
				timeToCall);
			lastTime = currTime + timeToCall;
			return id;
		};

	if (!window.cancelAnimationFrame)
		window.cancelAnimationFrame = function(id) {
			clearTimeout(id);
		};
}());


// Example Code from Mr Doob
/*
 // example code from mr doob : http://mrdoob.com/lab/javascript/requestanimationframe/

 var canvas, context, toggle;

 init();
 animate();

 function init() {

 canvas = document.createElement( 'canvas' );
 canvas.width = 512;
 canvas.height = 512;

 context = canvas.getContext( '2d' );

 document.body.appendChild( canvas );

 }

 function animate() {
 requestAnimFrame( animate );
 draw();

 }

 function draw() {

 var time = new Date().getTime() * 0.002;
 var x = Math.sin( time ) * 192 + 256;
 var y = Math.cos( time * 0.9 ) * 192 + 256;
 toggle = !toggle;

 context.fillStyle = toggle ? 'rgb(200,200,20)' :  'rgb(20,20,200)';
 context.beginPath();
 context.arc( x, y, 10, 0, Math.PI * 2, true );
 context.closePath();
 context.fill();

 }
 */
