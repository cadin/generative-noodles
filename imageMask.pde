void importMaskImage() {

	selectInput("Load image mask", "onImageMaskSelected");

}

PImage maskImage = null;
void onImageMaskSelected(File img) {
	shiftIsDown = false;
	if(img == null) return;
	
	String filePath = img.getAbsolutePath();
	
    maskImage = loadImage(filePath);
    processMaskData();
}


PGraphics mask = null;
void processMaskData() {
    mask = createGraphics(GRID_W, GRID_H);
    mask.beginDraw();
    mask.background(0);

    // scale and center
    float scale = float(GRID_W) / float(maskImage.width);
    if(scale * maskImage.height > GRID_H) {
        scale = float(GRID_H) / float(maskImage.height);
    }
    float w = maskImage.width * scale;
    float h = maskImage.height * scale;
    float xPos = (GRID_W - w) / 2;
    float yPos = (GRID_H - h) / 2;

    mask.image(maskImage, xPos, yPos, w, h);
    mask.endDraw();

    mask.loadPixels();
    // loop through rows and cols in blackout cells
    for(int y = 0; y < GRID_H; y++) {
        for(int x = 0; x < GRID_W; x++) {
            
            // fucking retina displays make this complicated
            // why can't I create a PGraphics at an exact size?
            int xVal = x * mask.pixelDensity;
            int yVal = y * mask.pixelDensity;
            int index =( xVal + yVal * GRID_W * mask.pixelDensity) ;
            color c = mask.pixels[ index ];
            if(brightness(c) < 50) {
                blackoutCells[x][y] = CellType.BLACKOUT;
            } else {
                blackoutCells[x][y] = 0;
                
            }
        }
    }


}