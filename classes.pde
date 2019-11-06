/*
Points and SpringValues
- Points are 3D SpringValues
- Switch between ease in and ease out modes

Add an IPoint and ISpringValue? Similar to IColor in that it has an index to react to
Build the option in
*/

class Point {
  PVector p;
  PVector P;
  PVector v = new PVector(0,0,0);
  float vMult;
  float mass;
  boolean mode = true;

  Point(PVector p, float vMult, float mass) {
    this.p = p;
    this.P = p.copy();
    this.vMult = vMult;
    this.mass = mass;
  }

  Point() {
    this(new PVector(0,0,0), defaultVMult, defaultMass);
  }

  Point(PVector p) {
    this(p, defaultVMult, defaultMass);
  }

  Point(float x, float y, float z) {
    this(new PVector(x, y, z), defaultVMult, defaultMass);
  }

  Point(float x, float y, float z, float vMult, float mass) {
    this(new PVector(x, y, z), vMult, mass);
  }

  void update() {
    v.mult(vMult);
    if (mode) {
      v.add(PVector.sub(P,p).div(mass));
    } else {
      v.x += mass / (P.x - p.x);
      v.y += mass / (P.y - p.y);
      v.z += mass / (P.z - p.z);
    }
    p.add(v);
  }

  void move() {
    translate(p.x,p.y,p.z);
  }

  Point copy() {
    return new Point(p.copy(), vMult, mass);
  }
}

class SpringValue {
  float x;
  float X;
  float v = 0;
  float vMult;
  float mass;
  boolean mode = true;

  SpringValue(float x, float vMult, float mass) {
    this.x = x;
    this.X = x;
    this.vMult = vMult;
    this.mass = mass;
  }

  SpringValue(float x) {
    this(x, defaultVMult, defaultMass);
  }

  SpringValue() {
    this(1,defaultVMult, defaultMass);
  }

  void update() {
    v *= vMult;
    if (mode) {
      v += (X - x)/mass;
    } else {
      if (X == x) {
        v = 0;
      } else {
        v += mass/(X - x);
      }
    }
    x += v;
  }
}
// v = mass/(X-x)