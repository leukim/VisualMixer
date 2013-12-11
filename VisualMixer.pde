String EF_OFF = "";
String EF_CHORUS = "C";
String EF_DELAY = "D";
String EF_FILTER = "F";
String EF_PHASER = "P";
String EF_COMPRESSOR = "R";
String EF_OVERDRIVER = "O";
String EF_WAHWAH = "W";
String EF_TREMOLO = "T";


var ROLE = {
	EFFECT: 1,
	INSTRUMENT: 2
};

var INSTRUMENTS = {
	NONE: -1,
	SINE: 0,
	SQUARE: 1,
	TRIANGLE: 3,
	SAWTOOTH: 2
};

int FULL_COLOR = 255;
int HALF_COLOR = 127;
int QUARTER_COLOR = 63;

var objects = new Array();
var settings = new Object();

int next = 0;

int add_shape;
int edit_shape;

// Canvas to which this sketch is bound.
var canvas;
// Canvas drawing context for the running sketch.
var context;

void setup() {
    size(window.innerWidth, window.innerHeight,P2D);
	canvas = externals.canvas;
	context = externals.context;
	
    settings.object_radius = 20;
	settings.corner_radius = 80;
	settings.corner_drag_radius = 120;
	settings.keyboard_radius = 150;
    settings.width = window.innerWidth;
    settings.height = window.innerHeight;
    settings.drag_distance = 20;
    settings.link_distance = window.innerWidth / 5;
    
    strokeWeight(2);
    
    arial = loadFont("resources/arial.ttf");
    textFont(arial);
}


/*
 * DRAW FUNCTIONS
 */

void draw() {
    background(255,255,255);
    
    drawLinks();
    
	drawCorners();
	
    for (int i = 0; i < objects.length; ++i) {
        if (objects[i].role == ROLE.EFFECT) drawItem(i);
    }
    
    for (int i = 0; i < objects.length; ++i) {
		if (objects[i].role == ROLE.INSTRUMENT) draw_instrument(i);
	}
}

