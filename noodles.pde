import processing.svg.*;


int TILE_SIZE = 100;
int GRID_W = 8;
int GRID_H = 8;

boolean showGrid = true;
boolean saveFile = false;

PShape head ;
Noodle noodle; 
Noodle noodle2;

Point[][] paths;

int[][] cells = new int[GRID_W][GRID_H];



void settings() {
	size(TILE_SIZE * GRID_W, TILE_SIZE * GRID_H);
	pixelDensity(displayDensity());
}

void setup() {
	head = loadShape("test.svg");
	reset();
}

void draw() {
	background(255);
	if(showGrid){
		drawGrid();
	}
	
	if(saveFile){
		beginRecord(SVG, "output/" + getFileName() + ".svg");
	}
	
	noodle.draw(showGrid);
	noodle2.draw(showGrid);
	
	if(saveFile){
		endRecord();
		saveFile = false;
	}

}

void reset() {
	paths = new Point[2][];
	cells = new int[GRID_W][GRID_H];
	Point[] p1 = createNoodlePath(cells);
	Point[] p2 = createNoodlePath(cells);
	paths[0] = p1;
	
	
	noodle = new Noodle(p1,TILE_SIZE, head);
	noodle2 = new Noodle(p2,TILE_SIZE, head);
}

void keyPressed() {
	switch(key) {
		case 's' :
			saveFile = true;
		break;
		case 'g':
			showGrid = !showGrid;
		break;
		case 'r':
			reset();
		break;
	}
}



void drawGrid() {
	pushMatrix();
	stroke(200);
	strokeWeight(1);
	for(int row = 0; row < GRID_H; row++){
		for(int col = 0; col < GRID_W; col++){
			rect(col * TILE_SIZE, row * TILE_SIZE, TILE_SIZE, TILE_SIZE);
		}
	}
	popMatrix();
}

String getFileName() {
	String d  = str( day()    );  // Values from 1 - 31
	String mo = str( month()  );  // Values from 1 - 12
	String y  = str( year()   );  // 2003, 2004, 2005, etc.
	String s  = str( second() );  // Values from 0 - 59
 	String min= str( minute() );  // Values from 0 - 59
 	String h  = str( hour()   );  // Values from 0 - 23

 	String date = y + "-" + mo + "-" + d + " " + h + "-" + min + "-" + s;
 	String n = date;
 	return n;
}
