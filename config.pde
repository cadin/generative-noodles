// ### SELECT & LOAD CONFIG ###
void selectConfigFile() {
	selectInput("Load config file", "onConfigSelected", dataFile("config"));
}

void reloadCurrentData() {
	loadConfigFile(configPath, "");
}

void onConfigSelected(File config) {
	// shiftIsDown = false;
	if(config == null) return;
	
	String filePath = config.getAbsolutePath();
	String fileName = config.getName();
	String relativePath = new File(sketchPath("")).toURI().relativize(new File(filePath).toURI()).getPath();
	
	// remove extension from filename
	fileName = fileName.substring(0, fileName.length() - 5);
	
	if(filePath.toLowerCase().endsWith(".json")){
		loadConfigFile(relativePath, fileName);
		configPath = relativePath;
		updateSettingsFile();
	}
}

void parseConfigObject(JSONObject obj) {
	if(!obj.isNull("printWidthInches")){
		PRINT_W_INCHES = obj.getFloat("printWidthInches");
	}
	if(!obj.isNull("printHeightInches")) {
		PRINT_H_INCHES = obj.getFloat("printHeightInches");
	}
	if(!obj.isNull("printResolution")) {
		PRINT_RESOLUTION = obj.getInt("printResolution");
	}
	if(!obj.isNull("gridWidth")){
		GRID_W = obj.getInt("gridWidth");
	}
	if(!obj.isNull("gridHeight")){
		GRID_H = obj.getInt("gridHeight");
	}
	if(!obj.isNull("marginInches")){
		MARGIN_INCHES = obj.getFloat("marginInches");
	}
	if(!obj.isNull("useTwists")){
		useTwists = obj.getBoolean("useTwists");
	}
	if(!obj.isNull("useJoiners")){
		useJoiners = obj.getBoolean("useJoiners");
	}
	if(!obj.isNull("useCurves")){
		useCurves = obj.getBoolean("useCurves");
	}
	if(!obj.isNull("penSizeMM")){
		penSizeMM = obj.getFloat("penSizeMM");
		strokeSize = calculateStrokeSize();
	}
	if(!obj.isNull("blackoutCells")){
		blackoutCells = new int[GRID_W][GRID_H];
		JSONArray cellsArray = obj.getJSONArray("blackoutCells");
		for(int col = 0; col < GRID_W; col++){
			JSONArray rowArray = cellsArray.getJSONArray(col);
			for(int row = 0; row < GRID_H; row++){
				blackoutCells[col][row] = rowArray.getInt(row);
			}
		}

	}

}

void loadConfigFile(String filePath, String fileName) {
	// removeLayers();

	JSONObject obj = null;
	JSONArray layerData = null;
	
	try {
		obj = loadJSONObject(filePath);
	} catch(Exception e) {
		println("Error: loaded data is not a JSON object");
	}
	
	if(obj != null) {
		parseConfigObject(obj);
		// layerData = obj.getJSONArray("layers");
	} else {
		// layerData = loadJSONArray(filePath);
	}
	
	// updateCanvas();
	reset();
	
	// numLayers = layerData.size();
	// createLayersWithData(layerData, loadImagePositions);
}

void updateSettingsFile() {
	println("Update settings: ");
	println(configPath);
	JSONObject json = new JSONObject();
	json.setString("configPath", configPath);
	saveJSONObject(json, "data/" + SETTINGS_PATH);
}

void loadSettings(String filePath) {

	JSONObject settings = loadJSONObject(filePath);
	if(!settings.isNull("configPath")){
		String path = settings.getString("configPath");
		File f = new File(sketchPath(path));
		if (f.exists()) {
			configPath = path;
		} else {
			println("! ERROR: config file doesn't exist. Using default.");
		}
	}
}