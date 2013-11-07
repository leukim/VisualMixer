int SHAPE_CIRCLE = 0;
int SHAPE_SQUARE = 1;
int SHAPE_TRIANGLE = 2;
int SHAPE_SALTIRE = 3;
int SHAPE_RSALTIRE = 4;

var objects = new Array();
var settings = new Object();

int next = 0;

int add_shape;
int edit_shape;

void setup() {
    size(window.innerWidth, window.innerHeight);
    settings.object_radius = 25;
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
    settings.edit_menuX;
    settings.edit_menuY;
}


/*
 * DRAW FUNCTIONS
 */

void draw() {
    if (settings.moving != -1 || settings.add_menu == 1) noCursor();
    else cursor(ARROW);
    background(255,255,255);
    
    for (int i = 0; i < objects.length; ++i) {
        if (i != settings.moving) {
            drawItem(i);
        } else {
            drawMoving(i);
        }
    }
    
    if (settings.add_menu == 1) drawAddMenu();
    if (settings.edit_menu == 1) drawEditMenu();
}

void drawAddMenu() {
    int w = settings.height/8;
    add_shape = getCloserAddMenu();
    
    // CIRCLE
    int x = settings.add_menuX;
    int y = settings.add_menuY + w;
    if (add_shape != SHAPE_CIRCLE) {
        noStroke();
        fill(255,0,0,32);
    } else {
        stroke(0,0,0);
        line(settings.add_menuX, settings.add_menuY, settings.add_menuX-3*w*sqrt(2)/4, settings.add_menuY+3*w*sqrt(2)/4);
        line(settings.add_menuX, settings.add_menuY, settings.add_menuX+3*w*sqrt(2)/4, settings.add_menuY+3*w*sqrt(2)/4);
        fill(255,0,0,64);
    }
    
    arc(settings.add_menuX, settings.add_menuY, 3*w, 3*w, QUARTER_PI, HALF_PI+QUARTER_PI);
    
    if (add_shape == SHAPE_CIRCLE) drawCircle(x,y,20,1,128);
    else drawCircle(x,y,20,0,64);
    
    // TRIANGLE
    x = settings.add_menuX;
    y = settings.add_menuY - w;
    if (add_shape != SHAPE_TRIANGLE) {
        noStroke();
        fill(0,255,0,32);
    } else {
        stroke(0,0,0);
        line(settings.add_menuX, settings.add_menuY, settings.add_menuX-3*w*sqrt(2)/4, settings.add_menuY-3*w*sqrt(2)/4);
        line(settings.add_menuX, settings.add_menuY, settings.add_menuX+3*w*sqrt(2)/4, settings.add_menuY-3*w*sqrt(2)/4);
        fill(0,255,0,64);
    }
    
    arc(settings.add_menuX, settings.add_menuY, 3*w, 3*w, PI+QUARTER_PI,TWO_PI-QUARTER_PI);
    
    if (add_shape == SHAPE_TRIANGLE) drawTriangle(x,y,20,1,128);
    else drawTriangle(x,y,20,0,64);
    
    //SQUARE
    x = settings.add_menuX + w;
    y = settings.add_menuY;
    if (add_shape != SHAPE_SQUARE) {
        noStroke();
        fill(0,0,255,32);
    } else {
        stroke(0,0,0);
        line(settings.add_menuX, settings.add_menuY, settings.add_menuX+3*w*sqrt(2)/4, settings.add_menuY+3*w*sqrt(2)/4);
        line(settings.add_menuX, settings.add_menuY, settings.add_menuX+3*w*sqrt(2)/4, settings.add_menuY-3*w*sqrt(2)/4);
        fill(0,0,255,64);
    }
    
    arc(settings.add_menuX, settings.add_menuY, 3*w, 3*w, TWO_PI-QUARTER_PI, TWO_PI);
    arc(settings.add_menuX, settings.add_menuY, 3*w, 3*w, 0, QUARTER_PI);
    
    if (add_shape == SHAPE_SQUARE) drawSquare(x,y,20,1,128);
    else drawSquare(x,y,20,0,64);
    
    //SALTIRE
    x = settings.add_menuX - w;
    y = settings.add_menuY;
    if (add_shape != SHAPE_SALTIRE) {
        noStroke();
        fill(0,0,0,32);
    } else {
        stroke(0,0,0);
        line(settings.add_menuX, settings.add_menuY, settings.add_menuX-3*w*sqrt(2)/4, settings.add_menuY+3*w*sqrt(2)/4);
        line(settings.add_menuX, settings.add_menuY, settings.add_menuX-3*w*sqrt(2)/4, settings.add_menuY-3*w*sqrt(2)/4);
        fill(0,0,0,64);
    }
    
    arc(settings.add_menuX, settings.add_menuY, 3*w, 3*w, PI-QUARTER_PI, PI+QUARTER_PI);
    
    if (add_shape == SHAPE_SALTIRE) drawSaltire(x,y,20,10,1,128);
    else drawSaltire(x,y,20,10,0,64);
}

