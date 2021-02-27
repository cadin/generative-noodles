class ImageSaver {

	SaveState state = SaveState.NONE;
	String filenameToSave;

	ImageSaver() {
		
	}
	
	void update() {
		switch (state) {
			case BEGAN:
				println("Saving SVG file... ");
				state = SaveState.SAVING;
			break;
			case RENDER_BEGAN:
				state = SaveState.RENDERING;
			break;
			case SAVING:
				saveImageData(fileNameToSave);
				state = SaveState.COMPLETE;
			break;
			case RENDERING:
				// runRenderQueue();
			break;
			case COMPLETE:
				println("DONE!");
				state = SaveState.NONE;
			break;	
		}
	}
	
	boolean isBusy() {
		return state == SaveState.BEGAN || 
		       state == SaveState.SAVING || 
		       state == SaveState.RENDER_BEGAN || 
		       state == SaveState.RENDERING;
	}
	
	void begin(String filename) {
		filenameToSave = filename;
		state = SaveState.BEGAN;
	}
	
	void saveImageData(String filename) {
		print("writing data file... ");
		
		// JSONArray paths = new JSONArray();
		
		
		JSONObject obj = new JSONObject();

		obj.setFloat("printWidthInches", PRINT_W_INCHES);
		obj.setFloat("printHeightInches", PRINT_H_INCHES);
		obj.setInt("printResolution", PRINT_RESOLUTION);
		obj.setInt("gridWidth", GRID_W);
		obj.setInt("gridHeight", GRID_H);
		obj.setFloat("marginInches", MARGIN_INCHES);
		obj.setBoolean("useTwists", useTwists);
		obj.setBoolean("useJoiners", useJoiners);
		
		saveJSONObject(obj, "output/" + filename + ".json");
		// saveJSONArray(layersArray, "output/" + filename + ".json");
		println("done.");
	}
}