void drawLinks() {
	for (int i = 0; i < objects.length; ++i) {
		var instrument = objects[i];
		if (instrument.role == ROLE.INSTRUMENT) {
			for (int j = 0; j < objects.length; ++j) {
				var effect = objects[j];
				if (effect.role == ROLE.EFFECT && effect.effect != EF_OFF) {
					if (dist(instrument.x, instrument.y, effect.x, effect.y) < effect.halo) {
						float intensity = (effect.halo-dist(instrument.x, instrument.y, effect.x, effect.y))/effect.halo;
						int f = (frameCount - effect.start_frame)/20;
						strokeWeight (20*intensity*abs(sin(f)));
						stroke(effect.r, effect.g, effect.b);
						line(effect.x, effect.y, instrument.x, instrument.y);
						strokeWeight(2);
					}
				}
			}
		}
	}
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
	
	color volumebar = color(255,0,255,127);
	
	// keyboard area
	stroke(0,0,0);
	beginShape(TRIANGLE_FAN);
	fill(255,255,255,127);
	vertex(o.x, o.y);
	vertex(o.x-settings.keyboard_radius/2.0, o.y+settings.keyboard_radius);
	vertex(o.x+settings.keyboard_radius/2.0, o.y+settings.keyboard_radius);
	vertex(o.x+settings.keyboard_radius, o.y);
	vertex(o.x+settings.keyboard_radius, o.y);
	vertex(o.x+settings.keyboard_radius/2.0, o.y-settings.keyboard_radius);
	vertex(o.x-settings.keyboard_radius/2.0, o.y-settings.keyboard_radius);
	vertex(o.x-settings.keyboard_radius, o.y);
	endShape();
	
	strokeWeight(3);
	for (int i = 0; i < 14; ++i) {
		if (i == 6) {
			stroke(0,255,0);
		} else {
			stroke(255,0,0);
		}
		point(o.x+o.radius+(i*settings.keyboard_radius/14),o.y);
	}
	strokeWeight(2);
	
	// Volume area
	var volume = o.gainNode.gain.value;
	var volumeBar = context.createRadialGradient(o.x, o.y, settings.keyboard_radius*Math.min(volume, 0.99), o.x, o.y, settings.keyboard_radius);//context.createLinearGradient(0, 0, 100, 0);
	volumeBar.addColorStop(0, "rgba(255,0,0,127)");
	volumeBar.addColorStop(0.75, "rgba(255,255,0,127)");
	volumeBar.addColorStop(1, "rgba(0,255,0,127)");
	context.fillStyle = volumeBar;
	
	var cx_3 = (int) o.x-settings.keyboard_radius;
	
    context.beginPath();
    context.moveTo(o.x-settings.keyboard_radius/2, o.y+settings.keyboard_radius);
    context.lineTo(o.x,o.y);
    context.lineTo(o.x-settings.keyboard_radius,o.y);
	context.fill();
    context.closePath();
	context.stroke();
	
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
    text(EF_CHORUS, o.x-o.radius-75-20,o.y+20);

    fill(255,255,255);
    ellipse(o.x+o.radius+75,o.y,60,60); // RIGHT ITEM
    fill(0,255,0,QUARTER_COLOR);
    ellipse(o.x+o.radius+75,o.y,60,60); // RIGHT ITEM
    fill(0,0,0);
    text(EF_DELAY,o.x+o.radius+75-20, o.y+20);
    
    fill(255,255,255);
    ellipse(o.x,o.y-o.radius-75,60,60); // TOP ITEM
    fill(0,0,255,QUARTER_COLOR);    
    ellipse(o.x,o.y-o.radius-75,60,60); // TOP ITEM
    fill(0,0,0);
    text(EF_FILTER,o.x-20, o.y-o.radius-75+20);
    
    fill(255,255,255);
    ellipse(o.x,o.y+o.radius+75,60,60); // BOTTOM ITEM
    fill(255,255,0,QUARTER_COLOR);    
    ellipse(o.x,o.y+o.radius+75,60,60); // BOTTOM ITEM
    fill(0,0,0);
    text(EF_PHASER,o.x-20, o.y+o.radius+75+20);
    
    fill(255,255,255);
    ellipse(o.x-o.radius-50,o.y-o.radius-50,60,60); // TOP LEFT ITEM
    fill(255,0,255,QUARTER_COLOR);
    ellipse(o.x-o.radius-50,o.y-o.radius-50,60,60); // TOP LEFT ITEM
    fill(0,0,0);
    text(EF_COMPRESSOR,o.x-o.radius-50-20, o.y-o.radius-50+20);
    
    fill(255,255,255);
    ellipse(o.x+o.radius+50,o.y-o.radius-50,60,60); // TOP RIGHT ITEM
    fill(0,255,255,QUARTER_COLOR);
    ellipse(o.x+o.radius+50,o.y-o.radius-50,60,60); // TOP RIGHT ITEM
    fill(0,0,0);
    text(EF_OVERDRIVER,o.x+o.radius+50-20, o.y-o.radius-50+20);
    
    fill(255,255,255);
    ellipse(o.x-o.radius-50,o.y+o.radius+50,60,60); // BOTTOM LEFT ITEM
    fill(127,127,63,QUARTER_COLOR);
    ellipse(o.x-o.radius-50,o.y+o.radius+50,60,60); // BOTTOM LEFT ITEM
    fill(0,0,0);
    text(EF_WAHWAH,o.x-o.radius-50-20, o.y+o.radius+50+20);
    
    fill(255,255,255);
    ellipse(o.x+o.radius+50,o.y+o.radius+50,60,60); // BOTTOM RIGHT ITEM
    fill(127,63,127,QUARTER_COLOR);
    ellipse(o.x+o.radius+50,o.y+o.radius+50,60,60); // BOTTOM RIGHT ITEM
    fill(0,0,0);
    text(EF_TREMOLO,o.x+o.radius+50-20, o.y+o.radius+50+20);
}

