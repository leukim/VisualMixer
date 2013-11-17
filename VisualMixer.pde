String EF_OFF = "";
String EF_CHORUS = "C";
String EF_DELAY = "D";
String EF_FLANGER = "F";
String EF_MODULATOR = "M";
String EF_HARMONIZER = "H";
String EF_OVERDRIVER = "O";
String EF_WAHWAH = "W";
String EF_REVER = "R";

int FULL_COLOR = 255;
int HALF_COLOR = 127;
int QUARTER_COLOR = 63;

var objects = new Array();
var settings = new Object();

int next = 0;

int add_shape;
int edit_shape;

void setup() {
    size(window.innerWidth, window.innerHeight);
    settings.object_radius = 20;
	settings.corner_radius = 80;
	settings.corner_drag_radius = 120;
	settings.keyboard_radius = 100;
    settings.width = window.innerWidth;
    settings.height = window.innerHeight;
    settings.drag_distance = 40;
    
    strokeWeight(2);
    
    arial = loadFont("resources/arial.ttf");
    textFont(arial);
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
	
	//drawKeyboard();
}

void drawCorners() {
	int r = settings.corner_radius;
	int fillCounter = 50;
	
	noStroke();
    fill(255,102,0,5);

    for (int i = 0; i <= fillCounter; ++i) {
        ellipse(0, 0, 3*r*i/50, 3*r*i/fillCounter);
        ellipse(settings.width, settings.height, 3*r*i/fillCounter, 3*r*i/fillCounter);
	    ellipse(settings.width, 0, 3*r*i/fillCounter, 3*r*i/fillCounter);
	    ellipse(0, settings.height, 3*r*i/fillCounter, 3*r*i/fillCounter);
    }
    
    
}

boolean isOnCornerArea(int x, int y) {
	if (dist(x,y,0.0,0.0) <= settings.corner_drag_radius || dist(x,y,settings.width,settings.height) <= settings.corner_drag_radius || dist(x,y,settings.width,0.0) <= settings.corner_drag_radius || dist(x,y,0.0,settings.height) <= settings.corner_drag_radius) {
			return true;
	}
	return false;
}

void drawKeyboard(int id) {
	Object o = objects[id];
	
	stroke(0,0,0);
	noFill();
	
	beginShape(TRIANGLE_FAN);
	
	vertex(o.x, o.y);
	vertex(o.x-settings.keyboard_radius, o.y);
	vertex(o.x-settings.keyboard_radius/2.0, o.y+settings.keyboard_radius);
	vertex(o.x+settings.keyboard_radius/2.0, o.y+settings.keyboard_radius);
	vertex(o.x+settings.keyboard_radius, o.y);
	vertex(o.x+settings.keyboard_radius, o.y);
	vertex(o.x+settings.keyboard_radius/2.0, o.y-settings.keyboard_radius);
	vertex(o.x-settings.keyboard_radius/2.0, o.y-settings.keyboard_radius);
	vertex(o.x-settings.keyboard_radius, o.y);
	
	endShape();
	
}

void drawEditMenu(int id) {
    Object o = objects[id];
    
    stroke(0,0,0);
    textSize(50);
    
    fill(255,255,255);
    ellipse(o.x-o.radius-75,o.y,60,60); // LEFT ITEM
    fill(255,0,0,QUARTER_COLOR);
    ellipse(o.x-o.radius-75,o.y,60,60); // LEFT ITEM
    fill(0,0,0);
    text("C", o.x-o.radius-75-20,o.y+20);
    
    fill(255,255,255);
    ellipse(o.x+o.radius+75,o.y,60,60); // RIGHT ITEM
    fill(0,255,0,QUARTER_COLOR);
    ellipse(o.x+o.radius+75,o.y,60,60); // RIGHT ITEM
    fill(0,0,0);
    text("D",o.x+o.radius+75-20, o.y+20);
    
    fill(255,255,255);
    ellipse(o.x,o.y-o.radius-75,60,60); // TOP ITEM
    fill(0,0,255,QUARTER_COLOR);    
    ellipse(o.x,o.y-o.radius-75,60,60); // TOP ITEM
    fill(0,0,0);
    text("F",o.x-20, o.y-o.radius-75+20);
    
    fill(255,255,255);
    ellipse(o.x,o.y+o.radius+75,60,60); // BOTTOM ITEM
    fill(255,255,0,QUARTER_COLOR);    
    ellipse(o.x,o.y+o.radius+75,60,60); // BOTTOM ITEM
    fill(0,0,0);
    text("M",o.x-20, o.y+o.radius+75+20);
    
    fill(255,255,255);
    ellipse(o.x-o.radius-50,o.y-o.radius-50,60,60); // TOP LEFT ITEM
    fill(255,0,255,QUARTER_COLOR);
    ellipse(o.x-o.radius-50,o.y-o.radius-50,60,60); // TOP LEFT ITEM
    fill(0,0,0);
    text("H",o.x-o.radius-50-20, o.y-o.radius-50+20);
    
    fill(255,255,255);
    ellipse(o.x+o.radius+50,o.y-o.radius-50,60,60); // TOP RIGHT ITEM
    fill(0,255,255,QUARTER_COLOR);
    ellipse(o.x+o.radius+50,o.y-o.radius-50,60,60); // TOP RIGHT ITEM
    fill(0,0,0);
    text("O",o.x+o.radius+50-20, o.y-o.radius-50+20);
    
    fill(255,255,255);
    ellipse(o.x-o.radius-50,o.y+o.radius+50,60,60); // BOTTOM LEFT ITEM
    fill(127,127,63,QUARTER_COLOR);
    ellipse(o.x-o.radius-50,o.y+o.radius+50,60,60); // BOTTOM LEFT ITEM
    fill(0,0,0);
    text("W",o.x-o.radius-50-20, o.y+o.radius+50+20);
    
    fill(255,255,255);
    ellipse(o.x+o.radius+50,o.y+o.radius+50,60,60); // BOTTOM RIGHT ITEM
    fill(127,63,127,QUARTER_COLOR);
    ellipse(o.x+o.radius+50,o.y+o.radius+50,60,60); // BOTTOM RIGHT ITEM
    fill(0,0,0);
    text("R",o.x+o.radius+50-20, o.y+o.radius+50+20);
}

