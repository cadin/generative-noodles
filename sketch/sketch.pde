// Main sketch file

import controlP5.*;
import processing.svg.*;

Boolean USE_RETINA = true;
String SETTINGS_PATH = "config/settings.json";
String configPath = "config/config.json";
String TWIST_PATH = "graphics/twist.svg";
String TWIST_FILL_PATH = "graphics/twistFill.svg";

float MAX_SCREEN_SCALE = 0.182 * 2; // % - (0.2456 == macbook 1:1) (0.182 == LG Screen)
float SCREEN_SCALE = 0.182 * 2; 
float PRINT_W_INCHES = 11;
float PRINT_H_INCHES = 14;
int PRINT_RESOLUTION = 300;
float MARGIN_INCHES = 0.5;

float MAT_W_INCHES = 10.75;
float MAT_H_INCHES = 13.75;

int TILE_SIZE = 50;
int GRID_W = 11;
int GRID_H = 11;

int PRINT_X = 0;
int PRINT_Y = 0;

int canvasW = int(PRINT_W_INCHES * PRINT_RESOLUTION * SCREEN_SCALE);
int canvasH = int(PRINT_H_INCHES * PRINT_RESOLUTION * SCREEN_SCALE);

int canvasX = 0;
int canvasY = 0;

boolean EDIT_MODE = false;
boolean BLACKOUT_MODE = false;
boolean CELLTYPE_MODE = false;
boolean PATH_EDIT_MODE = false;
int editingNoodle = 0;
int[][] blackoutCells;

boolean saveFile = false;

Noodle noodle; 
Noodle noodle2;

int numNoodles = 3;
Noodle[] noodles;

PShape twist;
PShape twistFill;

Point[][] paths;
int[][] cells;

// SETTINGS
boolean showGrid = false;
boolean useTwists = true;
boolean useJoiners = true;
boolean useCurves = true;
float penSizeMM = 0.35;
float strokeSize = calculateStrokeSize();
float noodleThicknessPct = 0.5;
GraphicSet[] graphicSets;
boolean randomizeEnds = false;
boolean allowOverlap = true;
boolean showInfoPanel = false;
boolean useRoughLines = false;
boolean useFills = true;

int minLength = 200;
int maxLength = 200;

ImageSaver imgSaver = new ImageSaver();
String fileNameToSave = "";

Editor editor;


boolean shiftIsDown = false;


PFont menloFont;

void settings() {
	
	// size(displayWidth, displayHeight - 45);
	//size(1920, 1080);
	fullScreen();
	if(USE_RETINA){
		pixelDensity(displayDensity());
	}
}

void setup() {
	editor = new Editor(this);
	frameRate(12);
	menloFont = createFont("Menlo", 12);

	loadSettings(SETTINGS_PATH);
	loadConfigFile(configPath, "");

	twist = loadShape(TWIST_PATH);
	twist.disableStyle();
	twistFill = loadShape(TWIST_FILL_PATH);
	twistFill.disableStyle();
	
	colorMode(HSB, 360, 100, 100);
	reset();
}


