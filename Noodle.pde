class Noodle {
	
	int margin = 0;
	int thickness = 50;
	int tileSize = 0;
	
	Point[] path;
	
	PShape head;
	
	Noodle(Point[] p, int tileW, PShape h) {
		tileSize = tileW;
		margin = (tileSize - thickness) / 2;
		head = h;
		head.disableStyle();
		path = p;
	}

	
	void drawHead(Point pos, Point neighbor) {
		pushMatrix();
		translate(tileSize / 2, tileSize/2);
		if(neighbor.x < pos.x){
			rotate(HALF_PI);
		} else if(neighbor.x > pos.x){
			rotate(-HALF_PI);
		} else if(neighbor.y < pos.y){
			rotate(PI);
		}
		shape(head, tileSize/-2 , tileSize/-2);
		popMatrix();
	}
	
	void drawNoodle() {
	
		for(int i = 0; i < path.length; i++){
			Point p = path[i];
			
			pushMatrix();
			translate(p.x * tileSize, p.y * tileSize);
			if(i == 0){
				drawHead(path[i], path[i + 1]);
			}else if( i == path.length -1){
				drawHead(path[i], path[i - 1]);
			} else {
				
				Point prev = path[i-1];
				Point next = path[i+1];
				
				boolean top = prev.y < p.y || next.y < p.y;
				boolean right = prev.x > p.x || next.x > p.x;
				boolean left = prev.x < p.x || next.x < p.x;
				boolean bottom = prev.y > p.y || next.y > p.y;
				
				if(top && bottom ){
					vertical();
				} else if(left && right){
					horizontal(1);
				} else if(left && bottom){
					cornerTR();
				} else if(top && left){
					cornerBR();
				} else if(top && right) {
					cornerBL();
				} else if(bottom && right){
					cornerTL();
				}
			}
			popMatrix();
			
			
		}
	}
	
	void draw() {
		pushMatrix();
		stroke(0);
		noFill();
		strokeWeight(3);
		
		drawNoodle();
		popMatrix();
	}
	
	void cornerTL() {
		arc(tileSize, tileSize, (thickness + margin)*2, (thickness + margin)*2, PI, PI + HALF_PI);
		arc(tileSize, tileSize, margin * 2, margin * 2, PI, PI + HALF_PI);
	}
	
	void cornerTR() {
		arc(0, tileSize, (thickness + margin)*2 , (thickness + margin)*2,-HALF_PI, 0);
		arc(0, tileSize, margin * 2, margin *2, -HALF_PI, 0);
	}
	
	void cornerBR() {
		arc(0, 0, (thickness + margin)*2, (thickness + margin)*2, 0, HALF_PI);
		arc(0, 0, margin * 2, margin * 2, 0, HALF_PI);
	}
	
	void cornerBL() {
		arc(tileSize, 0, (thickness + margin)*2, (thickness + margin)*2, HALF_PI, PI);
		arc(tileSize, 0, margin * 2, margin * 2, HALF_PI, PI);
		
	}
	
	void vertical() {
		line(margin, 0, margin, tileSize);
		line(tileSize - margin, 0, tileSize - margin, tileSize);
		
	}
	
	void horizontal( int len ) {
		int length = len * tileSize;
		
		line(0, margin, length, margin);
		line(0, tileSize - margin, length, tileSize - margin);
	}
}