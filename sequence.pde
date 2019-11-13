/*
13 fade
18-19 claps
20 kicks in
*/

void addEvents() {
	//events.add(new BoxGrid(0,13));
	int lifeSpan = 45;
	int maxSteps = 55;
	int step = 8;
	int row = 20;
	events.add(new AnimateBoxes1(10,4000));
	for (int i = 0 ; i < 25 ; i ++) {
		//events.add(new CascadeRowY(10 + i * 3, new PVector(0,de*1.3,-aw*2.3), new PVector(0,0.2,1), de*0.25, row, step, maxSteps, lifeSpan));
		events.add(new CascadeDiamond(10 + i * 2, 20 + i * 2, new PVector(0,0,-de), de*0.2, step, 15));
	}
}