void drawInstrumentMenu(int id) {
	Object o = objects[id];
	
	fill(255,255,255);
	strokeWeight(2);
    ellipse(o.x-o.radius-75,o.y,60,60); // LEFT ITEM
    ellipse(o.x-o.radius-75,o.y,60,60); // LEFT ITEM
    strokeWeight(1);
    float a = 0.0;
	float inc = TWO_PI/25.0;
	float prev_x = o.x-o.radius-75-10, prev_y = o.y, x, y;

	for(int i=0; i<25; i=i+1) {
	  x = o.x-o.radius-75-10+i;
	  y = o.y + sin(a) * 10.0;
	  line(prev_x, prev_y, x, y);
	  prev_x = x;
	  prev_y = y;
	  a = a + inc;
	}
	strokeWeight(2);
    
    ellipse(o.x+o.radius+75,o.y,60,60); // RIGHT ITEM
    ellipse(o.x+o.radius+75,o.y,60,60); // RIGHT ITEM
    strokeWeight(1);
	beginShape();
	vertex(o.x+o.radius+75-10, o.y+5);
	vertex(o.x+o.radius+75-5, o.y+5);
	vertex(o.x+o.radius+75-5, o.y-5);
	vertex(o.x+o.radius+75+5, o.y-5);
	vertex(o.x+o.radius+75+5, o.y+5);
	vertex(o.x+o.radius+75+10, o.y+5);
	endShape();
	strokeWeight(2);
    
    ellipse(o.x,o.y-o.radius-75,60,60); // TOP ITEM
    ellipse(o.x,o.y-o.radius-75,60,60); // TOP ITEM
    strokeWeight(1);
	noFill();
	beginShape();
	vertex(o.x-15,o.y-o.radius-75);
	vertex(o.x-10,o.y-o.radius-75-10);
	vertex(o.x,o.y-o.radius-75+10);
	vertex(o.x+10,o.y-o.radius-75-10);
	vertex(o.x+15,o.y-o.radius-75);
	endShape();
	strokeWeight(2);
    
    ellipse(o.x,o.y+o.radius+75,60,60); // BOTTOM ITEM
    ellipse(o.x,o.y+o.radius+75,60,60); // BOTTOM ITEM
    strokeWeight(1);
	noFill();
	beginShape();
	vertex(o.x-10,o.y+o.radius+75);
	vertex(o.x-5,o.y+o.radius+75-5);
	vertex(o.x-5,o.y+o.radius+75+5);
	vertex(o.x+10,o.y+o.radius+75-5);
	vertex(o.x+10,o.y+o.radius+75);
	endShape();
	strokeWeight(2);
    
}

