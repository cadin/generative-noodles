class Noodle {
	int margin = 0;
	int thickness = 10;
	float thicknessPct = 0.5;
	int tileSize = 0;
	
	int headWidth = 100;
	int seed = 0;
	
	Point[] path;
	
	PShape head, tail;
	PShape[] joiners;
	PShape twist;
	PShape twistFill;
	color fillColor;
	
	void calculateSizes(int tileW, float pct) {
		tileSize = tileW;
		thicknessPct = pct;
		thickness = int(tileSize * thicknessPct);
		thickness = (thickness / 2) * 2;
		margin = (tileSize - thickness) / 2;
	}

	Noodle(Point[] p, int tileW, PShape h, PShape t, PShape[] j, PShape tw, PShape twf,color fc, int rs) {
		calculateSizes(tileW, thicknessPct);
		head = h;
		tail = t;
		
		joiners = j;
		twist = tw;
		twistFill = twf;
		path = p;
		fillColor = fc;

		seed = rs;
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
	
	void verticalShape(PShape shape){
		verticalShape(shape, false);
	}

	void verticalShape(PShape shape, boolean isFill) {
		float scale = (float)thickness / (float)headWidth;
		float distToGfx = (tileSize - headWidth * scale)/2;
		
		if(isFill){
			rect(margin, 0, tileSize - margin * 2, distToGfx);
			rect(margin, tileSize - distToGfx, tileSize - margin * 2, distToGfx);
		} else {
			line(margin, 0, margin, distToGfx);
			line(tileSize - margin, 0, tileSize - margin, distToGfx);
			line(margin, tileSize - distToGfx, margin, tileSize);
			line(tileSize - margin, tileSize - distToGfx, tileSize-margin, tileSize);
		}
		
		pushMatrix();
			translate(tileSize / 2, tileSize/2);
			scale(scale);
			strokeWeight(strokeSize / scale);
			shape(shape, headWidth/-2 , headWidth/-2);
			strokeWeight(strokeSize);
		popMatrix();
	}

	void verticalTwist(boolean isFill) {
		if(isFill){
			verticalShape(twistFill, true);
		} else {
			verticalShape(twist);
		}
	}
	
	void verticalJoin(int type) {
		verticalShape(joiners[type -1]);
	}

	void horizontalShape(PShape shape) {
		horizontalShape(shape, false);
	}

	void horizontalShape(PShape shape, boolean isFill) {
		float scale = (float)thickness / (float)headWidth;
		float distToGfx = (tileSize - headWidth * scale)/2;
		
		if(isFill){
			rect(0, margin, distToGfx, tileSize - margin * 2);
			rect(tileSize - distToGfx, margin, distToGfx, tileSize - margin * 2);
		} else {
		
			line(0, margin, distToGfx, margin);
			line( 0,tileSize - margin,  distToGfx, tileSize - margin);
			line(tileSize - distToGfx, margin,  tileSize, margin );
			line(tileSize - distToGfx, tileSize - margin,  tileSize, tileSize-margin);
		}
		
		pushMatrix();
			translate(tileSize / 2, tileSize/2);
			scale(scale);
			rotate(HALF_PI);
			strokeWeight(strokeSize / scale);
			shape(shape, headWidth/-2 , headWidth/-2);
			strokeWeight(strokeSize);
		popMatrix();
	}

	void horizontalTwist(boolean isFill) {
		if(isFill){
			horizontalShape(twistFill, true);
		} else {
			horizontalShape(twist);
		}
	}
	
	void horizontalJoin(int type) {
		horizontalShape(joiners[type-1]);
	}
	
	void drawNoodle(boolean useTwists) {
		randomSeed(seed);
		
		boolean fills = useFills;
		int start = 1;
		if (useFills) start = 0;
		for(int j = start ; j < 2; j++){
			
			for(int i = 0; i < path.length; i++){
				
				if(j == 0){
					noStroke();
					fill(fillColor);
					
				} else {
					fills = false;
					stroke(0);
					noFill();
					strokeWeight(strokeSize);
				}
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
						if(p.type == CellType.V_CROSSED){
							verticalCrossed(fills);
						} else if (useTwists && p.joinType == 0){
							verticalTwist(fills);
						}  else if(useJoiners && joiners != null && p.joinType > 0 && p.joinType <= joiners.length) {
							verticalJoin(p.joinType);
						} else {
							vertical(fills);
						}
					} else if(left && right){
						if(p.type == CellType.H_CROSSED){
							horizontalCrossed(fills);
						} else if (useTwists && p.joinType == 0){
							horizontalTwist(fills);
						} else if(useJoiners && joiners != null && p.joinType > 0 && p.joinType <= joiners.length){
							horizontalJoin(p.joinType);
						} else {
							horizontal(fills);
						}
					} else if(left && bottom){
						cornerTR(fills);
					} else if(top && left){
						cornerBR(fills);
					} else if(top && right) {
						cornerBL(fills);
					} else if(bottom && right){
						cornerTL(fills);
					}
				}
				popMatrix();
				
				
			}
		}
	}
	
	void draw(int size, float pct, boolean useTwists) {
		if(tileSize != size || thicknessPct != pct){
			calculateSizes(size, pct);
		}
		
		drawNoodle(useTwists);
	}

	void verticalCrossed(boolean isFill) {
		if(isFill){
			// rect(margin, 0, tileSize - margin * 2, margin);
			// rect(margin , tileSize - margin, tileSize - margin * 2, margin);
			vertical(isFill);
		} else {
			line(margin, 0, margin, margin);
			line(margin, tileSize - margin, margin, tileSize );
			
			line(tileSize - margin, 0, tileSize - margin, margin);
			line(tileSize - margin, tileSize - margin, tileSize - margin, tileSize);
		}
	}

	void horizontalCrossed(boolean isFill) {
		if(isFill){
			// rect(0, margin, margin, tileSize - margin *2);
			// rect(tileSize - margin, margin, margin, tileSize - margin *2);
			horizontal(isFill);
		} else {
			line(0, margin, margin, margin);
			line(tileSize - margin, margin, tileSize, margin);

			line(0, tileSize - margin, margin, tileSize - margin);
			line(tileSize - margin, tileSize - margin, tileSize, tileSize - margin);
		}
	}
	
	void cornerTL(boolean isFill) {
		arc(tileSize, tileSize, (thickness + margin)*2, (thickness + margin)*2, PI, PI + HALF_PI);
		if(isFill) fill(paperColor);
		arc(tileSize, tileSize, margin * 2, margin * 2, PI, PI + HALF_PI);
	}
	
	void cornerTR(boolean isFill) {
		arc(0, tileSize, (thickness + margin)*2 , (thickness + margin)*2,-HALF_PI, 0);
		if(isFill) fill(paperColor);
		arc(0, tileSize, margin * 2, margin *2, -HALF_PI, 0);
	}
	
	void cornerBR(boolean isFill) {
		arc(0, 0, (thickness + margin)*2, (thickness + margin)*2, 0, HALF_PI);
		if(isFill) fill(paperColor);
		arc(0, 0, margin * 2, margin * 2, 0, HALF_PI);
	}
	
	void cornerBL(boolean isFill) {
		arc(tileSize, 0, (thickness + margin)*2, (thickness + margin)*2, HALF_PI, PI);
		if(isFill) fill(paperColor);
		arc(tileSize, 0, margin * 2, margin * 2, HALF_PI, PI);
		
	}
	
	void vertical(boolean isFill) {
		if(useRoughLines){
			roughLineV(margin, 0, tileSize);
			roughLineV(tileSize - margin, 0, tileSize);
		} else {
			
			if(isFill){
				rect(margin, 0, tileSize - margin*2, tileSize);
			} else {
				line(margin, 0, margin, tileSize);
				line( tileSize - margin, tileSize, tileSize - margin, 0);
			}
		}		
	}
	
	// void verticalTwist() {
	// 	float twistDepth = tileSize / 2;
	// 	bezier(margin, 0, margin,   twistDepth, tileSize - margin,   tileSize - twistDepth, tileSize-margin, tileSize);
	// 	bezier( tileSize - margin, 0,    tileSize - margin, twistDepth,     margin, tileSize - twistDepth,    margin, tileSize);
	// }
	
	
	
	void horizontal(boolean isFill) {
		if(useRoughLines){
			roughLineH(0, margin, tileSize);
			roughLineH(0, tileSize - margin, tileSize);
		} else {
			if(isFill){
				rect(0, margin, tileSize, tileSize - margin * 2);
			} else {
				line(0, margin, tileSize, margin);
				line(0, tileSize - margin, tileSize, tileSize - margin);
			}
		}
	}
	
// 	void horizontalTwist() {
// 		float twistDepth = tileSize / 2;
// 		bezier( 0, margin, twistDepth,margin, tileSize - (twistDepth),   tileSize-margin,   tileSize , tileSize - margin);
// 		bezier( 0, tileSize - margin, twistDepth, tileSize-margin, tileSize -twistDepth, margin,      tileSize, margin);
// 	}
}