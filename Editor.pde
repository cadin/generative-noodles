class Editor {
	
	ControlP5 cp5;
	color bgColor = color(25);
	
	Numberbox widthControl, 
	          heightControl,
	          marginControl,
	          colsControl,
	          rowsControl,
	          penSizeControl,
	          numNoodlesControl,
	          thicknessControl,
			  minLengthControl,
			  maxLengthControl;

	Toggle twistControl,
	       joinControl,
	       overlapControl,
		   randomizeEndsControl,
		   roughLinesControl,
		   useFillsControl;
	
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
			.setDecimalPrecision(2)
			.setId(1)
			;
			
		heightControl = cp5.addNumberbox("Height")
			.setPosition(100,150)
			.setSize(100,20)
			.setRange(5.0, 24.0)
			.setMultiplier(0.25) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(MARGIN_INCHES)
			.setDecimalPrecision(2)
			.setId(2)
			;
		
		marginControl = cp5.addNumberbox("Margin")
			.setPosition(100,200)
			.setSize(100,20)
			.setRange(0.0,5.0)
			.setMultiplier(0.25) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(PRINT_H_INCHES)
			.setDecimalPrecision(2)
			.setId(2)
			;

		colsControl = cp5.addNumberbox("Columns")
			.setPosition(100,275)
			.setSize(100,20)
			.setRange(1,200)
			.setMultiplier(1) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(GRID_W)
			.setDecimalPrecision(0)
			.setId(3)
			;
			
		rowsControl = cp5.addNumberbox("Rows")
			.setPosition(100,325)
			.setSize(100,20)
			.setRange(1,200)
			.setMultiplier(1) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(GRID_H)
			.setDecimalPrecision(0)
			.setId(4)
			;

		
		numNoodlesControl = cp5.addNumberbox("Noodles")
			.setPosition(100,400)
			.setSize(100,20)
			.setRange(1,500)
			.setMultiplier(1) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(penSizeMM)
			.setDecimalPrecision(0)
			.setId(6)
			;
		thicknessControl = cp5.addNumberbox("Thickness %")
			.setPosition(100,450)
			.setSize(100,20)
			.setRange(0.1,1.0)
			.setMultiplier(0.01) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(penSizeMM)
			.setDecimalPrecision(2)
			.setId(7)
			;

		minLengthControl = cp5.addNumberbox("Min Length")
			.setPosition(100,500)
			.setSize(100,20)
			.setRange(2,400)
			.setMultiplier(1) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(penSizeMM)
			.setDecimalPrecision(0)
			.setId(8)
			;

		maxLengthControl = cp5.addNumberbox("Max Length")
			.setPosition(100,550)
			.setSize(100,20)
			.setRange(2,400)
			.setMultiplier(1) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(penSizeMM)
			.setDecimalPrecision(0)
			.setId(9)
			;

		
		penSizeControl = cp5.addNumberbox("Pen Size")
			.setPosition(100,625)
			.setSize(100,20)
			.setRange(0.10,6)
			.setMultiplier(0.05) // set the sensitifity of the numberbox
			.setDirection(Controller.HORIZONTAL) // change the control direction to left/right
			.setValue(penSizeMM)
			.setDecimalPrecision(2)
			.setId(5)
			;
		
		twistControl = cp5.addToggle("Use Twists")
			.setPosition(250,100)
			.setSize(20,20)
			.setValue(useTwists)
			;
		
		twistControl
			.getCaptionLabel()
			.align(ControlP5.RIGHT_OUTSIDE, ControlP5.CENTER)
			.setPaddingX(10)
			;
		
		joinControl = cp5.addToggle("Use Joins")
			.setPosition(250,150)
			.setSize(20,20)
			.setValue(useJoiners)
			;
		
		joinControl
			.getCaptionLabel()
			.align(ControlP5.RIGHT_OUTSIDE, ControlP5.CENTER)
			.setPaddingX(10)
			;
			
		overlapControl = cp5.addToggle("Allow Overlaps")
			.setPosition(250,200)
			.setSize(20,20)
			.setValue(allowOverlap)
			;
		
		overlapControl
			.getCaptionLabel()
			.align(ControlP5.RIGHT_OUTSIDE, ControlP5.CENTER)
			.setPaddingX(10)
			;

		randomizeEndsControl = cp5.addToggle("Randomize Ends")
			.setPosition(250,250)
			.setSize(20,20)
			.setValue(useCurves)
			;
		
		randomizeEndsControl
			.getCaptionLabel()
			.align(ControlP5.RIGHT_OUTSIDE, ControlP5.CENTER)
			.setPaddingX(10)
			;
		
		roughLinesControl = cp5.addToggle("Rough Lines")
			.setPosition(250,300)
			.setSize(20,20)
			.setValue(useRoughLines)
			;
		
		roughLinesControl
			.getCaptionLabel()
			.align(ControlP5.RIGHT_OUTSIDE, ControlP5.CENTER)
			.setPaddingX(10)
			;
			
		useFillsControl = cp5.addToggle("Use Fills")
			.setPosition(250,350)
			.setSize(20,20)
			.setValue(useRoughLines)
			;
		
		useFillsControl
			.getCaptionLabel()
			.align(ControlP5.RIGHT_OUTSIDE, ControlP5.CENTER)
			.setPaddingX(10)
			;
		
		
		hide();
	}

	void update() {
		widthControl.setValue(PRINT_W_INCHES);
		heightControl.setValue(PRINT_H_INCHES);
		marginControl.setValue(MARGIN_INCHES);
		colsControl.setValue(GRID_W);
		rowsControl.setValue(GRID_H);
		minLengthControl.setValue(minLength);
		maxLengthControl.setValue(maxLength);
		penSizeControl.setValue(penSizeMM);
		twistControl.setValue(useTwists);
		joinControl.setValue(useJoiners);
		overlapControl.setValue(useCurves);
		numNoodlesControl.setValue(numNoodles);
		thicknessControl.setValue(noodleThicknessPct);
		randomizeEndsControl.setValue(randomizeEnds);
		roughLinesControl.setValue(useRoughLines);
		useFillsControl.setValue(useFills);
	}
	
	
	void show() {
		update();
		controlsVisible = true;
	}
	
	void hide() {
		PRINT_W_INCHES = widthControl.getValue();
		PRINT_H_INCHES = heightControl.getValue();
		GRID_W = int(colsControl.getValue());
		GRID_H = int(rowsControl.getValue());
		penSizeMM = penSizeControl.getValue();
		strokeSize = calculateStrokeSize();

		useTwists = twistControl.getState();
		useJoiners = joinControl.getState();
		allowOverlap = overlapControl.getState();
		useRoughLines = roughLinesControl.getState();
		useFills = useFillsControl.getState();

		controlsVisible = false;
		cp5.hide();
		
	}
	
	void draw() {
		fill(50, 150);
		noStroke();
		rect(50, 50, 400, 650, 8);
		
		if(controlsVisible && !cp5.isVisible()){
			cp5.show();
		} 
	}

	boolean printSizeDidChange() {
		return (
			PRINT_W_INCHES != widthControl.getValue() || 
			PRINT_H_INCHES != heightControl.getValue() ||
			GRID_W != int(colsControl.getValue())||
			GRID_H != int(rowsControl.getValue()) ||
			MARGIN_INCHES != marginControl.getValue()
		);
	}
	
	void controlEvent(ControlEvent e) {
		if(controlsVisible){
			boolean updateSizes = printSizeDidChange();

			PRINT_W_INCHES = widthControl.getValue();
			PRINT_H_INCHES = heightControl.getValue();
			MARGIN_INCHES = marginControl.getValue();
			GRID_W = int(colsControl.getValue());
			GRID_H = int(rowsControl.getValue());
			penSizeMM = penSizeControl.getValue();
			strokeSize = calculateStrokeSize();
			minLength = int(minLengthControl.getValue());
			maxLength = int(maxLengthControl.getValue());

			useTwists = twistControl.getState();
			useJoiners = joinControl.getState();
			allowOverlap = overlapControl.getState();
			numNoodles = int(numNoodlesControl.getValue());
			noodleThicknessPct = thicknessControl.getValue();
			randomizeEnds = randomizeEndsControl.getState();
			useRoughLines = roughLinesControl.getState();
			useFills = useFillsControl.getState();

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