class Point {
  PVector p;
  PVector P;
  PVector pm = new PVector(0,0,0);
  PVector v = new PVector(0,0,0);
  float vMult;
  float mass;
  int index;

  Point(PVector p, float vMult, float mass) {
    this.p = p;
    this.P = p.copy();
    this.vMult = vMult;
    this.mass = mass;
    this.index = -1;
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
    if (index != -1) {
      v.x += (P.x + pm.x * av[index] - p.x) / mass;
      v.y += (P.y + pm.y * av[index] - p.y) / mass;
      v.z += (P.z + pm.z * av[index] - p.z) / mass;
    } else {
      v.add(PVector.sub(P,p).div(mass));
    }
    p.add(v);
  }

  Point copy() {
    return new Point(p.copy(), vMult, mass);
  }
}

class SpringValue {
  float x;
  float X;
  float xm = 0;
  float v = 0;
  float vMult;
  float mass;
  int index = -1;

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
    if (index != -1) {
      v += (X + xm - x)/mass;
    } else {
      v += (X - x)/mass;
    }
    x += v;
  }
}
// v = mass/(X-x)