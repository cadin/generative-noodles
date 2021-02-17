PVector[] createNoodlePath(int cols, int rows, PVector[] occupied){
	int len = int(random(4, 10));
		
	PVector[] path = new PVector[len];
	path[0] = new PVector(round(random(0, cols)), round(random(0, rows)));
	
	for(int i=1; i < len; i++){
		int vh = round(random(0,1));
		if(vh == 0) {
			// vertical 
			int ud = round(random(0,1));
			if(ud == 0){ud = -1;}
			path[i] = new PVector(path[i-1].x, path[i-1].y + ud);
		} else {
			// horizontal
			int lr = round(random(0,1));
			if(lr == 0){lr = -1;}
			path[i] = new PVector(path[i-1].x + lr, path[i-1].y);
		}
	}
	
	return path;
}

void drawPath(PVector[] path, int tileSize){
	fill(255, 200,200);
	stroke(255, 150, 150);
	for(int i = 0; i < path.length; i++){
		rect(path[i].x * tileSize, path[i].y * tileSize, tileSize, tileSize);
	}
}