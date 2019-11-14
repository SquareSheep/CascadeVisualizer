/*
3.5 First note
13 fade
18-19 claps
20 kicks in
51 claps
52 lyrics start
*/

void addEvents() {
	//events.add(new BoxesFluidDeath(0,40000,0.1));

	//Intro section

	//events.add(new Lyrics(0,100,"Bitch", new PVector(0,0,-de)));

	events.add(new BoxesFillStyleC(0,20, 25,125,25,255));
	events.add(new BoxesFillStyleM(0,20, 5,5,10,0));
	float z = back.z;
	float w = de*0.25; int CD = 2; int row = 4; int maxSteps = 30; int lifeSpan = 20;
	//addRowX(4, new PVector(0, front.y, z), w, row, CD, maxSteps,lifeSpan);
	addRowX(6.5, new PVector(0,back.y,z), w, row, CD, maxSteps,lifeSpan);
	addRowY(7, new PVector(front.x,0,z), w, row, CD, maxSteps,lifeSpan);
	addRowY(7.5, new PVector(back.x, 0,z), w, row, CD, maxSteps,lifeSpan);
	addRowX(8.5, new PVector(0,back.y,z), w, row, CD, maxSteps,lifeSpan);
	addRowY(9, new PVector(front.x,0,z), w, row, CD, maxSteps,lifeSpan);
	addRowX(10, new PVector(0,back.y,z), w, row, CD, maxSteps,lifeSpan);
	addRowY(10.5, new PVector(back.x,0,z), w, row, CD, maxSteps,lifeSpan);
	addRowX(11, new PVector(0,front.y,z), w, row, CD, maxSteps,lifeSpan);
	addRowX(11.5, new PVector(0,front.y,z), w, 20, 5,40,30);
	events.add(new CascadeDiamond(12, new PVector(0,0,-aw), w, 10,15,120));

	//Claps

	events.add(new BoxesFillStyleC(20,61, 25,25,125,255));
	events.add(new BoxesFillStyleM(20,61, 10,5,5,0));

	events.add(new CascadeDiamond(20, new PVector(0,0,-aw), de*0.2, 2,10,60));
	addRowY(20, new PVector(front.x, 0,-aw), de*0.2,10, 2,40,30);
	addRowY(20, new PVector(back.x, 0,-aw), de*0.2,10, 2,40,30);

	for (int i = 0 ; i < 31 ; i ++) {
		addRowX(20.5 + i, new PVector(0, front.y,back.z), w, (int)(back.x*2.5/w), 3, 30,15);
	}

	//Claps
	events.add(new BoxGrid(51,53, new PVector(0,0,front.z), de*0.2,12,10));

	//Lyrics start
}