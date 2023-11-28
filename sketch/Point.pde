class Point {
	int x = 0;
	int y = 0;
	int type = 0;
	int joinType = 0;
	
	Point(int _x, int _y) {
		x = _x; 
		y = _y;
	}

	@Override
  	public String toString() {
    	return "{" + x + ", " + y + "}";
  	}
}