class Lyrics extends Event {
	IColor fillStyle = new IColor(255,255,255,255, 0,0,0,0, -1);
	IColor strokeStyle = new IColor(255,255,255,255, 0,0,0,0, -1);
	Point p;
	String string;

	Lyrics(float time, float timeEnd, String string, PVector p) {
		super(time, timeEnd);
		this.string = string;
		this.p = new Point(p);
	}

	void update() {
		p.update();
		pg.beginDraw();
		pg.background(125);
		pg.fill(255);
		pg.text(string,200,200);
		pg.endDraw();
	}
}

class BoxesFluidDeath extends Event {
	float x;
	BoxesFluidDeath(float time, float timeEnd, float magnitude) {
		this.time = time;
		this.timeEnd = timeEnd;
		this.x = magnitude;
	}

	void update() {
		if (frameCount % 5 == 0) {
			for (int i = 0 ; i < boxes.arm ; i ++) {
				Box3d box = (Box3d) boxes.ar.get(i);
				if (box.maxLifeSpan - box.lifeSpan < 30) {
					box.p.P.x += random(-box.w.p.x, box.w.p.x)*x;
					box.p.P.y += random(-box.w.p.y, box.w.p.y)*x;
					box.p.P.z += random(-box.w.p.z, box.w.p.z)*x;
					box.ang.P.z += random(-0.5,0.5)*x;
				}
			}
		}
	}
}

class BoxesFillStyleM extends BoxesFillStyleC {
	BoxesFillStyleM(float time, float timeEnd, float r, float g, float b, float a) {
		super(time, timeEnd, r,g,b,a);
	}

	void spawn() {
		sbox.fillStyle.setM(r,g,b,a);
		for (int i = 0 ; i < boxes.ar.size() ; i ++) {
			Box3d box = (Box3d) boxes.ar.get(i);
			box.fillStyle.setM(r,g,b,a);
		}
	}

	void update() {
		if (frameCount % 5 == 0) {
			for (int i = 0 ; i < boxes.ar.size() ; i ++) {
				Box3d box = (Box3d) boxes.ar.get(i);
				box.fillStyle.index = i%binCount;
			}
		}
	}
}

class BoxesFillStyleC extends Event {
	float r; float g; float b; float a;
	BoxesFillStyleC(float time, float timeEnd, float r, float g, float b, float a) {
		super(time, timeEnd);
		this.r = r; this.g = g; this.b = b; this.a = a;
	}

	void spawn() {
		println("fillC");
		sbox.fillStyle.setC(r,g,b,a);
		for (int i = 0 ; i < boxes.ar.size() ; i ++) {
			Box3d box = (Box3d) boxes.ar.get(i);
			box.fillStyle.setC(r,g,b,a);
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

	PVector dp;

	CascadeDiamond(float time, PVector p, float w, int CD, int maxSteps, int lifeSpan) {
		super(time, time+((float)3600/CD/bpm+1));
		this.dp = p;
		this.w = w;
		this.CD = CD;
		this.maxSteps = maxSteps;
		this.lifeSpan = lifeSpan;
	}

	void spawn() {
		currCD = 0; steps = 0; p = dp.copy();
	}

	void update() {
		currCD ++;
		if (currCD == CD) {
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
			if (steps == maxSteps) finished = true;
		}
	}
}

void addRowX(float time, PVector p, float w, int row, int CD, int maxSteps, int lifeSpan) {
	events.add(new CascadeRow(time, p, new PVector(1,0,0), new PVector(0,0,1), new PVector(w,w,w), row, CD, maxSteps, lifeSpan));
}

void addRowY(float time, PVector p, float w, int row, int CD, int maxSteps, int lifeSpan) {
	events.add(new CascadeRow(time, p, new PVector(0,1,0), new PVector(0,0,1), new PVector(w,w,w), row, CD, maxSteps, lifeSpan));
}

class CascadeRow extends Event {
	PVector p;
	PVector dp;
	PVector d1; //Distance between boxes in the same row
	PVector d2;	//How much the row is incremented by between rows
	int row;
	PVector w;
	int CD;
	int maxSteps;
	int currCD;
	int step;
	int lifeSpan;

	CascadeRow(float time, PVector p, PVector d1, PVector d2, PVector w, int row, int CD, int maxSteps, int lifeSpan) {
		super(time, time+((float)3600/CD/bpm+1)); //1thing/CDframes * 60frames/1sec * 60sec/1min * 1/bpm
		this.dp = p;
		this.w = w;
		this.d1 = d1; this.d2 = d2;
		this.d1.x *= w.x; this.d1.y *= w.y; this.d1.z *= w.z;
		this.d2.x *= w.x; this.d2.y *= w.y; this.d2.z *= w.z;
		this.row = row;
		this.currCD = 0;
		this.CD = CD;
		this.step = 0;
		this.maxSteps = maxSteps;
		this.lifeSpan = lifeSpan;
	}

	void spawn() {
		step = 0; currCD = 0; p = dp.copy();
	}

	void update() {
		currCD ++;
		if (currCD == CD) {
			currCD = 0;
			for (int i = 0 ; i < row ; i ++) {
				boxes.add(p.x +d1.x*i - d1.x*row/2, p.y + d1.y*i - d1.y*row/2, p.z + d1.z*i - d1.z*row/2, w.x,w.y,w.z, 0,0,0, lifeSpan);
			}
			p.add(d2);
			step ++;
			if (step == maxSteps) finished = true;
		}
	}
}

class BoxGrid extends Event {
	int fadeSpan;
	int row;
	float w;
	PVector p;

	BoxGrid(float time, float timeEnd, PVector p, float w, int row, int fadeSpan) {
		super(time, timeEnd);
		this.p = p;
		this.row = row;
		this.w = w;
		this.fadeSpan = fadeSpan;
	}

	BoxGrid(float time, float timeEnd) {
		this(time, timeEnd, new PVector(0,0,0), front.x*2/sqrt(binCount), (int)sqrt(binCount), 30);
	}

	void spawn() {
		for (int i = 0 ; i < row ; i ++) {
			for (int k = 0 ; k < row ; k ++) {
				boxes.add(p.x + w*(i + 0.5) - w*row/2, p.y + w*(k + 0.5) - w*row/2,0, w,w,0, (int)((timeEnd - time)/bpm*3600));
			}
		}
	}
}

class Event {
	boolean finished = false;
	boolean spawned = false;
	float time;
	float timeEnd;

	Event() {}

	Event(float time, float timeEnd) {
		this.time = time;
		this.timeEnd = timeEnd;
	}

	void spawn() {}
	
	void update() {}

	void end() {}
}