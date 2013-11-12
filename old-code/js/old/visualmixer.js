// IIFE - Immediately Invoked Function Expression
(function(yourcode) {
    // The global jQuery object is passed as a parameter
	yourcode(window.jQuery, window, document);

	}(function($, window, document) {
		// The $ is now locally scoped 

		// Listen for the jQuery ready event on the document
		$(function() {
			// The DOM is ready!
			console.log('The DOM is ready!');
		
			// Use this to access processing related functions
			/*var processingInstance;
			function initProcessingCanvas() {
				$('#canvas-holder').append('<canvas id="visual-mixer-canvas" data-processing-sources="VisualMixer.pde"></canvas>');
				console.log('Processing canvas created' + $('#visual-mixer-canvas'));
				
				processingInstance = Processing.getInstanceById('visual-mixer-canvas');
				console.log('Processing instance saved: ' + processingInstance);
			}
			initProcessingCanvas();*/
			
			
			// init multitouch environment
			var multitouch = $("#visual-mixer-canvas").hammer();
		
			multitouch.on("touch", function(event) {
				console.log('Canvas touched.');
				console.log(event);
				var processingInstance = Processing.getInstanceById('visual-mixer-canvas');
				processingInstance.touched(event.gesture.center.pageX, event.gesture.center.pageY);
			});
			
			
		
		});
		// The rest of the code goes here!
	
}));