void drawItem(int id) {
    Object i = objects[id];
    
    int w = settings.height/2;
    int f = (frameCount - i.start_frame) % w;
    int f2 = (frameCount - i.start_frame) / 100;
    
	if (i.keyboard) drawKeyboard(id);
	
    if (false && i.moving) {
        if (i.effect != EF_OFF) fill(i.r,i.g,i.b,32);
        else fill(127,127,127,32);
        noStroke();
        
        ellipse(i.x, i.y, 25+w, 25+w);
        
        if (i.effect != EF_OFF) stroke(i.r,i.g,i.b);
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
    }
    
    fill(i.r,i.g,i.b,5);
    noStroke();
    for (int j = 0; j <= 50; ++j) {
        ellipse(i.x, i.y, i.radius+j*i.halo/50, i.radius+j*i.halo/50);
    }
    
    noFill();
    for (int j = 0; j <= 5; ++j) {
        int r = 2*i.radius+((f + j*w/5)%w);
        stroke(i.r,i.g,i.b,255*(1-(r/(w+i.radius))));
        ellipse(i.x, i.y, r, r);
    }
    
    if (i.effect != EF_OFF) fill(i.r,i.g,i.b, FULL_COLOR);
    else fill(127,127,127);
    stroke(0,0,0);
    ellipse(i.x, i.y, 2*i.radius, 2*i.radius);
    fill(0,0,0);
    textSize(30);
    text(i.effect, i.x-10, i.y+10);
    
    if (i.menu) drawEditMenu(id);
	
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
 * STATE MODIFIERS
 */

Object createShape(int effect, int x, int y) {
    var o = new Object();
    o.x = x;
    o.y = y;
    o.start_frame = frameCount;
    o.shape = shape;
    o.active = false;
    o.radius = settings.object_radius;
    o.halo = settings.height/2;
    o.menu = false;
	o.keyboard = true;
    o.effect = effect;
    switch(effect) {
        case EF_OFF:
            o.r = 127;
            o.g = 127;
            o.b = 127;
            break;
        case EF_CHORUS:
            o.r = 255;
            o.g = 0;
            o.b = 0;
            break;
        case EF_DELAY:
            o.r = 0;
            o.g = 255;
            o.b = 0;
            break;
        case EF_FLANGER:
            o.r = 0;
            o.g = 0;
            o.b = 255;
            break;
        case EF_MODULATOR:
            o.r = 255;
            o.g = 255;
            o.b = 0;
            break;
        case EF_HARMONIZER:
            o.r = 255;
            o.g = 0;
            o.b = 255;
            break;
        case EF_OVERDRIVER:
            o.r = 0;
            o.g = 255;
            o.b = 255;
            break;
        case EF_WAHWAH:
            o.r = 127;
            o.g = 127;
            o.b = 63;
            break;
        case EF_REVER:
            o.r = 127;
            o.g = 63;
            o.b = 127;
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
    return dist(x, y, o.x-o.radius-75, o.y) < 30;
}

boolean in_edit_right(Object o, int x, int y) {
    return dist(x, y, o.x+o.radius+75, o.y) < 30;
}

boolean in_edit_top(Object o, int x, int y) {
    return dist(x, y, o.x, o.y-o.radius-75) < 30;
}

boolean in_edit_bottom(Object o, int x, int y) {
    return dist(x, y, o.x, o.y+o.radius+75) < 30;
}

boolean in_edit_topright(Object o, int x, int y) {
    return dist(x, y, o.x+o.radius+50, o.y-o.radius-50) < 30;
}

boolean in_edit_topleft(Object o, int x, int y) {
    return dist(x, y, o.x-o.radius-50, o.y-o.radius-50) < 30;
}

boolean in_edit_bottomleft(Object o, int x, int y) {
    return dist(x, y, o.x-o.radius-50, o.y+o.radius+50) < 30;
}

boolean in_edit_bottomright(Object o, int x, int y) {
    return dist(x, y, o.x+o.radius+50, o.y+o.radius+50) < 30;
}


int select_menu(int x, int y) {
    for (int i = 0; i < objects.length; ++i) {
        Object o = objects[i];
        if (o.menu) {
            if (in_edit_left(o,x,y)) {
                o.effect = EF_CHORUS;
                o.r = 255;
                o.g = 0;
                o.b = 0;
                o.menu = false;
            } else if (in_edit_right(o,x,y)) {
                o.effect = EF_DELAY;
                o.r = 0;
                o.g = 255;
                o.b = 0;
                o.menu = false;
            } else if (in_edit_top(o,x,y)) {
                o.effect = EF_FLANGER;
                o.r = 0;
                o.g = 0;
                o.b = 255;
                o.menu = false;
            } else if (in_edit_bottom(o,x,y)) {
                o.effect = EF_MODULATOR;
                o.r = 255;
                o.g = 255;
                o.b = 0;
                o.menu = false;
            } else if (in_edit_topleft(o,x,y)) {
                o.effect = EF_HARMONIZER;
                o.r = 255;
                o.g = 0;
                o.b = 255;
                o.menu = false;
            } else if (in_edit_topright(o,x,y)) {
                o.effect = EF_OVERDRIVER;
                o.r = 0;
                o.g = 255;
                o.b = 255;
                o.menu = false;
            } else if (in_edit_bottomleft(o,x,y)) {
                o.effect = EF_WAHWAH;
                o.r = 127;
                o.g = 127;
                o.b = 63;
                o.menu = false;
            } else if (in_edit_bottomright(o,x,y)) {
                o.effect = EF_REVER;
                o.r = 127;
                o.g = 63;
                o.b = 127;
                o.menu = false;
            }
        }
    }
    return -1;
}

//
// DRAG
//

void startDrag() {
	//console.log("Start drag.");
    int found = 0;
    for (int i = 0; i < objects.length && found == 0; ++i) {
        if (dist(mouseX,mouseY,objects[i].x,objects[i].y) <= settings.drag_distance) {
			//console.log("Object found.");
            found = 1;
            objects[i].moving = true;
        }
    }
	// create object if draged on corner area.
	if (found == 0 && isOnCornerArea(mouseX, mouseY)) { // TODO Should not use mouseX and mouseX
		//console.log("Drag started on corner area.");
		Object o = createShape(EF_OFF, mouseX, mouseY); // TODO Should not use mouseX and mouseX
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
				//console.log("Object removed.");
				objects.splice(i,1);
			}
        }
    }
}

