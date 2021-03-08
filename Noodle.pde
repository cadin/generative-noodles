class Noodle {
	
	int margin = 0;
	int thickness = 10;
	float thicknessPct = 0.5;
	int tileSize = 0;
	
	int headWidth = 100;
	
	Point[] path;
	
	PShape head, tail;
	PShape[] joiners;
	
	void calculateSizes(int tileW, float pct) {
		tileSize = tileW;
		thicknessPct = pct;
		thickness = int(tileSize * thicknessPct);
		thickness = (thickness / 2) * 2;
		margin = (tileSize - thickness) / 2;
	}

	Noodle(Point[] p, int tileW, PShape h, PShape t, PShape[] j) {
		calculateSizes(tileW, thicknessPct);
		head = h;
		tail = t;
		
		head.disableStyle();
		tail.disableStyle();
		joiners = j;

		path = p;
	}

	
	void drawEnd(PShape shape, Point pos, Point neighbor, int flip) {
		pushMatrix();
		translate(tileSize / 2, tileSize/2);
		
		if(neighbor.x < pos.x){
			rotate(HALF_PI);
		} else if(neighbor.x > pos.x){
			rotate(-HALF_PI);
		} else if(neighbor.y < pos.y){
			rotate(PI);
		}
		
		float scale = (float)thickness / (float)headWidth;
		translate(0, (tileSize - headWidth * scale) / 2);
		scale(flip, 1);
		scale(scale);
		strokeWeight(strokeSize / scale);
		shape(shape, headWidth/-2 , headWidth/-2);
		strokeWeight(strokeSize);
		popMatrix();
	}
	
	void verticalJoin(int type) {
		float scale = (float)thickness / (float)headWidth;
		float distToGfx = (tileSize - headWidth * scale)/2;
		line(margin, 0, margin, distToGfx);
		line(tileSize - margin, 0, tileSize - margin, distToGfx);
		line(margin, tileSize - distToGfx, margin, tileSize);
		line(tileSize - margin, tileSize - distToGfx, tileSize-margin, tileSize);
		
		pushMatrix();
			translate(tileSize / 2, tileSize/2);
			scale(scale);
			strokeWeight(strokeSize / scale);
			shape(joiners[type - 1], headWidth/-2 , headWidth/-2);
			strokeWeight(strokeSize);
			
		popMatrix();
	}
	
	void horizontalJoin(int type) {
		float scale = (float)thickness / (float)headWidth;
		float distToGfx = (tileSize - headWidth * scale)/2;
		line(0, margin, distToGfx, margin);
		line( 0,tileSize - margin,  distToGfx, tileSize - margin);
		line(tileSize - distToGfx, margin,  tileSize, margin );
		line(tileSize - distToGfx, tileSize - margin,  tileSize, tileSize-margin);
		
		pushMatrix();
			translate(tileSize / 2, tileSize/2);
			scale(scale);
			rotate(HALF_PI);
			strokeWeight(strokeSize / scale);
			shape(joiners[type -1], headWidth/-2 , headWidth/-2);
			strokeWeight(strokeSize);
			
		popMatrix();
	}
	
	void drawNoodle(boolean useTwists) {
	
		for(int i = 0; i < path.length; i++){
			Point p = path[i];
			
			pushMatrix();
			translate(p.x * tileSize, p.y * tileSize);
			if(i == 0){
				drawEnd(head, path[i], path[i + 1], 1);
			}else if( i == path.length -1){
				drawEnd(tail, path[i], path[i - 1], -1);
			} else {
				
				Point prev = path[i-1];
				Point next = path[i+1];
				
				boolean top = prev.y < p.y || next.y < p.y;
				boolean right = prev.x > p.x || next.x > p.x;
				boolean left = prev.x < p.x || next.x < p.x;
				boolean bottom = prev.y > p.y || next.y > p.y;
				
				if(top && bottom ){
					if(useTwists && p.type == 0){
						verticalTwist();
					} else if(useJoiners && joiners != null && p.type > 0 && p.type <= joiners.length) {
						verticalJoin(p.type);
					} else {
						vertical();
					}
				} else if(left && right){
					if(useTwists && p.type == 0){
						horizontalTwist();
					} else if(useJoiners && joiners != null && p.type > 0 && p.type <= joiners.length){
						horizontalJoin(p.type);
					} else {
						horizontal();
					}
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
	
	void draw(int size, float pct, boolean useTwists) {
		if(tileSize != size || thicknessPct != pct){
			calculateSizes(size, pct);
		}
		pushMatrix();
		stroke(0);
		noFill();
		strokeWeight(strokeSize);
		
		drawNoodle(useTwists);
		popMatrix();
	}

	
	void cornerTL() {
		if(useCurves){
			arc(tileSize, tileSize, (thickness + margin)*2, (thickness + margin)*2, PI, PI + HALF_PI);
			arc(tileSize, tileSize, margin * 2, margin * 2, PI, PI + HALF_PI);
		} else {
			line(margin, tileSize, margin, tileSize - margin);
			line(margin, tileSize - margin, tileSize - margin, margin);
			line(tileSize - margin, margin, tileSize, margin);
			
			line(tileSize - margin, tileSize, tileSize - margin, tileSize - margin /2);
			line(tileSize - margin, tileSize - margin/2, tileSize - margin/2, tileSize - margin);
			line(tileSize - margin/2, tileSize - margin, tileSize, tileSize - margin);
			
			// line(tileSize - margin, tileSize, tileSize, tileSize - margin);
			
		}
	}
	
	void cornerTR() {
		if(useCurves){
			arc(0, tileSize, (thickness + margin)*2 , (thickness + margin)*2,-HALF_PI, 0);
			arc(0, tileSize, margin * 2, margin *2, -HALF_PI, 0);
		} else {
			line(0, margin, margin, margin);
			line(margin, margin, tileSize - margin, tileSize - margin);
			line(tileSize - margin, tileSize - margin, tileSize-margin, tileSize);
			
			line(0, tileSize - margin, margin/2, tileSize - margin);
			line(margin/2, tileSize - margin, margin, tileSize - margin/2);
			line(margin, tileSize - margin/2, margin, tileSize);
		}
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
	
	void verticalTwist() {
		float twistDepth = tileSize / 2;
		bezier(margin, 0, margin,   twistDepth, tileSize - margin,   tileSize - twistDepth, tileSize-margin, tileSize);
		bezier( tileSize - margin, 0,    tileSize - margin, twistDepth,     margin, tileSize - twistDepth,    margin, tileSize);
	}
	
	
	
	void horizontal() {
		line(0, margin, tileSize, margin);
		line(0, tileSize - margin, tileSize, tileSize - margin);
	}
	
	void horizontalTwist() {
		float twistDepth = tileSize / 2;
		bezier( 0, margin, twistDepth,margin, tileSize - (twistDepth),   tileSize-margin,   tileSize , tileSize - margin);
		bezier( 0, tileSize - margin, twistDepth, tileSize-margin, tileSize -twistDepth, margin,      tileSize, margin);
	}
}