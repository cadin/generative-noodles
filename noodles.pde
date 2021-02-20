import controlP5.*;
import processing.svg.*;


float MAX_SCREEN_SCALE = 0.245; // % - (0.2456 == macbook 1:1)
float SCREEN_SCALE = 0.245; 
float PRINT_W_INCHES = 8;
float PRINT_H_INCHES = 8;
int PRINT_RESOLUTION = 600;
float MARGIN_INCHES = 0.5;

int TILE_SIZE = 50;
int GRID_W = 6;
int GRID_H = 6;

int PRINT_X = 0;
int PRINT_Y = 0;

int canvasW = int(PRINT_W_INCHES * PRINT_RESOLUTION * SCREEN_SCALE);
int canvasH = int(PRINT_H_INCHES * PRINT_RESOLUTION * SCREEN_SCALE);

int canvasX = 0;
int canvasY = 0;

boolean EDIT_MODE = false;

boolean saveFile = false;

Noodle noodle; 
Noodle noodle2;

int numNoodles = 1;
Noodle[] noodles;

Point[][] paths;
int[][] cells;

PShape[] ends;

// SETTINGS
boolean showGrid = false;
boolean useTwists = false;

ImageSaver imgSaver = new ImageSaver();
String fileNameToSave = "";

Editor editor;


void settings() {
	
	size(displayWidth, displayHeight - 45);
	// fullScreen();
	pixelDensity(displayDensity());
	
}

void setup() {
	editor = new Editor(this);
	ends = new PShape[2];
	ends[0] = loadShape("hand.svg");
	ends[1] = loadShape("hand2.svg");
	frameRate(12);
	
	reset();
}

void calculateScreenScale() {
	float maxW = width - 100;
	float maxH = height - 100;
	
	float printW = PRINT_W_INCHES * PRINT_RESOLUTION;
	float printH = PRINT_H_INCHES * PRINT_RESOLUTION;
	SCREEN_SCALE = maxW / printW;
	
	if(printH * SCREEN_SCALE > maxH){
		SCREEN_SCALE = maxH / printH;
	}
	
	if(SCREEN_SCALE > MAX_SCREEN_SCALE){
		SCREEN_SCALE = MAX_SCREEN_SCALE;
	}
	
	canvasW = int(PRINT_W_INCHES * PRINT_RESOLUTION * SCREEN_SCALE);
	canvasH = int(PRINT_H_INCHES * PRINT_RESOLUTION * SCREEN_SCALE);
	
	canvasX = (width - canvasW) /2;
	canvasY = (height - canvasH) /2;
}

void calculateTileSize() {
	int marginPx = int(MARGIN_INCHES * PRINT_RESOLUTION * SCREEN_SCALE);
	int printAreaW = canvasW - marginPx * 2;
	int printAreaH = canvasH - marginPx * 2;
	TILE_SIZE = printAreaW / GRID_W;
	
	if(GRID_H * TILE_SIZE > printAreaH){
		TILE_SIZE = printAreaH / GRID_H;
	}
	
	// tile size must be even
	TILE_SIZE = (TILE_SIZE / 2) * 2;
	
	PRINT_X =  (canvasW - (TILE_SIZE * GRID_W)) / 2;
	PRINT_Y = (canvasH - (TILE_SIZE * GRID_H)) / 2;
		
}

void drawPaperBG() {
	fill(255);
	stroke(80);
	strokeWeight(1);
	rect(canvasX, canvasY, canvasW, canvasH);
}

void drawBG() {
	background(100);
	if(imgSaver.isBusy()){ drawSaveIndicator();}
	drawPaperBG();
	translate(canvasX, canvasY);
}

void draw() {
	if(EDIT_MODE) {
		editor.draw();
	} else {
		drawBG();
		if(imgSaver.state == SaveState.SAVING){
			beginRecord(SVG, "output/" + fileNameToSave + ".svg");
		}
		
		translate(PRINT_X, PRINT_Y );
		if(showGrid){ drawGrid();}
		
		for(int i=0; i < noodles.length; i++){
			noodles[i].draw(useTwists);
		}	
		
		if(imgSaver.state == SaveState.SAVING) { endRecord(); }
		imgSaver.update();
	}
}

void reset() {
	calculateScreenScale();
	calculateTileSize();
	cells = new int[GRID_W][GRID_H];
	noodles = new Noodle[numNoodles];
	
	int noodleCount = 0;
	for(int i=0; i < numNoodles; i++){
		Point[] p = createNoodlePath(cells);
		
		if(p != null){
		int endIndex = floor(random(0, ends.length));
			PShape end = ends[endIndex];
			noodles[noodleCount] = new Noodle(p, TILE_SIZE, end);
			noodleCount++;
		}
	}
	
	noodles = (Noodle[]) subset(noodles, 0, noodleCount);
}

void keyPressed() {
	switch(key) {
		case 's' :
			fileNameToSave = getFileName();
			imgSaver.begin(fileNameToSave);
		break;
		case 'g':
			showGrid = !showGrid;
		break;
		case 'r':
			reset();
		break;
		case 't':
			TILE_SIZE++;
		break;
		case 'e':
			EDIT_MODE = !EDIT_MODE;
			if(EDIT_MODE){
				editor.show();
			} else {
				editor.hide();
				calculateScreenScale();
				calculateTileSize();
			}
		break;
	}
}

void drawSaveIndicator() {
	pushMatrix();
		fill(color(200, 0, 0));
		noStroke();
		rect(0,0,width, 4);
	popMatrix();
}

void drawGrid() {
	pushMatrix();
	stroke(200);
	noFill();
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
