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
				box.fillStyle.setM(sin(frameCount/24)*5 + 5,cos(frameCount/16)*5 + 5,sin(frameCount/35)*5 + 5, 15);
				box.fillStyle.index = i%binCount;
				box.w.index = i%binCount;
				box.w.pm.y = de*0.005;
			}
		}
	}
}

class CascadeDiamond extends Event {
	PVector p;
	float w;
	int CD;
	int currCD = 0;
	int steps = 0;
	int maxSteps;
	int lifeSpan;

	CascadeDiamond(int time, int timeEnd, PVector p, float w, int CD, int lifeSpan) {
		super(time, timeEnd);
		this.p = p;
		this.w = w;
		this.CD = CD;
		this.maxSteps = maxSteps;
		this.lifeSpan = lifeSpan;
	}

	void spawn() {
		currCD = 0; steps = 0;
	}

	void update() {
		currCD ++;
		if (currCD == CD) {
			println("spawn: " + steps);
			currCD = 0;
			steps ++;
			for (int i = 0 ; i < steps ; i ++) {
				boxes.add(p.x - w*(steps-1) + i*w, p.y - i*w, p.z, w,w,w, 0,0,0, lifeSpan);
			}
			for (int i = 0 ; i < steps ; i ++) {
				boxes.add(p.x - w*(steps-1) + i*w, p.y + i*w, p.z, w,w,w, 0,0,0, lifeSpan);
			}
			for (int i = 0 ; i < steps ; i ++) {
				boxes.add(p.x + w*(steps-1) - i*w, p.y - i*w, p.z, w,w,w, 0,0,0, lifeSpan);
			}
			for (int i = 0 ; i < steps ; i ++) {
				boxes.add(p.x + w*(steps-1) - i*w, p.y + i*w, p.z, w,w,w, 0,0,0, lifeSpan);
			}
		}
	}
}

class CascadeRowZ extends CascadeRowX {
	CascadeRowZ(int time, PVector p, PVector d, float w, int row, int CD, int maxSteps, int lifeSpan) {
		super(time, p, d, w, row, CD, maxSteps, lifeSpan);
	}

	void spawn() {
		for (float i = 0 ; i < row ; i ++) {
			effs.add(p.x,p.y,p.z - w*row/2 + i*w, 	w,w,w,	0,0,0,	d.x,d.y,d.z, CD, maxSteps, lifeSpan);
		}
	}
}

class CascadeRowY extends CascadeRowX {
	CascadeRowY(int time, PVector p, PVector d, float w, int row, int CD, int maxSteps, int lifeSpan) {
		super(time, p, d, w, row, CD, maxSteps, lifeSpan);
	}

	void spawn() {
		for (float i = 0 ; i < row ; i ++) {
			effs.add(p.x,p.y - w*row/2 + i*w,p.z, 	w,w,w,	0,0,0,	d.x,d.y,d.z, CD, maxSteps, lifeSpan);
		}
	}
}

class CascadeRowX extends Event {
	PVector p;
	PVector d;
	int row;
	float w;
	int CD;
	int maxSteps;
	int lifeSpan;

	CascadeRowX(int time, PVector p, PVector d, float w, int row, int CD, int maxSteps, int lifeSpan) {
		super(time, time+1);
		this.p = p;
		this.d = d.mult(w);
		this.row = row;
		this.w = w;
		this.CD = CD;
		this.maxSteps = maxSteps;
		this.lifeSpan = lifeSpan;
	}

	void spawn() {
		for (float i = 0 ; i < row ; i ++) {
			effs.add(p.x - w*row/2 + i*w,p.y,p.z, 	w,w,w,	0,0,0,	d.x,d.y,d.z, CD, maxSteps, lifeSpan);
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

	void spawn() {}
	
	void update() {}

	void end() {}
}