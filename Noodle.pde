class Noodle {
	
	int margin = 0;
	int thickness = 80;
	int tileSize = 0;
	
	PVector path[];
	
	PShape head;
	
	Noodle(int tileW, PShape h) {
		tileSize = tileW;
		margin = (tileSize - thickness) / 2;
		head = h;
		head.disableStyle();
		
		choosePath();
	}
	
	void choosePath() {
		int len = int(random(4, 10));
		
		path = new PVector[len];
		path[0] = new PVector(1, 1);
		
		for(int i=1; i < len; i++){
			int vh = round(random(0,1));
			if(vh == 0) {
				// vertical 
				path[i] = new PVector(path[i-1].x, path[i-1].y + 1);
			} else {
				// horizontal
				path[i] = new PVector(path[i-1].x + 1, path[i-1].y);
			}
		}
	}
	
	void drawPath() {
		fill(255, 200,200);
		stroke(255, 150, 150);
		for(int i = 0; i < path.length; i++){
			rect(path[i].x * tileSize, path[i].y * tileSize, tileSize, tileSize);
			println(path[i].x, path[i].y);
		}
	}
	
	void drawHead(PVector pos, PVector neighbor) {
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
			PVector p = path[i];
			
			
			
			
			pushMatrix();
			translate(p.x * tileSize, p.y * tileSize);
			if(i == 0){
				drawHead(path[i], path[i + 1]);
			}else if( i == path.length -1){
				drawHead(path[i], path[i - 1]);
			} else {
				
				PVector prev = path[i-1];
				PVector next = path[i+1];
				
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
	
	void draw(boolean showGrid) {
		
		if(showGrid){
			drawPath();
		}
		
		pushMatrix();
		stroke(0);
		noFill();
		strokeWeight(3);
		drawNoodle();
		
		
		
		
		// horizontal(3);
		// translate(3 * tileSize, 0);
		// cornerTR();
		// translate(0, 1 * tileSize);
		// cornerBR();
		// horizontal(-1);
		
		// translate(-2 * tileSize, 0);
		// cornerTL();
		
		// translate(tileSize, tileSize *2);
		
		// rotate(PI);
		// shape(head, 0,0);
		
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