float calculateStrokeSize() {
	float size = (penSizeMM * 0.03937008) * PRINT_RESOLUTION * SCREEN_SCALE; 
	return size;
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

color paperColor = color(255);
void drawPaperBG() {
	fill(paperColor);
	stroke(80);
	strokeWeight(1);
	rect(canvasX, canvasY, canvasW, canvasH);
}

void drawBG() {
	background(100);
	if(imgSaver.isBusy()){ drawSaveIndicator();}
	drawPaperBG();
	
}

void draw() {
	colorMode(RGB, 255,255,255);
	
	pushMatrix();
		drawBG();
		if(showInfoPanel) drawInfoPanel();
		
		translate(canvasX, canvasY);
		if(imgSaver.state == SaveState.SAVING){
			beginRecord(SVG, "output/" + fileNameToSave + ".svg");
		}

		translate(PRINT_X, PRINT_Y);
		if(showGrid){ drawGrid();}
		
		colorMode(HSB, 360, 100, 100);
		for(int i=0; i < noodles.length; i++){
			if(noodles[i] != null){
				noodles[i].draw(TILE_SIZE, noodleThicknessPct, useTwists);
			}
		}	
		
		
		if(imgSaver.state == SaveState.SAVING) { endRecord(); }
		imgSaver.update();
	popMatrix();
	if(EDIT_MODE) {
		editor.draw();
	} 
}

int[][] copyBlackoutCells() {
	int[][] cells = new int[GRID_W][GRID_H];
	for(int col = 0; col < GRID_W; col++){
		cells[col] = new int[GRID_H];
		for(int row = 0; row < GRID_H; row++){
			if(blackoutCells[col][row] > 0){
				cells[col][row] = CellType.BLACKOUT;
			}
		}
	}
	return cells;
}

void updateBlackoutCells() {
	if(blackoutCells == null || GRID_W != blackoutCells.length || GRID_H != blackoutCells[0].length){
		blackoutCells = new int[GRID_W][GRID_H];
	}
}

void updateKeyDimensions() {
	updateBlackoutCells();
	calculateScreenScale();
	calculateTileSize();
	strokeSize = calculateStrokeSize();
}

color getColorForCellType(int cellType) {
	color[] colors = { 
		color(0, 5),
		color(0, 255, 0, 100),
		color(0, 0, 255, 100),

		color(255, 0, 0, 100),
		color(255, 0, 0, 100),
		color(255, 0, 0, 100),
		color(255, 0, 0, 100),

		color(255, 255, 0, 100),
		color(255, 255, 0, 100),

		color(0),
		color(0),

		color(255, 0, 255, 100)};

	return colors[cellType];
}

void reset() {
	updateKeyDimensions();

	cells = copyBlackoutCells();
	noodles = new Noodle[numNoodles];
	
	int hueRange = 200;//floor(random(0, 310));
	// int sat = floor(random(60, 80));
	// int brt = floor(random(80, 100));
	
	int noodleCount = 0;
	for(int i=0; i < numNoodles; i++){
		Point[] p = createNoodlePath(cells);
		
		if(p != null){
			int graphicIndex = floor(random(0, graphicSets.length));
			GraphicSet gfx = graphicSets[graphicIndex];
			PShape head = gfx.head;
			PShape tail = gfx.tail;

			if(randomizeEnds){
				int tailIndex = floor(random(0, graphicSets.length));
				tail = graphicSets[tailIndex].head;
			}
			
			
			int hue = floor(random(hueRange, hueRange + 50));
			// int hue = (hueRange + noodleCount * 3) % 360;
			int sat = 70; //floor(random(60, 80));
			int brt = 90; //floor(random(80, 100));
			color fillColor = color(hue, sat, brt);
			noodles[noodleCount] = new Noodle(p, TILE_SIZE, head, tail, gfx.joiners, twist, twistFill, fillColor, millis());
			noodleCount++;
		}
	}
	
	noodles = (Noodle[]) subset(noodles, 0, noodleCount);
}

void deleteNoodle(int indexToDelete) {
	if(noodles.length <= 1) return; // don't delete all the noodles

	Noodle[] updatedNoodles = new Noodle[noodles.length - 1];
	int fillIndex = 0;
	for(int i = 0; i < noodles.length; i++){
		if(i != indexToDelete){
			updatedNoodles[fillIndex] = noodles[i];
			fillIndex++;
		}
	}
	noodles = updatedNoodles;
	editingNoodle = min(editingNoodle, noodles.length - 1);
	
}

void keyReleased() {
	if(keyCode == SHIFT){
		shiftIsDown = false;
	}
}

void keyPressed() {
	switch(keyCode){
		case SHIFT:
			shiftIsDown = true;
		break;
		case BACKSPACE:
			if(PATH_EDIT_MODE){
				deleteNoodle(editingNoodle);
			}
		break;
	}
	switch(key) {
		case 's' :
			fileNameToSave = getFileName();
			int _plotW = int(PRINT_W_INCHES * PRINT_RESOLUTION * SCREEN_SCALE);
			int _plotH = int(PRINT_H_INCHES * PRINT_RESOLUTION * SCREEN_SCALE);
			if(USE_RETINA){
				_plotW = _plotW * 2;
				_plotH = _plotH * 2;
			}

			imgSaver.begin(PRINT_W_INCHES, PRINT_H_INCHES, _plotW, _plotH, fileNameToSave);
		break;
		case 'g':
			showGrid = !showGrid;
			if(!showGrid){
				BLACKOUT_MODE = false;
				PATH_EDIT_MODE = false;
			}
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
				// reset();
			}
		break;
		case 'x':
			BLACKOUT_MODE = !BLACKOUT_MODE;
			if(BLACKOUT_MODE){
				showGrid = true;
			}
		break;
		case 'p' :
			PATH_EDIT_MODE = !PATH_EDIT_MODE;
			if(PATH_EDIT_MODE){
				showGrid = true;
			}
		break;
		case 'l' :
			selectConfigFile();
		break;

		case 'c' :
			CELLTYPE_MODE = !CELLTYPE_MODE;
			break;
		case 'i' :
			importMaskImage();
			break;
		case 'I' :
			if(maskImage != null){
				processMaskData();
			} else {
				importMaskImage();
			}
			break;
	}
}

