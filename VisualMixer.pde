// Variables
PVector lastTouch;

// The statements in the setup() function 
// execute once when the program begins
void setup() {
  size(640, 360);  // Size must be the first statement
  stroke(255);     // Set line drawing color to white
  frameRate(30);
  
  lastTouch = new PVector(0, 0);
}

// The statements in draw() are executed until the 
// program is stopped. Each statement is executed in 
// sequence and after the last line is read, the first 
// line is executed again.
void draw() { 
  background(0);   // Set the background to black
  
  // draw ellipse in the last touch position.
  ellipse(lastTouch.x, lastTouch.y, 12, 12);
}

// JS handlers
void touched(int touchX, int touchY) {
   // handle touch events!
   println('handle touch('+touchX + ', '+touchY+')');
   lastTouch.set(touchX, touchY);
};
