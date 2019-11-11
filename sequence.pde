/*
13 fade
18-19 claps
20 kicks in
*/

void addEvents() {
	//events.add(new BoxGrid(0,13));
	int lifeSpan = 45;
	int maxSteps = 45;
	int step = 8;
	int row = 20;
	events.add(new AnimateBoxes1(10,4000));
	for (int i = 0 ; i < 25 ; i ++) {
		events.add(new CascadeRow(10 + i * 3, new PVector(0,de*1.3,-aw), de*0.25, row, step, maxSteps, lifeSpan));
	}
}