
void drawInfoPanel() {
    fill(50, 150);
    noStroke();
    rect(8, 8, 264, 300, 8);

    fill(255);
    
    textFont(menloFont);
    textAlign(LEFT, TOP);
    text("       SIZE: " + PRINT_W_INCHES + " × " + PRINT_H_INCHES, 32, 24);
    text("     MARGIN: " + MARGIN_INCHES+"\"", 32, 40);
    text("       GRID: " + GRID_W + " × " + GRID_H, 32, 64);
    text("    NOODLES: " + numNoodles, 32, 88);
    text("  THICKNESS: " + round(noodleThicknessPct * 100) + "%", 32, 104);
    text("     LENGTH: " + minLength + " min, " + maxLength + " max", 32, 120);
    text("   PEN SIZE: " + penSizeMM + " mm", 32, 152);
    booleanText("     TWISTS: ", useTwists, 32, 184);
    booleanText("      JOINS: ", useJoiners, 32, 200);
    booleanText("   OVERLAPS: ", allowOverlap, 32, 216);
    booleanText("RANDOM ENDS: ", randomizeEnds, 32, 232);

}

String getCheckMark(boolean val) {
    if(val){
        return "✖️";
    } else {
        return " ";
    }
}

void booleanText(String txt, boolean isOn, int px, int py) {
    if(isOn){
        fill(255);
    } else {
        fill(100);
    }

    text(txt + getCheckMark(isOn), px, py);
}