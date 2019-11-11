abstract class ObjectPool<T> {
	int arm;
	ArrayList<T> ar;

	ObjectPool() {
		arm = 0;
		ar = new ArrayList<T>();
	}

	//Must also implement void add();

	void remove(int i) {
		ar.add(ar.remove(i));
		arm --;
	}

	T get(int i) {
		return ar.get(i);
	}

	T getLast() {
		return ar.get(0);
	}
}

abstract class MobF extends Mob {
	IColor fillStyle = new IColor();
	IColor strokeStyle = new IColor();

	void updatePoints() {
		p.update();
		r.update();
		ang.update();
		sca.update();
		fillStyle.update();
		strokeStyle.update();
	}

	void setDraw() {
		push();
		fillStyle.fillStyle();
		strokeStyle.strokeStyle();
		translate(p.p.x, p.p.y, p.p.z);
		rotateX(ang.p.x);
		rotateY(ang.p.y);
		rotateZ(ang.p.z);
		if (r.p.x != 0) translate(r.p.x,0,0);
		if (r.p.y != 0) translate(0,r.p.y,0);
		if (r.p.z != 0) translate(0,0,r.p.z);
		scale(sca.x);
	}
}

abstract class Mob {
	boolean finished = false;
	boolean draw = true;
	Point p;
	Point r = new Point(0,0,0);
	SpringValue sca = new SpringValue(1);
	Point ang;
	
	void updatePoints() {
		p.update();
		r.update();
		ang.update();
		sca.update();
	}

	void setDraw() {
		push();
		translate(p.p.x, p.p.y, p.p.z);
		rotateX(ang.p.x);
		rotateY(ang.p.y);
		rotateZ(ang.p.z);
		if (r.p.x != 0) translate(r.p.x,0,0);
		if (r.p.y != 0) translate(0,r.p.y,0);
		if (r.p.z != 0) translate(0,0,r.p.z);
		scale(sca.x);
	}

	void update() {
		updatePoints();
	}

	abstract void render();
}