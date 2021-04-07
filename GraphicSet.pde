class GraphicSet {

    String headPath;
    String tailPath;
    String[] joinerPaths;

    PShape head;
    PShape tail;
    PShape[] joiners;

    GraphicSet(JSONObject obj){
        if(!obj.isNull("head")){
            headPath = obj.getString("head");
        }
        if(!obj.isNull("tail")){
            tailPath = obj.getString("tail");
        }

        if(!obj.isNull("joiners")){
            JSONArray joins = obj.getJSONArray("joiners");
            joinerPaths = new String[joins.size()];
            for(int i = 0; i < joins.size(); i++) {
                joinerPaths[i] = joins.getString(i);
            }
        }
    }

    void loadShapes() {
        if(headPath != null){
            head = loadShape(headPath);
            head.disableStyle();
        }

        if(tailPath != null){
            tail = loadShape(tailPath);
            tail.disableStyle();
        } else {
            tail = head;
        }

        if(joinerPaths != null && joinerPaths.length > 0){
            joiners = new PShape[joinerPaths.length];
            for(int i = 0; i < joinerPaths.length; i++){
                try {
                    joiners[i] = loadShape(joinerPaths[i]);
                    joiners[i].disableStyle();
                } catch(Exception e) {
                    println("Joiner shape not found: " + joinerPaths[i]);
                }
            }
        }
    }
}