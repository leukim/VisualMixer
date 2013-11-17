$(document).ready(function() {
	initHammer();
});

//
// HAMMER.JS
//
function initHammer() {
    Hammer.plugins.fakeMultitouch(); // FOR DEV PURPOSES
    var hammer = Hammer(document.getElementById("visual-mixer-canvas"));

    hammer.on("hold touch release dragstart drag dragend pinch", function(event) {
	  var PInstance = Processing.getInstanceById("visual-mixer-canvas");
      event.gesture.preventDefault();
      var x = event.gesture.touches[0].pageX; 
      var y = event.gesture.touches[0].pageY;

      switch (event.type) {
      case "hold":
        PInstance.handleHold(x,y);
        break;
      case "touch":
        PInstance.handleTouch(x,y);
		//playNote(x);
        break;
	  case "release":
        PInstance.handleRelease(x,y);
		stopNote();
        break;
      case "dragstart":
        PInstance.startDrag();
        break;
      case "drag":
        PInstance.processDrag(x, y);
        break;
      case "dragend":
        PInstance.endDrag(x, y);
        break;
      case "pinch":
        PInstance.handlePinch(event.gesture.center.pageX, event.gesture.center.pageY, event.gesture.scale, event);
        console.log(event);
        break;
      }
    });
}

// AUDIO
var actx = new webkitAudioContext();
var OSC1 = actx.createOscillator();
OSC1.frequency.value = 0;

function playNote(value) {
	OSC1.connect(actx.destination);
	OSC1.frequency.value = value;
	OSC1.start(1);
}

function stopNote() {
	console.log("STOP");
	OSC1.disconnect();
}

/*
(function(visualmixer) {
  // The global jQuery object is passed as a parameter
  visualmixer(window.jQuery, window, document);
}
(function($, window, document) {
  // The $ is now locally scoped 

  // Listen for the jQuery ready event on the document
  $(function() {
    // The DOM is ready!
    console.log('The DOM is ready!');

	// CANVAS
	var mixerCanvas = document.getElementById("visual-mixer-canvas");
	
    //
    // HAMMER.JS
    //
    Hammer.plugins.fakeMultitouch(); // FOR DEV PURPOSES
    var hammer = Hammer(mixerCanvas);

    hammer.on("hold touch release dragstart drag dragend pinch", function(event) {
	  var PInstance = Processing.getInstanceById("visual-mixer-canvas");
      event.gesture.preventDefault();
      var x = event.gesture.touches[0].pageX; 
      var y = event.gesture.touches[0].pageY;

      switch (event.type) {
      case "hold":
        PInstance.handleHold(x,y);
        break;
      case "touch":
        PInstance.handleTouch(x,y);
		//playNote(x);
        break;
	  case "release":
        PInstance.handleRelease(x,y);
		stopNote();
        break;
      case "dragstart":
        PInstance.startDrag();
        break;
      case "drag":
        PInstance.processDrag(x, y);
        break;
      case "dragend":
        PInstance.endDrag(x, y);
        break;
      case "pinch":
        PInstance.handlePinch(event.gesture.center.pageX, event.gesture.center.pageY, event.gesture.scale, event);
        console.log(event);
        break;
      }
    });
	
	// AUDIO
	var actx = new webkitAudioContext();
	var OSC1 = actx.createOscillator();
	OSC1.frequency.value = 0;

	var mixerCanvas = mixerCanvas.getContext("2d");

	function playNote(value) {
		OSC1.connect(actx.destination);
		OSC1.frequency.value = value;
		OSC1.start(1);
	}

	function stopNote() {
		console.log("STOP");
		OSC1.disconnect();
	}
	
	
  }
  );
}
));
*/
