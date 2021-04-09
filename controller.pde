static class ID {
    
// BUTTONS - LAYER A
static final int TWISTS = 1;
static final int JOINS = 2;
static final int OVERLAPS = 3;
static final int RANDOMIZE_ENDS = 4;

static final int RESET = 8;

static final int INFO = 9;
static final int GRID = 10;
static final int BLACKOUT = 11;
static final int PATH_EDIT = 12;

static final int LOAD = 15;
static final int SAVE = 16;

// KNOBS - LAYER A
static final int NOODLES = 1;
static final int THICKNESS = 2;
static final int PEN_SIZE = 3;
static final int MIN_LEN = 4;
static final int MAX_LEN = 5;

// KNOBS - LAYER B
static final int PAGEW = 9;
static final int PAGEH = 10;
static final int MARGIN = 11;
static final int COLS = 12;
static final int ROWS = 13;
}

XTouchMini xTouch;

void setupController() {

    xTouch = new XTouchMini();

    for(int i = 1; i <= 12; i++){
        xTouch.setModeForButton(XTButton.MODE_TOGGLE, i);
    }
    xTouch.setModeForButton(XTButton.MODE_MOMENTARY, ID.RESET);

    xTouch.setRangeForKnob(3, 200, ID.NOODLES);
    xTouch.setRangeForKnob(0.1, 1, ID.THICKNESS);
    xTouch.setRoundingConstraintsForKnob(0.01, 2, ID.THICKNESS);
    xTouch.setRangeForKnob(0.1, 2.0, ID.PEN_SIZE);
    xTouch.setRoundingConstraintsForKnob(0.05, 2, ID.PEN_SIZE);
    xTouch.setRangeForKnob(3, 400, ID.MIN_LEN);
    xTouch.setRangeForKnob(3, 400, ID.MAX_LEN);

    xTouch.setRangeForKnob(5, 24, ID.PAGEW);
    xTouch.setRoundingConstraintsForKnob(0.125, 3, ID.PAGEW);
    xTouch.setRangeForKnob(5, 24, ID.PAGEH);
    xTouch.setRoundingConstraintsForKnob(0.125, 3, ID.PAGEH);
    xTouch.setRangeForKnob(0, 5, ID.MARGIN);
    xTouch.setRoundingConstraintsForKnob(0.125, 3, ID.MARGIN);
    xTouch.setRangeForKnob(1, 60, ID.COLS);
    xTouch.setRangeForKnob(1, 60, ID.ROWS);
}

void updateControllerValues() {
    xTouch.setValueForKnob(numNoodles, ID.NOODLES);
    xTouch.setValueForKnob(noodleThicknessPct, ID.THICKNESS);
    xTouch.setValueForKnob(penSizeMM, ID.PEN_SIZE);
    xTouch.setValueForKnob(minLength, ID.MIN_LEN);
    xTouch.setValueForKnob(maxLength, ID.MAX_LEN);
    
    xTouch.setValueForKnob(PRINT_W_INCHES, ID.PAGEW);
    xTouch.setValueForKnob(PRINT_H_INCHES, ID.PAGEH);
    xTouch.setValueForKnob(MARGIN_INCHES, ID.MARGIN);
    xTouch.setValueForKnob(GRID_W, ID.COLS);
    xTouch.setValueForKnob(GRID_H, ID.ROWS);

    xTouch.setValueForButton(useTwists, ID.TWISTS);
    xTouch.setValueForButton(useJoiners, ID.JOINS);
    xTouch.setValueForButton(allowOverlap, ID.OVERLAPS);
    xTouch.setValueForButton(randomizeEnds, ID.RANDOMIZE_ENDS);
    
}

void buttonDidChange(XTButton button, boolean value) {
	println("buttonDidChange: (" + button.id + "): " + value);

    switch(button.id){
        case ID.TWISTS:
            useTwists = value;
        break;
        case ID.JOINS:
            useJoiners = value;
        break;
        case ID.OVERLAPS:
            allowOverlap = value;
        break;
        case ID.RANDOMIZE_ENDS:
            randomizeEnds = value;
        break;
        case ID.RESET:
            if(value) reset();
        break;

        case ID.INFO:
            showInfoPanel = value;
        break;
        case ID.GRID:
            showGrid = value;
            if(!showGrid){
                xTouch.setValueForButton(false, ID.BLACKOUT);
                xTouch.setValueForButton(false, ID.PATH_EDIT);
            }
        break;
        case ID.BLACKOUT:
            BLACKOUT_MODE = value;
            if(BLACKOUT_MODE) {
                xTouch.setValueForButton(false, ID.PATH_EDIT);
                xTouch.setValueForButton(true, ID.GRID);
            }
        break;
        case ID.PATH_EDIT:
            PATH_EDIT_MODE = value;
            if(PATH_EDIT_MODE) {
                xTouch.setValueForButton(false, ID.BLACKOUT);
                xTouch.setValueForButton(true, ID.GRID);
            }
        break;

        case ID.LOAD:
            selectConfigFile();
        break;
        case ID.SAVE:
            fileNameToSave = getFileName();
			imgSaver.begin(fileNameToSave);
        break;
    }
    editor.update();
}


void knobDidChange(XTKnob knob, float oldValue, float newValue) {
	println("knobDidChange (" + knob.id + "): " + oldValue, newValue);

    switch(knob.id){
        case ID.NOODLES:
            numNoodles = int(newValue);
        break;
        case ID.THICKNESS:
            noodleThicknessPct = newValue;
        break;

        case ID.PEN_SIZE:
            penSizeMM = newValue;
            strokeSize =  calculateStrokeSize();
        break;
        case ID.MIN_LEN:
            minLength = int(newValue);
            if(minLength > maxLength){
                xTouch.setValueForKnob(minLength, ID.MAX_LEN);
            }
        break;
        case ID.MAX_LEN:
            maxLength = int(newValue);
            if(maxLength < minLength){
                xTouch.setValueForKnob(maxLength, ID.MIN_LEN);
            }
        break;

        case ID.PAGEW:
            PRINT_W_INCHES = newValue;
            updateKeyDimensions();
        break;
        case ID.PAGEH:
            PRINT_H_INCHES = newValue;
            updateKeyDimensions();
        break;
        case ID.MARGIN: 
            MARGIN_INCHES = newValue;
            updateKeyDimensions();
        break;
        case ID.COLS:
            GRID_W = int(newValue);
            updateKeyDimensions();
        break;
        case ID.ROWS:
            GRID_H = int(newValue);
            updateKeyDimensions();
        break;
    }

    editor.update();

}

void knobDidPress(XTKnob knob) {
	println("knobDidPress: " + knob.id);

    switch(knob.id){
        case ID.PEN_SIZE:
            float val = 0.15;
            if(penSizeMM < 0.9){
                val = 1.0;
            } else if(penSizeMM < 1.9){
                val = 2.0;
            } else {
                val = 0.15;
            }

            xTouch.setValueForKnob(val, knob.id);
        break;
    }
    editor.update();
}

void knobDidRelease(XTKnob knob) {
	println("knobDidRelease: " + knob.id);
}

void faderDidChange(float oldValue, float newValue) {
	println("faderDidChange: " + oldValue, newValue);
}