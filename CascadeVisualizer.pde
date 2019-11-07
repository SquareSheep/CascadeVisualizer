import ddf.minim.analysis.*;
import ddf.minim.*;

static float bpm = 106;
static float cos60 = cos(PI/3);
static float sin60 = sin(PI/3);

Minim mim;
AudioPlayer song;
ddf.minim.analysis.FFT fft;
static int binCount = 144;
float[] av = new float[binCount];
float max;
float avg;

ArrayList<Event> events = new ArrayList<Event>();
ArrayList<Mob> mobs = new ArrayList<Mob>();
BoxPool<Box3d> boxes = new BoxPool<Box3d>();
EffPool<Eff> effs = new EffPool<Eff>();
Camera cam;

// GLOBAL ANIMATION VARIABLES -------------------

static int de; //width of screen de*2
static int aw; //Animation depth
static PVector front;
static PVector back;
static float defaultMass = 3;
static float defaultVMult = 0.3;


BeatTimer timer;
int currTime;
float currBeat;

// ---------------------------------------------


void setup() {
  size(600,600,P3D);
  de = (int)(min(width,height)*1);
  aw = (int)(4*de);
  front = new PVector(-de*2,de*1.2,de*0.4);
  back = new PVector(de*2,-de*2,-aw);

  cam = new Camera(de/2, de/2, -de*1.2);
  cam.ang.P.set(0,0,0);

  textSize(de/10);

  rectMode(CENTER);
  textAlign(CENTER);

  mim = new Minim(this);
  song = mim.loadFile("../SadMachineVisualizer/sadmachine.mp3", 1024);
  fft = new FFT(song.bufferSize(), song.sampleRate());

  timer = new BeatTimer(35,0,bpm);
  
  addEvents();

  song.loop();
  song.setGain(-25);
}

void draw() {
  if (frameCount % 15 == 0) {
    float w = de*0.15;
    effs.add(-de,random(-de,de),0, w,w,0, 0,0,0, w,0,0, 3,15,60);
    //boxes.add(random(-de,de),random(-de,de),0, w,60);
  }

  update();
  cam.render();

  background(0);

  fill(255);
  drawBorders();
  drawWidthBox(de);
  //drawPitches();
  push();
  translate(0,de*0.5,0);
  text(currBeat,0,0);
  pop();

  // for (Mob mob : mobs) {
  //   if (mob.draw) mob.render();
  // }

  for (int i = 0 ; i < boxes.arm ; i ++) {
    Mob mob = (Mob) boxes.ar.get(i);
    if (mob.draw) mob.render();
  }
}

void update() {
  calcFFT();

  currTime = song.position();
  if (timer.beat) currBeat += 0.5;

  cam.update();
  timer.update();

  updateEvents();
  updateMobs();
}

void updateEvents() {
  for (int i = 0 ; i < events.size() ; i ++) {
    Event event = events.get(i);
    if (currBeat >= event.time && currBeat < event.timeEnd) {
      if (!event.spawned) {
        event.spawned = true;
        event.spawn();
      }
      event.update();
    }
  }
}

void updateMobs() {
  // for (Mob mob : mobs) {
  //   mob.update();
  // }

  // for (int i = 0 ; i < mobs.size() ; i ++) {
  //   if (mobs.get(i).finished) mobs.remove(i);
  // }

  for (int i = 0 ; i < boxes.arm ; i ++) {
    Mob mob = (Mob) boxes.ar.get(i);
    mob.update();
  }

  for (int i = 0 ; i < boxes.arm ; i ++) {
    Mob mob = (Mob) boxes.ar.get(i);
    if (mob.finished) boxes.remove(i);
  }

  for (int i = 0 ; i < effs.arm ; i ++) {
    ((Eff)effs.ar.get(i)).update();
  }

  for (int i = 0 ; i < effs.arm ; i ++) {
    if (((Eff)effs.ar.get(i)).finished) effs.remove(i);
  }
}