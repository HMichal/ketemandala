class SpotObj {
  // points have two values: Magnitude, Direction
  PVector p1;
  PShape spoti;
  PShape mir;
  color linec;
  color fillc;
  float slices;

  SpotObj(float p1m, float p1d, 
    PShape s1, PShape s2, 
    color l, color f, float s) {
    p1 = new PVector (p1m, p1d);
    spoti = new PShape();
    mir = new PShape();
    spoti = s1;
    mir = s2;
    spoti.disableStyle();
    mir.disableStyle();
    linec = l;
    fillc = f;
    slices = s;
  }

  void draw() {
    int peradius = fac;
    float sl = slices;
    fill(fillc, trans);

    if (showStroke) {
      stroke(fillc, 150); //linec
    } else {
      noStroke();
    }

    if (showFill) {
      fill(fillc, trans);
    } else {
      stroke(fillc, 220);
      noFill();
    }

    PVector scl = new PVector(0,0);
    scl.x = giant*map(p1.x, 0.0, min(rectSize.x, rectSize.y), 
      float(min(width, height))/32.0, float(min(width, height))/8.0);
    scl.y = scl.x;
    if (aspect) scl.y = scl.x *spoti.height/spoti.width;
    float ang = p1.y;
    float mirang = TWO_PI/sl -p1.y;

    for (int i=0; i < peradius; i++) {
      if (i % 2 == 1) { //mirror
        shape(mir, lastPos.x + p1.x*cos(mirang + i*TWO_PI/sl), 
          lastPos.y + p1.x*sin(mirang + i*TWO_PI/sl), scl.x, scl.y);
      } else {
        shape(spoti, lastPos.x + p1.x*cos(ang + i*TWO_PI/sl), 
          lastPos.y + p1.x*sin(ang + i*TWO_PI/sl), scl.x, scl.y);
      }
    }
  }
   void wRotateDraw() {
    float sl = slices;

    fill(fillc, trans);

    if (showStroke) {
      stroke(fillc, 150); //linec
    } else {
      noStroke();
    }

    if (showFill) {
      fill(fillc, trans);
    } else {
      stroke(fillc, 220);
      noFill();
    }

    PVector scl = new PVector(0,0);
    scl.x = giant*map(p1.x, 0.0, min(rectSize.x, rectSize.y), 
      float(min(width, height))/32.0, float(min(width, height))/8.0);
    scl.y = scl.x;
    if (aspect) scl.y = scl.x *spoti.height/spoti.width;
    float ang = p1.y;
    float mirang = TWO_PI/sl -p1.y;
    pushMatrix();
    translate(lastPos.x, lastPos.y);
    
    for (int i=0; i < sl; i++) {
      if (i % 2 == 1) { // mirror
        pushMatrix();
        rotate (mirang);
        shape(mir, 0, 
          p1.x, scl.x, scl.y);
          popMatrix();
      }
      else {
        pushMatrix();
        rotate (ang);
        shape(spoti, 0, 
          p1.x, scl.x, scl.y);
        popMatrix();
      }
      rotate(TWO_PI/sl);
    }
    popMatrix();
   }

  void setSlices(float s) {
    slices = s;
  }

  void setP1(float mag, float dir) {
    p1.setMag(mag/2);  
    p1.rotate(map(dir, 0, TWO_PI, 0, TWO_PI/slices +0.5));
  }
}
