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
BoxPool<Box3d> boxes = new BoxPool<Box3d>();
BoxPool<Box3d> stars = new BoxPool<Box3d>();
Camera cam;
PGraphics pg;

// GLOBAL ANIMATION VARIABLES -------------------

static int de; //width of screen de*2
static int aw; //Animation depth
static PVector front;
static PVector back;
static float defaultMass = 10;
static float defaultVMult = 0.5;

Box3d sbox;

BeatTimer timer;
int currTime;
float currBeat;

// ---------------------------------------------


void setup() {
  mim = new Minim(this);
  song = mim.loadFile("enough.mp3", 1024);
  fft = new FFT(song.bufferSize(), song.sampleRate());
  timer = new BeatTimer(50,300,bpm);

  size(1000,1000,P3D);

  de = (int)(min(width,height)*1);
  aw = (int)(4*de);
  front = new PVector(-de*2,de*1.2,de*0.4);
  back = new PVector(de*2,-de*2,-aw);

  cam = new Camera(de/2, de/2, -de*1.2);
  cam.ang.P.set(0,0,0);

  rectMode(CENTER);
  
  addEvents();

  song.loop();
  song.setGain(-25);

  sbox = new Box3d();
}

void draw() {
  cam.render();
  background(0);
  update();

  //fill(255);
  //drawBorders();
  //drawWidthBox(de);
  //drawPitches();
  // push();
  // translate(0,de*0.5,0);
  // text(currBeat,0,0);
  // text((int)frameRate,0,de*0.1);
  // //text(boxes.arm + " " + boxes.ar.size(),0,de*0.3);
  // pop();

  boxes.render();
  stars.render();
}

void update() {
  calcFFT();

  currTime = song.position();
  if (timer.beat) currBeat += 0.5;

  cam.update();
  timer.update();

  updateEvents();
  boxes.update();
  stars.update();
}

void updateEvents() {
  for (int i = 0 ; i < events.size() ; i ++) {
    Event event = events.get(i);
    if (!event.finished) {
        if (currBeat >= event.time && currBeat < event.timeEnd) {
          if (!event.spawned) {
            event.spawned = true;
            event.spawn();
          }
          event.update();
        } else if (currBeat >= event.timeEnd) {
            event.finished = true;
            event.end();
        }
    }
  }
}