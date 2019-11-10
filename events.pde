/*
Make time-independent events
E.g.,
CascadeRow(direction, time, timeEnd);
CascadeQuadrantPattern(p, ang, d, etc); // Repeat casade on the other three quadrants
BoxGrid(time, timeEnd);
LinearCameraMove(p,ang);
DisplayText(text, p, time, timeEnd);
*/

class BoxGrid extends Event {

	BoxGrid(int time, int timeEnd) {
		super(time, timeEnd);
	}

	void spawn() {
		int row = 10;
		float w = (back.x - front.x)/(float)row;
		for (int i = 0 ; i < row ; i ++) {
			for (int k = 0 ; k < row ; k ++) {
				boxes.add(front.x + w*(i + 0.5),back.y + w*(k + 0.5),0, w,w,0, 1200);
				((Box3d)boxes.getLast()).fillStyle.set(255,25,25,255,0,0,0,0,0);
			}
		}
	}

	void update() {
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