/**********************************
 **** Michal Huller
 **** ketemandala - Mandala of spots
 **** On 4 Nov 2015
 **********************************/
import javax.swing.*; 
import processing.pdf.*;
import java.util.Calendar;
PImage pic;
boolean recordPDF = false;
boolean showStroke = false;
boolean showFill = true;
int trans = 120;
boolean aspect = true;
boolean wRotate = true;
boolean colorScale = true;
float giant = 1.2;
PImage myPallete;
PImage scrShot;

PVector rectSize;
PVector lastPos;
String ogiName = "";
JFileChooser fc, spotStyle; 

color bg = 0; //#98c5f7;
int fac = 16;
int numof = 50;

float turn = 0.03;
int jump = 0;
float waveFac = PI;
int oriPointx = 0;
int oriPointy = 0;
float disp = 0;
int dotSize = 3;
PShape[] sp;
PShape[] mi;

String readyImage = "";
String Folder = "spots";
boolean nekudot = false;
SpotObj[] tri;

/////// setup ///////////////
void setup() { 
  size(1200, 1000);
  rectSize = new PVector(width/2, height/2);
  lastPos = new PVector(width/2, height/2);
  smooth();
  fc = new JFileChooser();
  if (openFileAndGetImage() == 0)
    exit();
  spotStyle = new JFileChooser(); 
  background(bg);
  frameRate(10);
  shapeMode(CENTER);
  OpenNewStyle();
  initit();

  noLoop();
}

/////////////////////////////// DRAW //////////////////////////
void draw() {
  background(bg);

  for (int i=0; i < numof; i++) {
    if (tri[i] != null) {
      if (wRotate) tri[i].wRotateDraw();
      else
        tri[i].draw();
    }
  }
}
public void initit() {
  initit(0);
}

public void initit(int byMouse) {
  if (byMouse == 1) {
    lastPos.x = mouseX; //map(mouseX,0,width, 0, original.width);
    lastPos.y = mouseY; //map(mouseY,0,height, 0, original.height);
  } else {
    background(bg);
    lastPos.x = width/2;
    lastPos.y = height/2;
  }

  tri = new SpotObj[numof];
  float limtri = width/2;
  float limang = TWO_PI/fac+1;
  int i = 0;
  for (int k=numof-1; k >= 0; k--) {
    limtri = rectSize.x*float((k+1))/float(numof);
    // create an object
    int shapeNo = int(random(5000))%6;
    color fillColor = myPallete.get(int(random(0, myPallete.width)), int(random(0, myPallete.height)));
    if (colorScale) {
      fillColor = myPallete.get(int(random(1, myPallete.width)), 
        int(max(map(limtri, 1, height, 1, myPallete.height-1), 1)));
    }
    PVector p1 = new PVector(limtri, random(-limang, limang));
    tri[i] = new SpotObj(p1.x, p1.y, 
      sp[shapeNo], 
      mi[shapeNo], 
      myPallete.get(int(random(0, myPallete.width)), int(random(0, myPallete.height))), 
      fillColor, 
      fac);
    i++;
  }
}

void mouseReleased() {
  //initit(1);
  background(bg);
  redraw();
}

void mousePressed() {
  for (int i = 0; i < numof/10; i++) {
    PVector cur = new PVector(mouseX-width/2, mouseY-height/2);
    if (i % 3 == 0)
      tri[int(random(numof))].setP1(cur.mag(), cur.heading());
  }
}

void keyPressed() {
  if (key == 'n' || key == 'N') {
    initit();
    redraw();
  }

  if (key == 'v' || key == 'V') {
    OpenNewStyle();
    initit();
    redraw();
  }

  if (key == 'o' || key =='O') {
    if (openFileAndGetImage() == 0)
      exit();
    background(bg);
    initit();
    redraw();
  }

  if (key == ' ') {
    background(bg);
    initit();
    redraw();
  }

  if (key == 's' || key == 'S' || key == 'p' || key == 'P') {
    int numR = int(random(5000));
    String fname="snapshot/fl_" + year() + month() + day() + "_" + frameCount +"_" + numR + ".png";
    scrShot=get(0, 0, width, height);
    scrShot.save(fname);
  }

  if (key == 'd' || key =='D') {
    aspect = !aspect;
    background(bg);
    //initit();
    redraw();
  }
  // 1,2 how many petals
  if (key =='1') {
    fac -= 2;
    if (fac < 6) fac = 6;
    background(bg);
    for (int i=0; i < numof; i++) tri[i].setSlices(fac);
    redraw();
  }
  if (key =='2') {
    fac += 2;
    if (fac > 28) fac = 28;
    background(bg);
    for (int i=0; i < numof; i++) tri[i].setSlices(fac);
    redraw();
  }
  // 3,4 how many spots
  if (key =='3') {
    numof -= 10;
    if (numof < 3) numof = 3;
    background(bg);
    initit();
    redraw();
  }
  if (key =='4') {
    numof += 10;
    if (numof > 200) numof = 200;
    background(bg);
    initit();
    redraw();
  }
  // 5,6 change the giant scale
  if (key =='5') { // lower
    giant -= 0.1;
    if (giant < 0.5) giant = 1;
    background(bg);
    //initit();
    redraw();
  }
  if (key =='6') { // higher
    giant += 0.1;
    if (giant > 10) giant = 10;
    background(bg);
    //initit();
    redraw();
  }
  if (key == 'w' || key == 'W') {
    bg = 255-bg;
    background(bg);
    redraw();
  }
  if (key == 'l' || key == 'L') {
    showStroke = !showStroke;
    redraw();
  }
  if (key == 'f' || key == 'F') {
    showFill = !showFill;
    redraw();
  }
  if (key == 'g' || key == 'G') {
    wRotate = !wRotate;
    redraw();
  }
  if (key == 'c' || key == 'C') {
    colorScale = !colorScale;
    initit();
    redraw();
  }

  if (key == 't' || key == 'T') {
    if (trans == 120)
      trans = 180;
    else
      trans = 120;
    initit();
    redraw();
  }
}


// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}


int openFileAndGetImage() {

  int returnVal = fc.showOpenDialog(null); 

  if (returnVal == JFileChooser.APPROVE_OPTION) { 
    File file = fc.getSelectedFile(); 
    // see if it's an image 
    // (better to write a function and check for all supported extensions) 
    if (file.getName().endsWith("jpg") || file.getName().endsWith("png") 
      || file.getName().endsWith("gif") || file.getName().endsWith("jpeg") ||
      file.getName().endsWith("JPG")) { 
      // load the image using the given file path
      ogiName = file.getPath();
      myPallete = loadImage(ogiName); 
      if (myPallete != null) {
        return 1;
      } else return 0;
    }
  } 
  return 0;
}

int openStyleFile() {

  int returnVal = spotStyle.showOpenDialog(null); 

  if (returnVal == JFileChooser.APPROVE_OPTION) { 
    File file = spotStyle.getSelectedFile(); 

    if (file == null)
      return 0;
    Folder = file.getParent();
    if (Folder != null) {
      return 1;
    } else return 0;
  } 
  return 0;
}

void OpenNewStyle() {
  if (openStyleFile() == 0)
    exit();
  // init shapes
  sp = new PShape[6];
  mi = new PShape[6];
  for (int i=1; i<7; i++) {
    sp[i-1] = loadShape(Folder + "/s"+i+".svg");
    mi[i-1] = loadShape(Folder + "/m"+i+".svg");
  }
}
