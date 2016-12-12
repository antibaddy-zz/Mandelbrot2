/**
 * The Mandelbrot Set
 * by Debbie Carne.  
 * 
 * Simple rendering of the Mandelbrot set.
 */
 
// Control constants
boolean DISPLAY_ZOOM = false; // Display the zoom level in the window as well as in the console

// Set up window size
int WIN_WIDTH  = 600;
int WIN_HEIGHT = WIN_WIDTH;
float WINDOW_RATIO = WIN_WIDTH / WIN_HEIGHT;


// Initial width to calculate set from
float SET_WIDTH = 5;

// Maximum number of iterations for each point on the complex plane
int MAX_ITERATIONS = 100;

// Consider a point as 'excaped' to infinity if it is greater than this:
float INFINITY_BREACH = 16.0;

// Establish a range of values on the complex plane
// A different range will allow us to "zoom" in or out on the fractal
float w, h;
float xmin, ymin;
float xmax, ymax;
float start_scale;

// Set up colorMap array
PVector[] colorMap = new PVector[16];

// Selection rectangle, used to zoom the set
SelectionRectangle selectionRect;

// Implementation of P3's settings function
// Allows windows size to be set with variables
void settings() {
  size(WIN_WIDTH, WIN_HEIGHT);
}

void setup() {
  background(51);
  
  printWindowRatio();
  
  setupColorMap();
  
  selectionRect = new SelectionRectangle();
  
  resetSet(SET_WIDTH);
}

void draw() {
  // Make sure we can write to the pixels[] array.
  // Only need to do this once since we don't do any other drawing.
  loadPixels();
  // Calculate amount we increment x,y for each pixel
  float dx = (xmax - xmin) / (width);
  float dy = (ymax - ymin) / (height);
  
  //println("dx", dx);
  
  // Start y
  float y = ymin;
  for (int j = 0; j < height; j++) {
    // Start x
    float x = xmin;
    for (int i = 0; i < width; i++) {
  
      // Now we test, as we iterate z = z^2 + cm does z tend towards infinity?
      float a = x;
      float b = y;
      int n = 0;
      while (n < MAX_ITERATIONS) {
        float aa = a * a;
        float bb = b * b;
        float twoab = 2.0 * a * b;
        a = aa - bb + x;
        b = twoab + y;
        // Consider point to be escaping to infinity once the distance
        // between (aa, bb) and the origin is greater than 16
        // where dist(x1, y1, x2, y2) is the distance between two points
        if (dist(aa, bb, 0, 0) > INFINITY_BREACH) {
          break;  // Bail
        }
        n++;
      }
  
      // We color each pixel based on how long it takes to get to infinity
      // If we never got there, let's pick the color black
      if (n == MAX_ITERATIONS) {
        pixels[i+j*width] = color(0);
      } else {
        // Gosh, we could make fancy colors here if we wanted
        float norm = map(n, 0, MAX_ITERATIONS, 0, 1);
        int cm    = n % 16;
        int red   = int(colorMap[cm].x);
        int green = int(colorMap[cm].y);
        int blue =  int(colorMap[cm].z);
        pixels[i+j*width] = color(red, green, blue, 255);
      }
      x += dx;
    }
    y += dy;
  }
  updatePixels();
  
  renderSelection();
  printZoom();
}

void renderSelection() {
  if ( selectionRect.hasRectangle() ){
     // get rect corners and render the rect.
     PVector topLeft = selectionRect.getTopLeft();
     PVector bottomRight = selectionRect.getBottomRight();
     
     rectMode(CORNERS);
     fill(255, 255, 255, 50);  
     //strokeWeight(2);
     stroke(255, 255, 255, 80);
     rect(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y);
  }
}


