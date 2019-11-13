class BoxPool<T> extends ObjectPool {
	void add(float px, float py, float pz, float wx, float wy, float wz, float angx, float angy, float angz, int lifeSpan) {
		if (arm == ar.size()) {
			ar.add(0,new Box3d(px,py,pz,wx,wy,wz,angx,angy,angz,lifeSpan));
		} else {
			setBox3d((Box3d) ar.get(arm), px, py, pz, wx, wy, wz,angx, angy, angz, lifeSpan);
		}
		arm ++;
	}

	void add(float px, float py, float pz, float w, float h, float d, int lifeSpan) {
		add(px,py,pz, w,h,d, 0,0,0, lifeSpan);
	}

	void add(float px, float py, float pz, float w, int lifeSpan) {
		add(px,py,pz, w,w,w, 0,0,0, lifeSpan);
	}
}

void setBox3d(Box3d box, float x, float y, float z, float w, float h, float d, float ax, float ay, float az, int lifeSpan) {
	box.p.p.set(x,y,z);
	box.p.P.set(x,y,z);
	box.p.v.set(0,0,0);
	box.w.p.set(0,0,0);
	box.w.P.set(w,h,d);
	box.w.v.set(0,0,0);
	box.ang.p.set(ax,ay,az);
	box.ang.P.set(ax,ay,az);
	box.ang.v.set(0,0,0);
	box.sca.x = 1; box.sca.X = 1; box.sca.v = 0;
	box.lifeSpan = lifeSpan;
	box.fadeSpan = lifeSpan / 5 + 10;
	box.finished = false;
	box.draw = true;
}

class Box3d extends MobF {
	Point w;
	int lifeSpan; // Measured in frames
	int fadeSpan;

	Box3d(float x, float y, float z, float w, float h, float d, float ax, float ay, float az, int lifeSpan) {
		this.p = new Point();
		this.w = new Point();
		this.ang = new Point();
		setBox3d(this, x,y,z, w,h,d, ax,ay,az, lifeSpan);
	}

	Box3d(float x, float y, float z, float w, float h, float d, int lifeSpan) {
		this(x,y,z,w,h,d,0,0,0,lifeSpan);
	}

	Box3d(float x, float y, float z, float w, int lifeSpan) {
		this(x,y,z,w,w,w,0,0,0,lifeSpan);
	}

	void update() {
		if (lifeSpan > 0) {
			lifeSpan --;
		} else {
			w.P.x -= w.P.x /fadeSpan;
			w.P.y -= w.P.y /fadeSpan;
			w.P.z -= w.P.z /fadeSpan;
			fadeSpan --;
			if (fadeSpan == 0) finished = true;
		}
		updatePoints();
		w.update();
	}

	void render() {
		setDraw();
		if (w.p.z > 2) {
			box(w.p.x, w.p.y, w.p.z);
		} else {
			rect(0,0, w.p.x, w.p.y);
		}
		pop();
	}
}