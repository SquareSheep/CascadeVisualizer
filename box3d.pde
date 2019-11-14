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
	box.p.p.set(x + sbox.p.p.x, y + sbox.p.p.y, z + sbox.p.p.z);
	box.p.P.set(x,y,z);
	box.p.v.set(sbox.p.v.x, sbox.p.v.y, sbox.p.v.z);
	box.w.p.set(sbox.w.p.x, sbox.w.p.y, sbox.w.p.z);
	box.w.P.set(w,h,d);
	box.w.v.set(sbox.w.v.x, sbox.w.v.y, sbox.w.v.z);
	box.ang.p.set(sbox.ang.p.x, sbox.ang.p.y, sbox.ang.p.z);
	box.ang.P.set(ax + sbox.ang.P.x, ay + sbox.ang.P.y, az + sbox.ang.P.z);
	box.ang.v.set(sbox.ang.v.x, sbox.ang.v.y, sbox.ang.v.z);
	box.sca.x = sbox.sca.x; box.sca.X = sbox.sca.X; box.sca.v = sbox.sca.v;
	box.fillStyle.reset(sbox.fillStyle.rc, sbox.fillStyle.gc, sbox.fillStyle.bc, sbox.fillStyle.ac, 
		sbox.fillStyle.rm, sbox.fillStyle.gm, sbox.fillStyle.bm, sbox.fillStyle.am);
	box.strokeStyle.reset(sbox.strokeStyle.rc, sbox.strokeStyle.gc, sbox.strokeStyle.bc, sbox.strokeStyle.ac, 
		sbox.strokeStyle.rm, sbox.strokeStyle.gm, sbox.strokeStyle.bm, sbox.strokeStyle.am);
	box.lifeSpan = 0;
	box.maxLifeSpan = lifeSpan;
	box.fadeSpan = lifeSpan / 5 + 10;
	box.finished = false;
	box.draw = true;
}

class Box3d extends MobF {
	Point w;
	int lifeSpan; // Measured in frames
	int maxLifeSpan;
	int fadeSpan;

	Box3d() {
		p = new Point();
		w = new Point();
		ang = new Point();}

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
		if (lifeSpan < maxLifeSpan) {
			lifeSpan ++;
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