
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

    //
    // HAMMER.JS
    //
    Hammer.plugins.fakeMultitouch(); // FOR DEV PURPOSES
	console.log('Init Hammer.js!');
    var hammer = Hammer(document.getElementById("visual-mixer-canvas"));

    hammer.on("hold touch dragstart drag dragend pinch", function(event) {
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
    }
    );
  }
  );
}
));

