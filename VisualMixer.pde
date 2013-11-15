int SHAPE_CIRCLE = 0;
int SHAPE_SQUARE = 1;
int SHAPE_TRIANGLE = 2;
int SHAPE_SALTIRE = 3;
int SHAPE_RSALTIRE = 4;

int FULL_COLOR = 255;
int HALF_COLOR = 127;

var objects = new Array();
var settings = new Object();

int next = 0;

int add_shape;
int edit_shape;

void setup() {
    size(window.innerWidth, window.innerHeight);
    settings.object_radius = 20;
	settings.corner_radius = 80;
    settings.width = window.innerWidth;
    settings.height = window.innerHeight;
    settings.drag_distance = 40;
    settings.moving = -1;
    settings.editing = -1;
    settings.add_menu = 0;
    settings.edit_menu = 0;
    settings.threshold = 40;
    
    settings.add_menuX;
    settings.add_menuY;
}


/*
 * DRAW FUNCTIONS
 */

void draw() {
    background(255,255,255);
    
	drawCorners();
	
    for (int i = 0; i < objects.length; ++i) {
        drawItem(i);
    }
}

void drawCorners() {
	int r = settings.corner_radius;
	fill(255,102,0);
    stroke(255,51,0);
    ellipse(0, 0, 2*r, 2*r);
	ellipse(settings.width, settings.height, 2*r, 2*r);
	ellipse(settings.width, 0, 2*r, 2*r);
	ellipse(0, settings.height, 2*r, 2*r);
}

boolean isOnCornerArea(int x, int y) {
	if (dist(x,y,0.0,0.0) <= settings.corner_radius || dist(x,y,settings.width,settings.height) <= settings.corner_radius || dist(x,y,settings.width,0.0) <= settings.corner_radius || dist(x,y,0.0,settings.height) <= settings.corner_radius) {
			return true;
	}
	return false;
}

void drawEditMenu(int id) {
    Object o = objects[id];
    
    stroke(0,0,0);
    strokeWeight(1);
    
    fill(0,0,0,63);
    ellipse(o.x-o.radius-50,o.y,60,60); // LEFT ITEM
    drawSaltire(o.x-o.radius-50,o.y,20,10,1);
    
    fill(255,0,0,63);
    ellipse(o.x+o.radius+50,o.y,60,60); // RIGHT ITEM
    drawRSaltire(o.x+o.radius+50,o.y,20,10,1);
    
    if (!o.active) fill(0,153,0,63);
    else fill(0,0,0,63);
    ellipse(o.x,o.y-o.radius-50,60,60); // TOP ITEM
    if (!o.active) drawPlay(o.x, o.y-o.radius-50, 20);
    else drawPause(o.x, o.y-o.radius-50, 20);
    
    fill(255,255,0,63);
    ellipse(o.x,o.y+o.radius+50,60,60); // BOTTOM ITEM
    stroke(0,0,0);
    int r = 10;
    int px = o.x-r*3*sqrt(2)/4;
    int py = o.y+o.radius+50-r*3*sqrt(2)/4;
    fill(255,0,0);
    ellipse(px, py, 2*r, 2*r);
    px = o.x+r*3*sqrt(2)/4;
    py = o.y+o.radius+50-r*3*sqrt(2)/4;
    fill(0,255,0);
    triangle(px,py-r,px+r*sqrt(2)/2,py+r*sqrt(2)/2,px-r*sqrt(2)/2,py+r*sqrt(2)/2);
    px = o.x;
    py = o.y+o.radius+50+r;
    fill(0,0,255);
    rect(px-(r*sqrt(2)/2), py-(r*sqrt(2)/2),r*sqrt(2),r*sqrt(2));
}

void drawShapesMenu(int id) {
    Object o = objects[id];
    
    stroke(0,0,0);
    strokeWeight(1);
    
    fill(255,0,0,63);
    ellipse(o.x-o.radius-50,o.y,60,60); // LEFT ITEM
    
    int r = 20;
    int px = o.x-o.radius-50;
    int py = o.y;
    ellipse(px, py, 2*r, 2*r); // CIRCLE
    
    fill(0,255,0,63);
    ellipse(o.x+o.radius+50,o.y,60,60); // RIGHT ITEM
    px = o.x+o.radius+50;
    py = o.y;
    triangle(px,py-r,px+r*sqrt(2)/2,py+r*sqrt(2)/2,px-r*sqrt(2)/2,py+r*sqrt(2)/2);
    
    fill(0,0,255,63);
    ellipse(o.x,o.y-o.radius-50,60,60); // TOP ITEM
    px = o.x;
    py = o.y-o.radius-50;
    rect(px-(r*sqrt(2)/2), py-(r*sqrt(2)/2),r*sqrt(2),r*sqrt(2));
    
    
    fill(0,0,0,63);
    ellipse(o.x,o.y+o.radius+50,60,60); // BOTTOM ITEM
    drawSaltire(o.x,o.y+o.radius+50,20,10,1);
}