void drawEditMenu() {
    int w = settings.height/8;
    edit_shape = getCloserEditMenu();
    
    //RED SALTIRE
    x = settings.edit_menuX + w;
    y = settings.edit_menuY;
    if (edit_shape != SHAPE_RSALTIRE) {
        noStroke();
        fill(255,0,0,32);
    } else {
        stroke(0,0,0);
        line(settings.edit_menuX, settings.edit_menuY, settings.edit_menuX+3*w*sqrt(2)/4, settings.edit_menuY+3*w*sqrt(2)/4);
        line(settings.edit_menuX, settings.edit_menuY, settings.edit_menuX+3*w*sqrt(2)/4, settings.edit_menuY-3*w*sqrt(2)/4);
        fill(255,0,0,64);
    }
    
    arc(settings.edit_menuX, settings.edit_menuY, 3*w, 3*w, TWO_PI-QUARTER_PI, TWO_PI);
    arc(settings.edit_menuX, settings.edit_menuY, 3*w, 3*w, 0, QUARTER_PI);
    
    if (edit_shape == SHAPE_RSALTIRE) drawRSaltire(x,y,20,10,1,128);
    else drawRSaltire(x,y,20,10,0,64);
    
    //SALTIRE
    x = settings.edit_menuX - w;
    y = settings.edit_menuY;
    if (edit_shape != SHAPE_SALTIRE) {
        noStroke();
        fill(0,0,0,32);
    } else {
        stroke(0,0,0);
        line(settings.edit_menuX, settings.edit_menuY, settings.edit_menuX-3*w*sqrt(2)/4, settings.edit_menuY+3*w*sqrt(2)/4);
        line(settings.edit_menuX, settings.edit_menuY, settings.edit_menuX-3*w*sqrt(2)/4, settings.edit_menuY-3*w*sqrt(2)/4);
        fill(0,0,0,64);
    }
    
    arc(settings.edit_menuX, settings.edit_menuY, 3*w, 3*w, PI-QUARTER_PI, PI+QUARTER_PI);
    
    if (edit_shape == SHAPE_SALTIRE) drawSaltire(x,y,20,10,1,128);
    else drawSaltire(x,y,20,10,0,64);
}

void drawItem(int id) {
    int x = objects[id].x;
    int y = objects[id].y;
    int s = objects[id].shape;
    
    int cr = objects[id].r;
    int cg = objects[id].g;
    int cb = objects[id].b;
    
    int w = settings.height/2;
    
    int b = settings.object_radius;
    
    int f0 = (frameCount - objects[id].start_frame) % w;
    
    fill(cr,cg,cb,5);
    noStroke();
    for (int i = 0; i <= 50; ++i) {
        ellipse(x, y, b+i*w/50, b+i*w/50);
    }
    
    strokeWeight(3);
    noFill();
    for (int i = 0; i <= 5; ++i) {
        int r = b+((f0 + i*w/5)%w);
        stroke(cr,cg,cb,255*(1-(r/(w+b))));
        ellipse(x, y, r, r);
    }
    
    if (s == SHAPE_CIRCLE) drawCircle(x,y,20,1,255);
    else if (s == SHAPE_TRIANGLE) drawTriangle(x,y,20,1,255);
    else if (s == SHAPE_SQUARE) drawSquare(x,y,20,1,255);
}

void drawMoving(int id) {
    int x = mouseX;
    int y = mouseY;
    int s = objects[id].shape;
    
    int cr = objects[id].r;
    int cg = objects[id].g;
    int cb = objects[id].b;
    
    int w = settings.height/2;
    
    int f = (frameCount - objects[id].start_frame) / 100;
    
    fill(cr,cg,cb,32);
    noStroke();
    
    ellipse(x, y, 25+w, 25+w);
    
    stroke(cr,cg,cb);
    noFill();
    
    for (int i = 0; i < 32; i+=2) {
        float a = (TWO_PI*i/32 + f) % TWO_PI;
        float b = (TWO_PI*(i+1)/32 +f) % TWO_PI;
        if (a < b) arc(x, y, 25+w, 25+w,a,b);
        else {
            arc(x, y, 25+w, 25+w,a,TWO_PI);
            arc(x, y, 25+w, 25+w,0,b);
        }
    }
    
    if (s == SHAPE_CIRCLE) drawCircle(x,y,20,1,255);
    else if (s == SHAPE_TRIANGLE) drawTriangle(x,y,20,1,255);
    else if (s == SHAPE_SQUARE) drawSquare(x,y,20,1,255);
}

