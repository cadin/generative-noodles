// Point[] createNoodlePath(int cols, int rows, Point[] occupied){
// 	int len = int(random(4, 10));
		
// 	Point[] path = new Point[len];
// 	path[0] = new Point(round(random(0, cols)), round(random(0, rows)));
	
// 	for(int i=1; i < len; i++){
// 		int vh = round(random(0,1));
// 		if(vh == 0) {
// 			// vertical 
// 			int ud = round(random(0,1));
// 			if(ud == 0){ud = -1;}
// 			path[i] = new Point(path[i-1].x, path[i-1].y + ud);
// 		} else {
// 			// horizontal
// 			int lr = round(random(0,1));
// 			if(lr == 0){lr = -1;}
// 			path[i] = new Point(path[i-1].x + lr, path[i-1].y);
// 		}
// 	}
	
// 	return path;
// }

Point[] createNoodlePath(int[][] cells){
	int len = int(random(4, 10));
	int cols = cells.length;
	int rows = cells[0].length;
		
	Point[] path = new Point[len];
	
	int posX, posY;
	do {
		posX = floor(random(0, cells.length));
		posY = floor(random(0, cells[0].length));
	} while (cells[posX][posY] > 0);
	
	path[0] = new Point(posX, posY);
	println(path[0].x, path[0].y);
	cells[posX][posY] = 1;
	
	int count = 1;
	for(int i=1; i < len; i++){
		
		Point prev = path[count-1];
		boolean up = prev.y > 0 && cells[prev.x][prev.y - 1] < 1;
		boolean down = prev.y < rows-1 && cells[prev.x][prev.y + 1] < 1;
		boolean left = prev.x > 0 && cells[prev.x - 1][prev.y] < 1;
		boolean right = prev.x < cols-1 && cells[prev.x + 1][prev.y] < 1;
		
		
		ArrayList<String> avail = new ArrayList<String>();
		if(up) avail.add("up");
		if(down) avail.add("down");
		if(left) avail.add("left");
		if(right) avail.add("right");
		
		if(avail.size() > 0){
		int index = floor(random(0, avail.size()));
			String dir = avail.get(index);
			
			Point p = null;
			if(dir == "up") p = (new Point(prev.x, prev.y -1));
			if(dir == "down") p = (new Point(prev.x, prev.y +1));
			if(dir == "right") p = (new Point(prev.x + 1, prev.y));
			if(dir == "left") p = ( new Point(prev.x -1, prev.y));
			
			if(p != null){
				cells[p.x][p.y] = 1;
				path[count] = p;
				count++;
			}
		}
	}
	
	if(count > 1){
		return (Point[]) subset(path, 0, count);
	} else {
		return createNoodlePath(cells);
	}

}

void drawPath(Point[] path, int tileSize){
	fill(255, 200,200);
	stroke(255, 150, 150);
	for(int i = 0; i < path.length; i++){
		rect(path[i].x * tileSize, path[i].y * tileSize, tileSize, tileSize);
	}
}