void mouseDragged() {
	
	if(BLACKOUT_MODE){
		Point cell = getCellForMouse(mouseX, mouseY);
		if(cell.x >= 0 && cell.y >= 0 && cell.x < blackoutCells.length && cell.y < blackoutCells[0].length){
			if(isDrawing){
				blackoutCells[cell.x][cell.y] = CellType.BLACKOUT;
			} else {
				blackoutCells[cell.x][cell.y] = 0;
			}
		} 
	}
}

boolean isDrawing = true;
void mousePressed() {
	Point cell = getCellForMouse(mouseX, mouseY);

	if(BLACKOUT_MODE){
		if(cell.x >= 0 && cell.y >= 0 && cell.x < blackoutCells.length && cell.y < blackoutCells[0].length){
			if(blackoutCells[cell.x][cell.y] > 0){
				isDrawing = false;
				blackoutCells[cell.x][cell.y] = 0;
			} else {
				isDrawing = true;
				blackoutCells[cell.x][cell.y] = CellType.BLACKOUT;
			}
		} 
	} else if(PATH_EDIT_MODE){
		if(shiftIsDown){
			editingNoodle = findNoodleWithCell(cell.x, cell.y);
		} else {
			if(pathContainsCell(noodles[editingNoodle].path, cell.x, cell.y)){
				if(cellIsEndOfPath(cell.x, cell.y, noodles[editingNoodle].path)){
					Point[] newPath = removeCellFromPath(cell.x, cell.y, noodles[editingNoodle].path);
					noodles[editingNoodle].path = newPath;
				} else {
					Point[] newPath = cycleCellType(cell.x, cell.y, noodles[editingNoodle].path);
					noodles[editingNoodle].path = newPath;
				}
			} else {
				Point[] newPath = addCellToPath(cell.x, cell.y, noodles[editingNoodle].path);
				noodles[editingNoodle].path = newPath;
			}
		}
	}
}

void drawSaveIndicator() {
	pushMatrix();
		fill(color(200, 0, 0));
		noStroke();
		rect(0,0,width, 4);
	popMatrix();
}

boolean pathContainsCell(Point[] path, int col, int row) {
	for(Point p : path){

		if(p != null && p.x == col && p.y == row){
			return true;
		}
	}

	return false;
}

void drawCellTypes() {
	pushMatrix();
	noFill();
	stroke(200);
	strokeWeight(1);
	for(int row = 0; row < GRID_H; row++){
		for(int col = 0; col < GRID_W; col++){
			if(BLACKOUT_MODE && blackoutCells[col][row] > 0){
				fill(0,25);
			} else if(PATH_EDIT_MODE && pathContainsCell(noodles[editingNoodle].path, col, row)) {
				fill(0, 255, 0, 25);
			} else if(CELLTYPE_MODE){
				fill(getColorForCellType(cells[col][row]));
			} else {
				noFill();
			}
			rect(col * TILE_SIZE, row * TILE_SIZE, TILE_SIZE, TILE_SIZE);
		}
	}
	popMatrix();
}
void drawGridLines() {
	pushMatrix();
	stroke(200);
	strokeWeight(1);
	for(int row = 0; row <= GRID_H; row++){
		line(0, row * TILE_SIZE, GRID_W * TILE_SIZE, row * TILE_SIZE);
	}

	for(int col = 0; col <= GRID_W; col++){
		line(col * TILE_SIZE, 0, col * TILE_SIZE, GRID_H * TILE_SIZE);
	}
	popMatrix();
}

void drawGrid() {

	if(BLACKOUT_MODE || PATH_EDIT_MODE || CELLTYPE_MODE){
		if(imgSaver.state != SaveState.SAVING){
			drawCellTypes();
		}
	} 
	
	drawGridLines();

	// if(mask != null){
	// 	image(mask, 0, 0);
	// }
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
