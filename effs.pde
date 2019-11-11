class EffPool<T> extends ObjectPool {
	void add(float x, float y, float z, float w, float h, float d, float ax, float ay, float az, float dx, float dy, float dz, int CD, int maxSteps, int lifeSpan) {
		if (arm == ar.size()) {
			ar.add(0,new FlatEff(x,y,z, w,h,d, ax,ay,az, dx,dy,dz, CD, maxSteps, lifeSpan));
		} else {
			setEff((Eff) ar.get(arm), x,y,z, w,h,d, ax,ay,az, dx,dy,dz, CD, maxSteps, lifeSpan);
		}
		arm ++;
	}

	void add(float x, float y, float z, float w, float h, float d, float dx, float dy, float dz, int CD, int maxSteps, int lifeSpan) {
		add(x,y,z, w,h,d, 0,0,0, dx,dy,dz, CD, maxSteps, lifeSpan);
	}

	void add(float x, float y, float z, float w, float dx, float dy, float dz, int CD, int maxSteps, int lifeSpan) {
		add(x,y,z, w,w,w, 0,0,0, CD, maxSteps, lifeSpan);
	}
}

void setEff(Eff eff, float x, float y, float z, float w, float h, float d, float ax, float ay, float az, float dx, float dy, float dz, int CD, int maxSteps, int lifeSpan) {
	eff.x = x; eff.y = y; eff.z = z;
	eff.w = w; eff.h = h; eff.d = d;
	eff.ax = ax; eff.ay = ay; eff.az = az;
	eff.dx = dx; eff.dy = dy; eff.dz = dz;
	eff.step = 0;
	eff.currCD = 0;
	eff.CD = CD;
	eff.maxSteps = maxSteps;
	eff.lifeSpan = lifeSpan;
	eff.finished = false;
}

class FlatEff extends Eff {

	FlatEff(float x, float y, float z, float w, float h, float d, float ax, float ay, float az, float dx, float dy, float dz, int CD, int maxSteps, int lifeSpan) {
		setEff(this, x,y,z, w,h,d, ax,ay,az, dx,dy,dz, CD, maxSteps, lifeSpan);
	}

	FlatEff(float x, float y, float z, float w, float h, float d, float dx, float dy, float dz, int CD, int maxSteps, int lifeSpan) {
		this(x,y,z, w,h,d, 0,0,0, dx,dy,dz, CD, maxSteps, lifeSpan);
	}

	FlatEff(float x, float y, float z, float w, float dx, float dy, float dz, int CD, int maxSteps, int lifeSpan) {
		setEff(this, x,y,z, w,w,w, 0,0,0, dx,dy,dz, CD, maxSteps, lifeSpan);
	}

	void spawn() {
		boxes.add(x,y,z, w,h,d, ax,ay,az, lifeSpan);
	}
}

abstract class Eff {
	float x; float y; float z;
	float w; float h; float d;
	float ax; float ay; float az;
	float dx; float dy; float dz;
	int step;
	int currCD;
	int CD;
	int maxSteps;
	int lifeSpan;
	boolean finished;

	void update() {
		currCD ++;
		if (currCD == CD) {
			currCD = 0;
			spawn();
			increment();
			step ++;
			if (step == maxSteps) finished = true;
		}
	}

	void increment() {
		x += dx;
		y += dy;
		z += dz;
	}

	abstract void spawn();
}