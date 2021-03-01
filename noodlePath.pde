Point[] createNoodlePath(int[][] cells){
	int minLength = 20;
	int maxLength = 200;
	
	int len = int(random(minLength, maxLength));
	int cols = cells.length;
	int rows = cells[0].length;
		
	Point[] path = new Point[len];
	
	int posX, posY;
	int numTries = 0;
	do {
		posX = floor(random(0, cells.length));
		posY = floor(random(0, cells[0].length));
		numTries++;

		if(numTries > 200){
			return null;
		}
	} while (cells[posX][posY] > 0);

	path[0] = new Point(posX, posY);
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
				p.type = floor(random(0, 5));
				cells[p.x][p.y] = 1;
				path[count] = p;
				count++;
			}
		}
	}
	
	if(count > 2){
		return (Point[]) subset(path, 0, count);
	} else {
		clearCells(cells, (Point[]) subset(path, 0, count));
		// return createNoodlePath(cells);
		return null;
	}

}

void clearCells(int[][] cells, Point[] path){
	for(int i=0; i< path.length; i++){
		Point p = path[i];
		cells[p.x][p.y] = 0;
	}
}

void drawPath(Point[] path, int tileSize){
	fill(255, 200,200);
	stroke(255, 150, 150);
	for(int i = 0; i < path.length; i++){
		rect(path[i].x * tileSize, path[i].y * tileSize, tileSize, tileSize);
	}
}

Point getCellForMouse( int mX, int mY){
	int cellX = (mouseX - canvasX - PRINT_X) / TILE_SIZE;
	int cellY = (mouseY - canvasY - PRINT_Y) / TILE_SIZE;

	return new Point(cellX, cellY);
}

boolean cellsAreAdjacent(int c1X, int c1Y, int c2X, int c2Y){
	return (
		(c1X == c2X && abs(c1Y - c2Y) == 1) || 
		(c1Y == c2Y && abs(c1X - c2X) == 1)
	);
}

Point[] addCellToPath(int cellX, int cellY, Point[] path){
	Point[] newPath = new Point[path.length + 1];
	Point first = path[0];
	Point last = path[path.length - 1];

	int fillIndex = 0;
	if(cellsAreAdjacent(first.x, first.y, cellX, cellY) ){
		newPath[0] = new Point(cellX, cellY);
		fillIndex = 1;
	} else if(cellsAreAdjacent(last.x, last.y, cellX, cellY)){
		newPath[path.length] = new Point(cellX, cellY);
	} else {
		return path;
	}

	for(Point p : path){
		newPath[fillIndex] = p;
		fillIndex++;
	}
	return newPath;
}

Point[] removeCellFromPath(int cellX, int cellY, Point[] path) {
	Point[] newPath;
	if(path[0].x == cellX && path[0].y == cellY){
		newPath = java.util.Arrays.copyOfRange(path, 1, path.length);
		return newPath;
	} else if (path[path.length - 1].x == cellX && path[path.length - 1].y == cellY){
		newPath = java.util.Arrays.copyOfRange(path, 0, path.length-1);
		return newPath;
	} else {
		return path;
	}
	
}

int findNoodleWithCell(int cellX, int cellY) {
	int index = 0;
	for(Noodle n : noodles){
		for(Point p : n.path){
			if(p.x == cellX && p.y == cellY){
				return index;
			}
		}
		index++;
	}

	return -1;
}