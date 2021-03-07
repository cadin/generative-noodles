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

	JSONArray getBlackoutCellArray() {
		JSONArray cellArray = new JSONArray();
		for(int col = 0; col < blackoutCells.length; col++){
			JSONArray rowArray = new JSONArray();
			for(int row = 0; row < blackoutCells[0].length; row++){
				rowArray.append(blackoutCells[col][row]);
			}
			cellArray.append(rowArray);
		}
		return cellArray;
	}

	JSONArray getGraphicSetsArray() {
		JSONArray graphicsArray = new JSONArray();
		for(int i = 0; i < graphicSets.length; i++){
			JSONObject set = new JSONObject();
			set.setString("head", graphicSets[i].headPath);
			set.setString("tail", graphicSets[i].tailPath);

			if(graphicSets[i].joinerPaths != null){
				JSONArray joinsArray = new JSONArray();
				for(int j = 0; j < graphicSets[i].joinerPaths.length; j++){
					joinsArray.setString(j, graphicSets[i].joinerPaths[j]);
				}
				set.setJSONArray("joiners", joinsArray);
			}

			graphicsArray.setJSONObject(i, set);
		}
		return graphicsArray;
	}
	
	void saveImageData(String filename) {
		print("writing data file... ");
		
		JSONArray cellArray = getBlackoutCellArray();
		JSONArray graphicsArray = getGraphicSetsArray();
		
		JSONObject obj = new JSONObject();
		obj.setJSONArray("blackoutCells", cellArray);
		obj.setFloat("printWidthInches", PRINT_W_INCHES);
		obj.setFloat("printHeightInches", PRINT_H_INCHES);
		obj.setInt("printResolution", PRINT_RESOLUTION);
		obj.setInt("gridWidth", GRID_W);
		obj.setInt("gridHeight", GRID_H);
		obj.setFloat("marginInches", MARGIN_INCHES);
		obj.setBoolean("useTwists", useTwists);
		obj.setBoolean("useJoiners", useJoiners);
		obj.setFloat("noodleThicknessPct", noodleThicknessPct);
		obj.setInt("numNoodles", numNoodles);
		obj.setJSONArray("graphics", graphicsArray);
		obj.setBoolean("randomizeEnds", randomizeEnds);
		saveJSONObject(obj, "output/" + filename + ".json");
		// saveJSONArray(layersArray, "output/" + filename + ".json");
		println("done.");
	}
}