void drawItem(int id) {
    Object i = objects[id];
    
    int w = settings.height/2;
    int f = (frameCount - i.start_frame) % w;
    int f2 = (frameCount - i.start_frame) / 100;
    
    if (i.moving) {
        if (i.active) fill(i.r,i.g,i.b,32);
        else fill(127,127,127,32);
        noStroke();
        
        ellipse(i.x, i.y, 25+w, 25+w);
        
        if (i.active) stroke(i.r,i.g,i.b);
        else stroke(127,127,127);
        noFill();
        for (int j = 0; j < 32; j+=2) {
            float a = (TWO_PI*j/32 + f2) % TWO_PI;
            float b = (TWO_PI*(j+1)/32 +f2) % TWO_PI;
            if (a < b) arc(i.x, i.y, 25+w, 25+w,a,b);
            else {
                arc(i.x, i.y, 25+w, 25+w,a,TWO_PI);
                arc(i.x, i.y, 25+w, 25+w,0,b);
            }
        }
    } else if (i.active) {
        fill(i.r,i.g,i.b,5);
        noStroke();
        for (int j = 0; j <= 50; ++j) {
            ellipse(i.x, i.y, i.radius+j*w/50, i.radius+j*w/50);
        }
        
        strokeWeight(3);
        noFill();
        for (int j = 0; j <= 5; ++j) {
            int r = 2*i.radius+((f + j*w/5)%w);
            stroke(i.r,i.g,i.b,255*(1-(r/(w+i.radius))));
            ellipse(i.x, i.y, r, r);
        }
    }
    
    if (i.active) fill(i.r,i.g,i.b, FULL_COLOR);
    else fill(127,127,127);
    stroke(0,0,0);
    switch (i.shape) {
        case SHAPE_CIRCLE:
            ellipse(i.x, i.y, 2*i.radius, 2*i.radius);
            break;
        case SHAPE_TRIANGLE:
            triangle(i.x,i.y-i.radius,i.x+i.radius*sqrt(2)/2,i.y+i.radius*sqrt(2)/2,i.x-i.radius*sqrt(2)/2,i.y+i.radius*sqrt(2)/2);
            break;
        case SHAPE_SQUARE:
            rect(i.x-(i.radius*sqrt(2)/2), i.y-(i.radius*sqrt(2)/2),i.radius*sqrt(2),i.radius*sqrt(2));
            break;
    }
    
    if (i.menu_shapes) drawShapesMenu(id);
    else if (i.menu) drawEditMenu(id);
}

void inner_drawSaltire(int x, int y, int r, int k, int cr, int cg, int cb) {
    fill(cr, cg, cb);
    stroke(0,0,0);
    int t = ((r*sqrt(2))-k)/2;
    int ax = x - (k/sqrt(2));
    int bx = x + (k/sqrt(2));
    int cy = y + (k/sqrt(2));
    int dy = y - (k/sqrt(2));
    beginShape();
    vertex(ax,y);
    vertex(ax-t,y+t);
    vertex(x-t,cy+t);
    vertex(x,cy);
    vertex(x+t,cy+t);
    vertex(bx+t,y+t);
    vertex(bx,y);
    vertex(bx+t,y-t);
    vertex(x+t,dy-t);
    vertex(x,dy);
    vertex(x-t,dy-t);
    vertex(ax-t,y-t);
    vertex(ax,y);
    endShape();
}

void drawSaltire(int x, int y, int r, int k) {
    inner_drawSaltire(x, y, r, k, 0, 0, 0);
}

void drawRSaltire(int x, int y, int r, int k) {
    inner_drawSaltire(x, y, r, k, 255, 0, 0);
}

void drawPlay(int x, int y, int r) {
    fill(0,153,0);
    stroke(0,0,0);
    triangle(x+r,y,x-r*sqrt(2)/2,y-r*sqrt(2)/2,x-r*sqrt(2)/2,y+r*sqrt(2)/2);
}

void drawPause(int x, int y, int r) {
    fill(0,0,0,127);
    stroke(0,0,0);
    rect(x-r*sqrt(2)/2, y-r*sqrt(2)/2, r*sqrt(2)/3, r*sqrt(2));
    rect(x+r*sqrt(2)/6, y-r*sqrt(2)/2, r*sqrt(2)/3, r*sqrt(2));
}

/*
 * HELPERS
 */

// TODO This will be deleted! TODO
int getCloserAddMenu() {
    int w = settings.height/8;
    
    int ret = -1;
    float distC = dist(settings.add_menuX, settings.add_menuY+w, mouseX, mouseY);
    float distT = dist(settings.add_menuX, settings.add_menuY-w, mouseX, mouseY);
    float distS = dist(settings.add_menuX+w, settings.add_menuY, mouseX, mouseY);
    float distST = dist(settings.add_menuX-w, settings.add_menuY, mouseX, mouseY);
    if (distC == distT && distC == distS) return -1;
    else {
        float currentDist = distC;
        ret = SHAPE_CIRCLE;
        if (currentDist > distT) {
            currentDist = distT;
            ret = SHAPE_TRIANGLE;
        }
        if (currentDist > distS) {
            currentDist = distS;
            ret = SHAPE_SQUARE;
        }
        if (currentDist > distST) {
            currentDist = distST;
            ret = SHAPE_SALTIRE;
        }
    }
    return ret;
}

