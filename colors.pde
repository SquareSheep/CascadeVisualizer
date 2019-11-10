class IColor extends AColor {
  float rm;
  float gm;
  float bm;
  float am;
  int rc;
  int gc;
  int bc;
  int ac;
  int index;
  int rup = 1;
  int gup = 1;
  int bup = 1;

  IColor(float rc, float gc, float bc, float ac, float rm, float gm, float bm, float am, float index) {
  	super(rc, gc, bc, ac);
  	this.rm = rm; this.gm = gm; this.bm = bm; this.am = am;
  	this.rc = (int)rc; this.gc = (int)gc; this.bc = (int)bc; this.ac = (int)ac;
  	this.index = (int)index;
  }

  IColor(float rc, float gc, float bc, float ac) {
  	this(rc,gc,bc,ac, 0,0,0,0, 0);
  }

  IColor() {
    this(125,125,125,125, 125,125,125,125, -1);
  }

  void update() {
    if (index != -1) {
      r.X = rm * av[index] + rc;
      g.X = gm * av[index] + gc;
      b.X = bm * av[index] + bc;
      a.X = am * av[index] + ac;
    }
    r.update();
    g.update();
    b.update();
    a.update();
  }

  void setM(float rm, float gm, float bm, float am) {
  	this.rm = rm;
  	this.gm = gm;
  	this.bm = bm;
  	this.am = am;
  }

  void setC(float rc, float gc, float bc, float ac) {
  	this.rc = (int)rc;
  	this.gc = (int)gc;
  	this.bc = (int)bc;
  	this.ac = (int)ac;
  }

  void set(float rc, float gc, float bc, float ac, float rm, float gm, float bm, float am, int index) {
    setC(rc,gc,bc,ac);
    setM(rm,gm,bm,am);
    this.index = index;
  }

  void set(float rc, float gc, float bc, float ac, float rm, float gm, float bm, float am) {
    set(rc,gc,bc,ac,rm,gm,bm,am,index);
  }
}

class AColor {
  SpringValue r;
  SpringValue g;
  SpringValue b;
  SpringValue a;
  AColor(float R, float G, float B, float A, float vMult, float mass) {
    this.r = new SpringValue(R, vMult, mass);
    this.g = new SpringValue(G, vMult, mass);
    this.b = new SpringValue(B, vMult, mass);
    this.a = new SpringValue(A, vMult, mass);
  }

  AColor(float R, float G, float B, float A) {
    this(R, G, B, A, defaultVMult, defaultMass);
  }

  AColor copy() {
    return new AColor(r.X, g.X, b.X, a.X, r.vMult, r.mass);
  }
  void update() {
    r.update();
    g.update();
    b.update();
    a.update();
  }

  void fillStyle() {
    fill(r.x, g.x, b.x, a.x);
  }

  void strokeStyle() {
    stroke(r.x, g.x, b.x, a.x);
  }

  void addx(AColor other) {
    this.r.x += other.r.x;
    this.g.x += other.g.x;
    this.b.x += other.b.x;
    this.a.x += other.a.x;
  }

  void addX(AColor other) {
    this.r.X += other.r.X;
    this.g.X += other.g.X;
    this.b.X += other.b.X;
    this.a.X += other.a.X;
  }

  void setx(float r, float g, float b, float a) {
    this.r.x = r;
    this.g.x = g;
    this.b.x = b;
    this.a.x = a;
  }

  void setX(float r, float g, float b, float a) {
    this.r.X = r;
    this.g.X = g;
    this.b.X = b;
    this.a.X = a;
  }

  void setMass(float mass) {
    this.r.mass = mass;
    this.g.mass = mass;
    this.b.mass = mass;
    this.a.mass = mass;
  }

  void setVMult(float vMult) {
    this.r.vMult = vMult;
    this.g.vMult = vMult;
    this.b.vMult = vMult;
    this.a.vMult = vMult;
  }

  void addx(float R, float G, float B, float A) {
    this.r.x += R;
    this.g.x += G;
    this.b.x += B;
    this.a.x += A;
  }
}