void drawItem(int id) {
    Object i = objects[id];
    
    int w = settings.height/2;
    int f = (frameCount - i.start_frame) % w;
    int f2 = (frameCount - i.start_frame) / 100;
	
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

void draw_instrument(int id) {
	Object o = objects[id];
	
	if (!o.menu && o.keyboard) drawKeyboard(id);
	
	fill(255,255,255);
	stroke(0,0,0);
	ellipse(o.x, o.y, 2*o.radius, 2*o.radius);
	
	switch(o.type) {
		case INSTRUMENTS.SINE:
			strokeWeight(1);
			float a = 0.0;
			float inc = TWO_PI/25.0;
			float prev_x = o.x-10, prev_y = o.y, x, y;

			for(int i=0; i<25; i=i+1) {
			  x = o.x-10+i;
			  y = o.y + sin(a) * 10.0;
			  line(prev_x, prev_y, x, y);
			  prev_x = x;
			  prev_y = y;
			  a = a + inc;
			}
			strokeWeight(2);
			break;
		case INSTRUMENTS.SQUARE:
			strokeWeight(1);
			beginShape();
			vertex(o.x-10, o.y+5);
			vertex(o.x-5, o.y+5);
			vertex(o.x-5, o.y-5);
			vertex(o.x+5, o.y-5);
			vertex(o.x+5, o.y+5);
			vertex(o.x+10, o.y+5);
			endShape();
			strokeWeight(2);
			break;
		case INSTRUMENTS.TRIANGLE:
			strokeWeight(1);
			noFill();
			beginShape();
			vertex(o.x-15,o.y);
			vertex(o.x-10,o.y-10);
			vertex(o.x,o.y+10);
			vertex(o.x+10,o.y-10);
			vertex(o.x+15,o.y);
			endShape();
			strokeWeight(2);
			break;
		case INSTRUMENTS.SAWTOOTH:
			strokeWeight(1);
			noFill();
			beginShape();
			vertex(o.x-10,o.y);
			vertex(o.x-5,o.y-5);
			vertex(o.x-5,o.y+5);
			vertex(o.x+10,o.y-5);
			vertex(o.x+10,o.y);
			endShape();
			strokeWeight(2);
			break;
		default:
			break;
	}
	
	if (o.menu) drawInstrumentMenu(id);
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
 
 int add_instrument(int x, int y) {
	 Object o = new Object();
	 o.x = x;
	 o.y = y;
	 o.type = INSTRUMENTS.NONE;
	 o.menu = true;
	 o.keyboard = true;
	 o.role = ROLE.INSTRUMENT;
	 o.radius = 20;
	 o.effects = new Array();
	 
	 var resultOscillator = getOscillator(INSTRUMENTS.SINE);
	 
	 o.oscillator = resultOscillator[0]; // oscillator node
	 o.gainNode = resultOscillator[1]; // gain node
	 
	 objects.push(o);
 }

Object createShape(int effect, int x, int y) {
    var o = new Object();
    o.role = ROLE.EFFECT;
    o.x = x;
    o.y = y;
    o.start_frame = frameCount;
    o.shape = shape;
    o.radius = settings.object_radius;
    o.halo = settings.height/2;
    o.menu = false;
	o.keyboard = false;
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
        case EF_FILTER:
            o.r = 0;
            o.g = 0;
            o.b = 255;
            break;
        case EF_PHASER:
            o.r = 255;
            o.g = 255;
            o.b = 0;
            break;
        case EF_COMPRESSOR:
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
        case EF_TREMOLO:
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

boolean open_edit_menu(int x, int y) {
    for (int i = 0; i < objects.length; ++i) {
        Object o = objects[i];
        if (!o.menu_shapes && dist(x,y,o.x,o.y) <= o.radius) {
            objects[i].menu = true;
            return true;
        }
    }
    return false;
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
				if (o.role == ROLE.EFFECT) {
					o.effect = EF_CHORUS;
					o.r = 255;
					o.g = 0;
					o.b = 0;
				} else {
					o.type = INSTRUMENTS.SINE;
				}
				o.menu = false;
            } else if (in_edit_right(o,x,y)) {
				if (o.role == ROLE.EFFECT) {
					o.effect = EF_DELAY;
					o.r = 0;
					o.g = 255;
					o.b = 0;
				} else {
					o.type = INSTRUMENTS.SQUARE;
				}
				o.menu = false;
            } else if (in_edit_top(o,x,y)) {
				if (o.role == ROLE.EFFECT) {
					o.effect = EF_FILTER;
					o.r = 0;
					o.g = 0;
					o.b = 255;
				} else {
					o.type = INSTRUMENTS.TRIANGLE;
				}
                o.menu = false;
            } else if (in_edit_bottom(o,x,y)) {
				if (o.role == ROLE.EFFECT) {
					o.effect = EF_PHASER;
					o.r = 255;
					o.g = 255;
					o.b = 0;
				} else {
					o.type = INSTRUMENTS.SAWTOOTH;
				}
                o.menu = false;
            } else if (in_edit_topleft(o,x,y)) {
				if (o.role == ROLE.EFFECT) {
					o.effect = EF_COMPRESSOR;
					o.r = 255;
					o.g = 0;
					o.b = 255;
					o.menu = false;
				}
            } else if (in_edit_topright(o,x,y)) {
				if (o.role == ROLE.EFFECT) {
					o.effect = EF_OVERDRIVER;
					o.r = 0;
					o.g = 255;
					o.b = 255;
					o.menu = false;
				}
            } else if (in_edit_bottomleft(o,x,y)) {
				if (o.role == ROLE.EFFECT) {
					o.effect = EF_WAHWAH;
					o.r = 127;
					o.g = 127;
					o.b = 63;
					o.menu = false;
				}
            } else if (in_edit_bottomright(o,x,y)) {
				if (o.role == ROLE.EFFECT) {
					o.effect = EF_TREMOLO;
					o.r = 127;
					o.g = 63;
					o.b = 127;
					o.menu = false;
				}
            }
        }
    }
    return -1;
}

//
// MUSIC
//