void processDrag(int x, int y) {
    for (int i = 0; i < objects.length; ++i) {
        Object o = objects[i];
        int rad = o.radius*2.5;
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
	
	// sound
	for (int i = 0; i < objects.length; ++i) {
        Object o = objects[i];
        //int rad = o.radius*2.5;
		if (!o.moving && dist(o.x,o.y,x,y) <= settings.keyboard_radius) {
			float soundPitch = Math.min(2000.0, 2000.0*(dist(o.x,o.y,x,y) / settings.keyboard_radius));
			console.log('Pitch ' + soundPitch);
			playNote(soundPitch);
		}
		//dist(x,y,0.0,0.0) <= settings.corner_drag_radius
        //if (o.moving && x > o.x-rad && x < o.x+rad && y > o.y-rad && y < o.y+rad) {
        //    objects[i].x = x;
        //    objects[i].y = y;
        //}
    }
}

void handleRelease(int x, int y) {
}

//
// DRAG
//

void handlePinch(int x, int y, float scale, Object event) {
    fill(0);
    ellipse(event.gesture.touches[0].pageX, event.gesture.touches[0].pageY, 5,5);
    ellipse(event.gesture.touches[1].pageX, event.gesture.touches[1].pageY, 5,5);
    for (int i = 0; i < objects.length; ++i) {
        Object o = objects[i];
        if (dist(x,y,o.x,o.y) < o.halo) {
            //o.halo *= scale;
            o.halo = dist(event.gesture.touches[0].pageX, event.gesture.touches[0].pageY,event.gesture.touches[1].pageX, event.gesture.touches[1].pageY);
        }
    }
}