void drawCircle(int x, int y, int r, int st, int alpha) {
    fill(255,0,0, alpha);
    if (st == 0) noStroke();
    else stroke(0,0,0);
    ellipse(x, y, 2*r, 2*r);
}

void drawTriangle(int x, int y, int r, int st, int alpha) {
    fill(0,255,0, alpha);
    if (st == 0) noStroke();
    else stroke(0,0,0);
    triangle(x,y-r,x+r*sqrt(2)/2,y+r*sqrt(2)/2,x-r*sqrt(2)/2,y+r*sqrt(2)/2);
}

void drawSquare(int x, int y, int r, int st, int alpha) {
    fill(0,0,255, alpha);
    if (st == 0) noStroke();
    else stroke(0,0,0);
    rect(x-(r*sqrt(2)/2), y-(r*sqrt(2)/2),r*sqrt(2),r*sqrt(2));
}

void inner_drawSaltire(int x, int y, int r, int k, int st, int alpha, int cr, int cg, int cb) {
    fill(cr, cg, cb, alpha);
    if (st == 0) noStroke();
    else stroke(0,0,0);
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

void drawSaltire(int x, int y, int r, int k, int st, int alpha) {
    inner_drawSaltire(x, y, r, k, st, alpha, 0, 0, 0);
}

void drawRSaltire(int x, int y, int r, int k, int st, int alpha) {
    inner_drawSaltire(x, y, r, k, st, alpha, 255, 0, 0);
}

/*
 * HELPERS
 */

// TODO This needs a threshold to avoid collision with edit on multitouch TODO
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

// TODO This needs a threshold to avoid collision with add on multitouch TODO
int getCloserEditMenu() {
    int w = settings.height/8;
    
    int ret = -1;
    float distRST = dist(settings.add_menuX+w, settings.add_menuY, mouseX, mouseY);
    float distST = dist(settings.add_menuX-w, settings.add_menuY, mouseX, mouseY);
    if (distRST < distST) return SHAPE_RSALTIRE;
    if (distRST > distST) return SHAPE_SALTIRE;
    return -1;
}

int getCloserHold(float threshold) {
    if (objects.length == 0) return -1;
    
    int current = 0;
    float min_dist = dist(mouseX, mouseY, objects[0].x, objects[0].y);
    for (int i = 1; i < objects.length; ++i) {
        float new_dist = dist(mouseX, mouseY, objects[i].x, objects[i].y);
        if (new_dist < min_dist) {
            min_dist = new_dist;
            current = i;
        }
    }
    if (min_dist <= threshold) return current;
    return -1;
}

/*
 * STATE MODIFIERS
 */

void addShapeMenu() {
    settings.add_menuX = mouseX;
    settings.add_menuY = mouseY;
    settings.add_menu = 1;
}

void addMenuSelect() {
    settings.add_menu = 0;
    add_shape = getCloserAddMenu();
    if (add_shape != -1) addShape(settings.add_menuX, settings.add_menuY);
}

void editMenuSelect() {
    settings.edit_menu = 0;
    edit_shape = getCloserEditMenu();
    if (edit_shape == SHAPE_RSALTIRE) {
        objects.splice(settings.editing,1);
    }
    settings.editing = -1;
}

void addShape(mX, mY) {
    if (add_shape >= 0 && add_shape != SHAPE_SALTIRE) createShape(add_shape, mX, mY);
}

void createShape(int shape, int x, int y) {
    var o = new Object();
    o.x = x;
    o.y = y;
    o.start_frame = frameCount;
    o.shape = shape;
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
    //console.log(objects);
}

void editShapeMenu() {
    settings.edit_menuX = mouseX;
    settings.edit_menuY = mouseY;
    settings.edit_menu = 1;
    settings.editing = getCloserHold(settings.threshold);
}

void startDrag() {
    int found = 0;
    for (int i = 0; i < objects.length && found == 0; ++i) {
        if (dist(mouseX,mouseY,objects[i].x,objects[i].y) <= settings.drag_distance) {
            found = 1;
            settings.moving = i;
        }
    }
}

void endDrag() {
    if (settings.moving != -1) {
        objects[settings.moving].x = mouseX;
        objects[settings.moving].y = mouseY;
        settings.moving = -1;
    }
}


////////////////////////////////////////////////////////////////////////////////

var element = document.getElementById('table');

var hammertime = Hammer(element).on("hold", function(event) {
    if (getCloserHold(settings.threshold) != -1) editShapeMenu();
    else addShapeMenu();
});

hammertime = Hammer(element).on("touch", function(event) {
    if (settings.add_menu == 1) addMenuSelect();
    if (settings.edit_menu == 1) editMenuSelect();
});

hammertime = Hammer(element).on("dragstart", function(event) {
    event.gesture.preventDefault();
    startDrag();
});

hammertime = Hammer(element).on("dragend", function(event) {
    event.gesture.preventDefault();
    endDrag();
});