boolean play(int x, int y) {
	for (int i = 0; i < objects.length; ++i) {
        Object o = objects[i];

		if (o.role == ROLE.INSTRUMENT && !o.menu && dist(o.x,o.y,x,y) <= settings.keyboard_radius &&
			dist(o.x,o.y,x,y) >= o.radius) { // We don't want the inner circle to play
				
			if (o.playX == x && o.playY == y) return true; // Don't duplicate instrument sound on hold
			
			// PITCH
			float distFromCenter = (dist(o.x,o.y,x,y)-o.radius)/(settings.keyboard_radius-o.radius);
			float pitch = 261.63 + 261.62*2*(distFromCenter);
			
			// VOLUME
			// Check if inside volume control area or rest of the instrument
			PVector vec = new PVector(o.x-x, o.y-y);
			vec.normalize();
			float angle = PVector.angleBetween(new PVector(1,0), vec);
			if (y > o.y && x < o.x && angle <= 1.0) {
				// We're on volume control, change volume
				o.gainNode.gain.value = distFromCenter;
			} else {
				// We're not on volume control, play instrument
				var result;
				if (o.gainNode) {
					result = getOscillator(o.type, o.gainNode);
				} else {
					result = getOscillator(o.type);
					o.gainNode = result[1];
				}
				o.oscillator = result[0];
				
				currentNode = o.gainNode;
				
				for (int j = 0; j < objects.length; ++j) {
					var effect = objects[j];
					if (effect.role == ROLE.EFFECT) {
						if (dist(o.x, o.y, effect.x, effect.y) < effect.halo) {
							float intensity = (effect.halo-dist(o.x, o.y, effect.x, effect.y))/effect.halo;
							switch (effect.effect) {
								case EF_CHORUS:
									effect_object = new tuna.Chorus({
										 rate: 8,
										 feedback: 1*intensity,
										 delay: 1*intensity,
										 bypass: 0
									 });
									break;
								case EF_DELAY:
									effect_object = new tuna.Delay({
										feedback: 0.8,    //0 to 1+
										delayTime: 3000,    //how many milliseconds should the wet signal be delayed? 
										wetLevel: 0.75,    //0 to 1+
										dryLevel: 0.5,       //0 to 1+
										cutoff: 20,        //cutoff frequency of the built in highpass-filter. 20 to 22050
										bypass: 0
									});
									break;
								case EF_TREMOLO:
									// TODO: 
									// Wondering which parameter should we changed 
									// according to the filter distance from the oscillator(s)
									effect_object = new tuna.Tremolo({
					                  intensity: 1,    //0 to 1
					                  rate: 8*intensity,         //0.001 to 8
					                  stereoPhase: 180*intensity,    //0 to 180
					                  bypass: 0
					             	});
					             	break;
					            case EF_WAHWAH:
									effect_object = new tuna.WahWah({
						                automode: false,                //true/false
						                baseFrequency: 0.5,            //0 to 1
						                excursionOctaves: 6,           //1 to 6
						                sweep: 0.5,                    //0 to 1
						                resonance: 100*intensity,                 //1 to 100
						                sensitivity: 1,              //-1 to 1
						                bypass: 0
						            });
						            break;
						        case EF_OVERDRIVER:
						            effect_object = new tuna.Overdrive({
                    						outputGain: 0,         //0 to 1+
                    						drive: 1*intensity,              //0 to 1
                    						curveAmount: 1*intensity,          //0 to 1
                    						algorithmIndex: 1,       //0 to 5, selects one of our drive algorithms
                    						bypass: 0
                					});
                					break;
								case EF_FILTER:
						            effect_object = new tuna.Filter({
											frequency: 20,         //20 to 22050
											Q: 1,                  //0.001 to 100
											gain: 0,               //-40 to 40
											bypass: 1,             //0 to 1+
											filterType: 0,         //0 to 7, corresponds to the filter types in the native filter node: lowpass, highpass, bandpass, lowshelf, highshelf, peaking, notch, allpass in that order
											bypass: 0
                					});
                					break;
								case EF_PHASER:
						            effect_object = new tuna.Phaser({
											rate: 8*intensity,                     //0.01 to 8 is a decent range, but higher values are possible
											depth: 0.3,                    //0 to 1
											feedback: 0.2,                 //0 to 1+
											stereoPhase: 30,               //0 to 180
											baseModulationFrequency: 700,  //500 to 1500
											bypass: 0
                					});
                					break;
								case EF_COMPRESSOR:
						            effect_object = new tuna.Compressor({
											threshold: -100*intensity,    //-100 to 0
											makeupGain: 0,     //0 and up
											attack: 500*intensity,         //0 to 1000
											release: 500*intensity,        //0 to 3000
											ratio: 10,          //1 to 20
											knee: 20,           //0 to 40
											automakeup: true,  //true/false
											bypass: 0
                					});
                					break;
							}
							addEffectNode(currentNode, effect_object);
							o.effects.push(effect_object);
							currentNode = effect_object;
						}
					}
				}
				
				playNote(o.oscillator, pitch);
				
				o.playX = x;
				o.playY = y;
				return true;
			}
		}
    }
    return false;
}

