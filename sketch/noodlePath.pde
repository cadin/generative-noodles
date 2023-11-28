int NUM_JOIN_TYPES = 5;

boolean cellIsEmpty(int px, int py) {
	return cells[px][py] == CellType.EMPTY;
}

boolean cellIsInBounds(Point p) {
	boolean overMin = p.x >= 0 && p.y >= 0; 
	boolean underMax = p.x < cells.length && p.y < cells[0].length;

	return overMin && underMax;
}

boolean canCrossCell(Point prev, String dir) {
	if(!allowOverlap) return false;

	boolean result = false;

	int perpCellType = -1;
	Point nextCell = null;
	Point afterCell = null;
	switch (dir) {
		case "up":
			perpCellType = CellType.HORIZONTAL;
			nextCell = new Point(prev.x, prev.y - 1);
			afterCell = new Point(prev.x, prev.y - 2);
		break;
		case "down":
			perpCellType = CellType.HORIZONTAL;
			nextCell = new Point(prev.x, prev.y + 1);
			afterCell = new Point(prev.x, prev.y + 2);
		break;

		case "left":
			perpCellType = CellType.VERTICAL;
			nextCell = new Point(prev.x - 1, prev.y);
			afterCell = new Point(prev.x - 2, prev.y);
		break;

		case "right": 
			perpCellType = CellType.VERTICAL;
			nextCell = new Point(prev.x + 1, prev.y);
			afterCell = new Point(prev.x + 2, prev.y);
		break;

	}

	if(nextCell != null && cellIsInBounds(nextCell) && cellIsInBounds(afterCell)){
		
		if(cells[nextCell.x][nextCell.y] == perpCellType){
			if(cells[afterCell.x][afterCell.y] == CellType.EMPTY) {
				result = true;
			}
		}
	}

	return result;
}

void markCellTypeWithPathAndIndex(Point[] path, int i) {
	Point current = path[i];
	if(cells != null && current != null){
		if(i > 1){ 
			Point prev = path[i - 1];
			Point twoBack = path[i-2];

			if(twoBack.x == current.x){
				cells[prev.x][prev.y] = CellType.VERTICAL;
			} else if(twoBack.y == current.y){
				cells[prev.x][prev.y] = CellType.HORIZONTAL;
			}
		} 
	
		cells[current.x][current.y] = CellType.OCCUPIED;
	}
}

boolean addCrossAtCell(Point cell, String dir) {
	int noodleNum = findNoodleWithCell(cell.x, cell.y);
	if(noodleNum >= 0){
		Noodle n = noodles[noodleNum];
		addCrossToPathAtCell(cell, n.path, dir);
		return true;
	}
	return false;
}

void addCrossToPathAtCell(Point cell, Point[] path, String dir){
	int index = getIndexOfCell(cell.x, cell.y, path);
	if(dir == "up" || dir == "down" ){
		path[index].type = CellType.H_CROSSED;
	}else {
		path[index].type = CellType.V_CROSSED;
	}
}

Point findStartPoint(int[][] cells) {
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

	return new Point(posX, posY);
}

ArrayList<String> findAvailableDirections(Point prev, boolean isLastCell) {
	int cols = cells.length;
	int rows = cells[0].length;

	boolean up = prev.y > 0 && (cellIsEmpty(prev.x, prev.y - 1) || (!isLastCell && canCrossCell(prev, "up")));
	boolean down = prev.y < rows-1 && (cellIsEmpty(prev.x, prev.y + 1) || (!isLastCell && canCrossCell(prev, "down")));
	boolean left = prev.x > 0 && (cellIsEmpty(prev.x - 1, prev.y) || (!isLastCell && canCrossCell(prev, "left")));
	boolean right = prev.x < cols-1 && (cellIsEmpty(prev.x + 1, prev.y) || (!isLastCell && canCrossCell(prev, "right" )));
	
	ArrayList<String> avail = new ArrayList<String>();
	if(up) avail.add("up");
	if(down) avail.add("down");
	if(left) avail.add("left");
	if(right) avail.add("right");

	return avail;
}

Point getNextPointForDirection(Point prev, String dir) {
	Point p = null;
	if(dir == "up") p = (new Point(prev.x, prev.y -1));
	if(dir == "down") p = (new Point(prev.x, prev.y +1));
	if(dir == "right") p = (new Point(prev.x + 1, prev.y));
	if(dir == "left") p = ( new Point(prev.x -1, prev.y));
	return p;
}

Point[] createNoodlePath(int[][] cells){	
	int len =  int(random(minLength, maxLength));
	Point[] path = new Point[len];
	
	Point start = findStartPoint(cells);
	if(start == null) return null;

	path[0] = start;
	cells[start.x][start.y] = CellType.OCCUPIED;
	
	int count = 1;
	for(int i=1; i < len; i++){
		
		Point prev = path[count-1];
		ArrayList<String> avail = findAvailableDirections(prev, i == len -1);
		
		if(avail.size() > 0){
			int index = floor(random(0, avail.size()));
			String dir = avail.get(index);

			Point p = getNextPointForDirection(prev, dir);
			if(p != null){
				if(!cellIsEmpty(p.x, p.y)) {
					boolean didAdd = addCrossAtCell(p, dir);
					if(!didAdd) {
						addCrossToPathAtCell(p, path, dir);
					}
				}

				p.joinType = floor(random(0, NUM_JOIN_TYPES));
				p.type = CellType.OCCUPIED;		
				path[count] = p;
				markCellTypeWithPathAndIndex(path, count);
				count++;
			}
		}
	}
	
	if(count > 2){
		Point[] finalPath = (Point[]) subset(path, 0, count);
		return finalPath;
	} else {
		clearCells(cells, (Point[]) subset(path, 0, count));
		return null;
	}

}

void clearCells(int[][] cells, Point[] path){
	for(int i=0; i< path.length; i++){
		Point p = path[i];
		cells[p.x][p.y] = CellType.EMPTY;
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

boolean cellIsEndOfPath(int x, int y, Point[] path){
	Point first = path[0];
	Point last = path[path.length - 1];
	
	return ((first.x == x && first.y == y) || (last.x == x && last.y == y));
}

int getIndexOfCell(int x, int y, Point[] path){
	if(path == null) return -1;
	for(int i = 0; i < path.length; i++){
		if(path[i] != null && path[i].x == x && path[i].y == y){
			return i;
		}
	}
	
	return -1;
}

Point[] cycleCellType(int x, int y, Point[] path){
	int i = getIndexOfCell(x, y, path);
	path[i].joinType++;
	if(path[i].joinType >= NUM_JOIN_TYPES){
		path[i].joinType = 0;
	}
	
	return path;
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
		if(n != null && n.path != null){
			for(Point p : n.path){
				if(p.x == cellX && p.y == cellY){
					return index;
				}
			}
		}
		index++;
	}

	return -1;
}