/*
 * STATE MODIFIERS
 */

Object createShape(int shape, int x, int y) {
    var o = new Object();
    o.x = x;
    o.y = y;
    o.start_frame = frameCount;
    o.shape = shape;
    o.active = false;
    o.radius = settings.object_radius;
    o.menu = false;
    o.menu_shapes = false;
    switch(shape) {
        case SHAPE_CIRCLE:
            o.r = 255;
            o.g = 0;
            o.b = 0;
            break;
        case SHAPE_TRIANGLE:
            o.r = 0;
            o.g = 255;
            o.b = 0;
            break;
        case SHAPE_SQUARE:
            o.r = 0;
            o.g = 0;
            o.b = 255;
            break;
    }
    objects.push(o);
	return o;
}

//
// TAP
//

int open_menu(int x, int y) {
    for (int i = 0; i < objects.length; ++i) {
        Object o = objects[i];
        if (!o.menu_shapes && dist(x,y,o.x,o.y) <= o.radius) {
            objects[i].menu = true;
            return i;
        }
    }
    return -1;
}

boolean in_edit_left(Object o, int x, int y) {
    return dist(x, y, o.x-o.radius-50, o.y) < 30;
}

boolean in_edit_right(Object o, int x, int y) {
    return dist(x, y, o.x+o.radius+50, o.y) < 30;
}

boolean in_edit_top(Object o, int x, int y) {
    return dist(x, y, o.x, o.y-o.radius-50) < 30;
}

boolean in_edit_bottom(Object o, int x, int y) {
    return dist(x, y, o.x, o.y+o.radius+50) < 30;
}

int select_menu(int x, int y) {
    for (int i = 0; i < objects.length; ++i) {
        Object o = objects[i];
        if (o.menu || o.menu_shapes) {
            if (in_edit_left(o,x,y)) {
                if (o.menu) {
                    // CANCEL MENU
                    o.menu = false;
                } else {
                    // CHANGE TO CIRCLE
                    o.shape = SHAPE_CIRCLE;
                    o.r = 255;
                    o.g = 0;
                    o.b = 0;
                    o.menu_shapes = false;
                } 
                break;
            } else if (in_edit_right(o,x,y)) {
                if (o.menu) {
                    // DELETE ITEM
                    objects.splice(i,1);
                } else {
                    // CHANGE TO TRIANGLE
                    o.shape = SHAPE_TRIANGLE;
                    o.r = 0;
                    o.g = 255;
                    o.b = 0;
                    o.menu_shapes = false;
                }
                break;
            } else if (in_edit_top(o,x,y)) {
                if (o.menu) {
                    // PLAY || PAUSE
                    o.active = !o.active;
                    o.menu = false;
                } else {
                    // CHANGE TO SQUARE
                    o.shape = SHAPE_SQUARE;
                    o.r = 0;
                    o.g = 0;
                    o.b = 255;
                    o.menu_shapes = false;
                }
                break;
            } else if (in_edit_bottom(o,x,y)) {
                if (o.menu) {
                    // CHANGE SHAPE
                    o.menu = false;
                    o.menu_shapes = true;
                } else {
                    // CANCEL MENU
                    o.menu = true;
                    o.menu_shapes = false;
                }
                break;
            }
        }
    }
    return -1;
}

//
// DRAG
//

void startDrag() {
	console.log("Start drag.");
    int found = 0;
    for (int i = 0; i < objects.length && found == 0; ++i) {
        if (dist(mouseX,mouseY,objects[i].x,objects[i].y) <= settings.drag_distance) {
			console.log("Object found.");
            found = 1;
            objects[i].moving = true;
        }
    }
	// create object if draged on corner area.
	if (found == 0 && isOnCornerArea(mouseX, mouseY)) {
		console.log("Drag started on corner area.");
		Object o = createShape(SHAPE_CIRCLE, mouseX, mouseY);
		o.moving = true;
		found = 1;
	}
}

void endDrag(int x, int y) {
    for (int i = 0; i < objects.length; i++) {
        if (objects[i].x == x && objects[i].y == y) {
            objects[i].moving = false;
			
			// delete object if drag released on corner area.
			if (isOnCornerArea(objects[i].x,objects[i].y)) {
				console.log("Object removed.");
				objects.pop(objects[i]);
			}
        }
    }
}

void processDrag(int x, int y) {
    for (int i = 0; i < objects.length; ++i) {
        Object o = objects[i];
        int rad = o.radius*2;
        if (o.moving && x > o.x-rad && x < o.x+rad && y > o.y-rad && y < o.y+rad) {
            objects[i].x = x;
            objects[i].y = y;
        }
    }
}

void handleHold(int x, int y) {
  int menu = open_menu(x, y);
}

void handleTouch(int x, int y) {
	// TODO Detect if on a keyboard and play
    int done = select_menu(x, y);
}