void setupColorMap() {
  colorMap[0]  = new PVector( 66,  30,  15);
  colorMap[1]  = new PVector( 25,   7,  26);
  colorMap[2]  = new PVector(  9,   1,  47);
  colorMap[3]  = new PVector(  4,   4,  73);
  colorMap[4]  = new PVector(  0,   7, 100);
  colorMap[5]  = new PVector( 12,  44, 138);
  colorMap[6]  = new PVector( 24,  82, 177);
  colorMap[7]  = new PVector( 57, 125, 209);
  colorMap[8]  = new PVector(134, 181, 229);
  colorMap[9]  = new PVector(211, 236, 248);
  colorMap[10] = new PVector(241, 233, 191);
  colorMap[11] = new PVector(248, 201,  95);
  colorMap[12] = new PVector(255, 170,   0);
  colorMap[13] = new PVector(204, 128,   0);
  colorMap[14] = new PVector(153,  87,   0);
  colorMap[15] = new PVector(106, 52,    3);
}

void mousePressed() {
  // We want to tell model,
  // that we start drawing a rectangle
  // that we need to use current mouse coordinates
  // as a starting point and 
  // that the model gets ready to receive more of the
  // coodinates, once mouse is dragged along the screen
  
  //map(value, start1, stop1, start2, stop2)
  float mouseXmap = map(mouseX, 0, width, xmin, xmax);
  float mouseYmap = map(mouseY, 0, height, ymin, ymax);
  
  //println("Mouse  (x, y)", mouseX, mouseY);
  //println("Mapped (x, y)", mouseXmap, mouseYmap);
  
  selectionRect.startDrawingAt(mouseX, mouseY);
}

void mouseDragged(){
   selectionRect.updateBottomRight(mouseX, mouseY);
}


void mouseReleased() {
  //map(value, start1, stop1, start2, stop2)
  float mappedXmin = map(selectionRect.mTopLeft.x, 0, width, xmin, xmax);
  float mappedYmin = map(selectionRect.mTopLeft.y, 0, height, ymin, ymax);
  float mappedXmax = map(selectionRect.mTopLeft.x + selectionRect.width(), 0, width, xmin, xmax);
  float mappedYmax = map(selectionRect.mTopLeft.y + selectionRect.width(), 0, height, ymin, ymax);
  
  selectionRect.finishDrawing();

  // Scale image based on mouse selection
  xmin = mappedXmin;
  ymin = mappedYmin;
  
  xmax = mappedXmax;
  ymax = mappedYmax;
  
  //println("xmin:", xmin, "ymin", ymin);
  //println("xmax:", xmax, "ymax:", ymax);
  
  println("ZOOM: " + round(start_scale / dist(xmin, ymin, xmax, ymax)) + "X");
}

void keyPressed() {
  // reset scale
  switch(key) { 
  case ESC: 
    key = 0;
    resetSet(SET_WIDTH);
    break;
  }
}

void resetSet(float newW) {
  println("*** RESET ***");
  // It all starts with the width, try higher or lower values
  w = newW;
  h = (w * height) / width;
  
  // Start at negative half the width and height
  xmin = -w/2;
  ymin = -h/2;
  
  // x goes from xmin to xmax
  xmax = xmin + w;
  // y goes from ymin to ymax
  ymax = ymin + h;
  
  // Set up start_scale so that zoom can be calculated
  // this is jsut the diagonal distance of the mapped 'box' that the set is drawn in
  start_scale = dist(xmin, ymin, xmax, ymax);
  
  println("ZOOM: " + round(start_scale / dist(xmin, ymin, xmax, ymax)) + "X");
  //printZoom();
}

void printZoom() {
  if (DISPLAY_ZOOM) {
    int zoom = round(start_scale / dist(xmin, ymin, xmax, ymax));
    String zoomStr = "ZOOM: " + zoom + "X";
    textSize(20);
    fill(255);
    text(zoomStr, 10, 30);
  } 
}

void printWindowRatio() {
  println("WINDOW_RATIO: ", WINDOW_RATIO);
}