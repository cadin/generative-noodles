class Editor {
	
	ControlP5 cp5;
	color bgColor = color(25);
	
	Numberbox widthControl;
	Numberbox heightControl;
	Numberbox colsControl;
	Numberbox rowsControl;
	Numberbox penSizeControl;
	Toggle twistControl;
	Toggle joinControl;
	Toggle curvesControl;
	
	boolean controlsVisible = false;
		
	float printW;
	float printH;
	
	
	Editor(PApplet app) {
		cp5 = new ControlP5(app);
		PFont font = createFont("DIN", 12 / pixelDensity);
		cp5.setFont(font);
		
		widthControl = cp5.addNumberbox("Width")
			.setPosition(100,100)
			.setSize(100,20)
			.setRange(5.0,24.0)
			.setMultiplier(0.25) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(PRINT_W_INCHES)
			.setDecimalPrecision(3)
			.setId(1)
			;
			
		heightControl = cp5.addNumberbox("Height")
			.setPosition(100,150)
			.setSize(100,20)
			.setRange(5.0,24.0)
			.setMultiplier(0.25) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(PRINT_H_INCHES)
			.setDecimalPrecision(3)
			.setId(2)
			;

		colsControl = cp5.addNumberbox("Columns")
			.setPosition(300,100)
			.setSize(100,20)
			.setRange(1,60)
			.setMultiplier(1) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(GRID_W)
			.setDecimalPrecision(0)
			.setId(3)
			;
			
		rowsControl = cp5.addNumberbox("Rows")
			.setPosition(300,150)
			.setSize(100,20)
			.setRange(1,60)
			.setMultiplier(1) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(GRID_H)
			.setDecimalPrecision(0)
			.setId(4)
			;

		penSizeControl = cp5.addNumberbox("Pen Size")
			.setPosition(300,200)
			.setSize(100,20)
			.setRange(0.10,2)
			.setMultiplier(0.05) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(penSizeMM)
			.setDecimalPrecision(2)
			.setId(5)
			;
		
		twistControl = cp5.addToggle("Use Twists")
			.setPosition(100,300)
			.setSize(20,20)
			.setValue(useTwists)
			;
		
		twistControl
			.getCaptionLabel()
			.align(ControlP5.RIGHT_OUTSIDE, ControlP5.CENTER)
			.setPaddingX(10)
			;
		
		joinControl = cp5.addToggle("Use Joins")
			.setPosition(100,350)
			.setSize(20,20)
			.setValue(useJoiners)
			;
		
		joinControl
			.getCaptionLabel()
			.align(ControlP5.RIGHT_OUTSIDE, ControlP5.CENTER)
			.setPaddingX(10)
			;
			
		curvesControl = cp5.addToggle("Use Curves")
			.setPosition(100,400)
			.setSize(20,20)
			.setValue(useCurves)
			;
		
		curvesControl
			.getCaptionLabel()
			.align(ControlP5.RIGHT_OUTSIDE, ControlP5.CENTER)
			.setPaddingX(10)
			;
		
		hide();
	}
	
	
	void show() {
		println("show");
		widthControl.setValue(PRINT_W_INCHES);
		heightControl.setValue(PRINT_H_INCHES);
		colsControl.setValue(GRID_W);
		rowsControl.setValue(GRID_H);
		penSizeControl.setValue(penSizeMM);
		twistControl.setValue(useTwists);
		joinControl.setValue(useJoiners);
		curvesControl.setValue(useCurves);
		
		controlsVisible = true;
	}
	
	void hide() {
		println("hide");
		PRINT_W_INCHES = widthControl.getValue();
		PRINT_H_INCHES = heightControl.getValue();
		GRID_W = int(colsControl.getValue());
		GRID_H = int(rowsControl.getValue());
		penSizeMM = penSizeControl.getValue();
		strokeSize = calculateStrokeSize();

		useTwists = twistControl.getState();
		useJoiners = joinControl.getState();
		useCurves = curvesControl.getState();

		controlsVisible = false;
		cp5.hide();
		
	}
	
	void draw() {
		fill(0, 50);
		noStroke();
		rect(50, 50, 500, 500, 8);
		
		if(controlsVisible && !cp5.isVisible()){
			cp5.show();
		} 

	}

	boolean printSizeDidChange() {
		return (
			PRINT_W_INCHES != widthControl.getValue() || 
			PRINT_H_INCHES != heightControl.getValue() ||
			GRID_W != int(colsControl.getValue())||
			GRID_H != int(rowsControl.getValue())
		);
	}
	
	void controlEvent(ControlEvent e) {
		if(controlsVisible){
			boolean updateSizes = printSizeDidChange();

			PRINT_W_INCHES = widthControl.getValue();
			PRINT_H_INCHES = heightControl.getValue();
			GRID_W = int(colsControl.getValue());
			GRID_H = int(rowsControl.getValue());
			penSizeMM = penSizeControl.getValue();
			strokeSize = calculateStrokeSize();

			useTwists = twistControl.getState();
			useJoiners = joinControl.getState();
			useCurves = curvesControl.getState();

			if(updateSizes){
				updateKeyDimensions();
			}
		}
		// println(" - got a control event from controller with id " + e.getId());
		// switch(theEvent.getId()) {
		// 	case(1): // numberboxA is registered with id 1
		// 		println((theEvent.getController().getValue()));
		// 	break;
		// 	case(2):  // numberboxB is registered with id 2
		// 		println((theEvent.getController().getValue()));
		// 	break;
		// }
	}
}

public void controlEvent(ControlEvent e) {
	// forward control events to Editor
	if(editor != null){
		editor.controlEvent(e);
	}
}