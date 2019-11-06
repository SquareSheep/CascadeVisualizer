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
int currBeat;

// ---------------------------------------------


void setup() {
  size(400,400,P3D);
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

  timer = new BeatTimer(50,0,bpm);
  
  addEvents();

  song.loop();
  song.setGain(-25);

  mobs.add(newPoly("Pyramid",new PVector(0,0,0),de*0.3));
}

void draw() {
  mobs.get(0).r.P.x += 0.5;
  mobs.get(0).ang.P.x += 0.01;

  update();
  cam.render();

  background(0);

  drawBorders();
  drawWidthBox(de);
  drawPitches();
  push();
  translate(0,de*0.5,0);
  text(currBeat,0,0);
  pop();

  for (Mob mob : mobs) {
    if (mob.draw) mob.render();
  }
}

void update() {
  calcFFT();

  currTime = song.position();
  if (timer.beat) currBeat ++;

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
  for (Mob mob : mobs) {
    mob.update();
  }

  for (int i = 0 ; i < mobs.size() ; i ++) {
    if (mobs.get(i).finished) mobs.remove(i);
  }
}