//
// DRAG
//

boolean try_end_drag(int x, int y, int x_ini, int y_ini) {
	boolean dragged = false;
	for (int i = 0; i < objects.length; i++) {
		Object o = objects[i];
		int rad = o.radius*2.5;
		if (x_ini > o.movingX-rad && x_ini < o.movingX+rad && y_ini > o.movingY-rad && y_ini < o.movingY+rad) {
            o.movingX = null;
            o.movingY = null;
			
			// delete object if drag released on corner area.
			if (isOnCornerArea(o.x,o.y)) {
				objects.splice(i,1);
			}
			dragged = true;
        }
    }
    return dragged;
}

void startDrag(int x, int y, int x_ini, int y_ini) {
    int found = 0;
    for (int i = 0; i < objects.length && found == 0; ++i) {
		Object o = objects[i];
        if (dist(x_ini,y_ini,o.x,o.y) <= settings.drag_distance) {
            found = 1;
            o.movingX = x_ini;
            o.movingY = y_ini;
            o.x = x;
            o.y = y;
        }
    }
	// create object if draged on corner area.
	if (found == 0 && isOnCornerArea(x, y)) {
		Object o = createShape(EF_OFF, x, y);
		o.movingX = x;
        o.movingY = y;
		found = 1;
	}
}

void endDrag(int x, int y, int x_ini, int y_ini) {
	boolean dragged = try_end_drag(x,y, x_ini, y_ini);
	if (!dragged) {
		
	}
}

void processDrag(int x, int y, int x_ini, int y_ini) {
    for (int i = 0; i < objects.length; ++i) {
        Object o = objects[i];
        int rad = o.radius*2.5;
        if (o.movingX && x_ini > o.movingX-rad && x_ini < o.movingX+rad && y_ini > o.movingY-rad && y_ini < o.movingY+rad) {
            o.x = x;
            o.y = y;
        }
        if (o.oscillator != null) {
			float distFromCenter = (dist(o.x,o.y,x,y)-o.radius)/(settings.keyboard_radius-o.radius);
			float pitch = 261.63 + 261.62*2*(distFromCenter);
			o.oscillator.frequency.value = pitch;
		}
    }
}

void handleHold(int x, int y) {
	if (!play(x,y)) {
		if (!open_edit_menu(x, y)) {
		  add_instrument(x,y);
		}
	}	
}

void handleTouch(int x, int y) {
	//Detect if on a keyboard and play
	boolean played = play(x,y);
	
	// If not on a keyboard, try to open a menu
	if (!played) {
		int done = select_menu(x, y);
	}
}

void handleRelease(int x, int y, int orig_x, int orig_y) {
	for (int i = 0; i < objects.length; ++i) {
		if (objects[i].role == ROLE.INSTRUMENT) {
			Object o = objects[i];
			if (o.playX == orig_x && o.playY == orig_y) {
				stopNote(o.oscillator);
				while(o.effects.length > 0) {
					var ef = o.effects.pop();
					ef.disconnect();
				}
				o.oscillator = null;
				
				o.playX = null;
				o.playY = null;
			}
		}
	}
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
            o.halo = dist(event.gesture.touches[0].pageX, event.gesture.touches[0].pageY,event.gesture.touches[1].pageX, event.gesture.touches[1].pageY);
        }
    }
}
