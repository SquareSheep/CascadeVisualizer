/*
Make time-independent events
E.g.,
CascadeRow(direction, time, timeEnd);
CascadeQuadrantPattern(p, ang, d, etc); // Repeat casade on the other three quadrants
BoxGrid(time, timeEnd);
LinearCameraMove(p,ang);
DisplayText(text, p, time, timeEnd);
*/
class AnimateBoxes1 extends Event {
	AnimateBoxes1(int time, int timeEnd) {
		super(time, timeEnd);
	}

	void update() {
		if (frameCount % 15 == 0) {
			for (int i = 0 ; i < boxes.arm ; i ++) {
				Box3d box = (Box3d)boxes.ar.get(i);
				box.fillStyle.setM(sin(frameCount/24)*7 + 15,cos(frameCount/16)*7 + 15,sin(frameCount/35)*7 + 15, 0);
				box.fillStyle.index = i%binCount;
				box.w.index = i%binCount;
				box.w.pm.y = de*0.005;
			}
		}
	}
}

class CascadeRow extends Event {
	PVector p;
	int row;
	float w;
	int CD;
	int maxSteps;
	int lifeSpan;

	CascadeRow(int time, PVector p, float w, int row, int CD, int maxSteps, int lifeSpan) {
		super(time, time+1);
		this.p = p;
		this.row = row;
		this.w = w;
		this.CD = CD;
		this.maxSteps = maxSteps;
		this.lifeSpan = lifeSpan;
	}

	void spawn() {
		for (float i = 0 ; i < row ; i ++) {
			effs.add(p.x - w*row/2 + i*w,p.y,p.z, 	w,w,w,	0,0,0,	0,0,w, CD, maxSteps, lifeSpan);
			println(effs.getLast());
		}
	}
}

class BoxGrid extends Event {

	ArrayList<Box3d> ar = new ArrayList<Box3d>();
	int fadeSpan;
	int row;
	PVector p;

	BoxGrid(int time, int timeEnd, PVector p, int row, int fadeSpan) {
		super(time, timeEnd);
		this.p = p;
		this.row = row;
		this.fadeSpan = fadeSpan;
	}

	BoxGrid(int time, int timeEnd) {
		this(time, timeEnd, new PVector(0,0,0), (int)sqrt(binCount), 30);
	}

	void spawn() {
		int row = 10;
		float w = (back.x - front.x)/(float)row;
		for (int i = 0 ; i < row ; i ++) {
			for (int k = 0 ; k < row ; k ++) {
				boxes.add(front.x + w*(i + 0.5),back.y + w*(k + 0.5),0, w,w,0, 1000000);
				ar.add((Box3d)boxes.getLast());
			}
		}
	}

	void end() {
		for (int i = 0 ; i < ar.size() ; i ++) {
			Box3d box = ar.get(i);
			box.lifeSpan = 0;
			box.fadeSpan = fadeSpan;
		}
	}
}

class Event {
	boolean finished = false;
	boolean spawned = false;
	int time;
	int timeEnd;

	Event() {}

	Event(int time, int timeEnd) {
		this.time = time;
		this.timeEnd = timeEnd;
	}

	void spawn() {

	}
	
	void update() {

	}

	void end() {
		
	}
}