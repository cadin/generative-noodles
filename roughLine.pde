int variance = 3;
int smoothness = 20;

void roughLineH(int px, int py, float width) {
    
    float scale = width / 100;

    PVector p1 = new PVector(px, py);
    PVector mid = new PVector(px + width / 2, (random(-variance, variance) * scale) + py);

    PVector c1 = new PVector(px + (smoothness * scale), py);
    PVector c2 = new PVector(mid.x - (20 * scale), mid.y);

    PVector c3 = new PVector(mid.x + (20 * scale), mid.y);
    PVector c4 = new PVector(px + width - (smoothness * scale), py);

    PVector p2 = new PVector(px + width, py);
    
    drawRoughLine(p1, c1, c2, mid, c3, c4, p2);
}
    

void roughLineV(int px, int py, float height) {
    float scale = height / 100;

    PVector p1 = new PVector(px, py);
    PVector mid = new PVector( (random(-variance, variance) * scale) + px, py + height / 2);

    PVector c1 = new PVector(px, py + (smoothness * scale));
    PVector c2 = new PVector(mid.x, mid.y - (20 * scale));

    PVector c3 = new PVector( mid.x, mid.y + (20 * scale) );
    PVector c4 = new PVector(px, py + height - (smoothness * scale));

    PVector p2 = new PVector(px, py + height);
    
    drawRoughLine(p1, c1, c2, mid, c3, c4, p2);
}

void drawRoughLine(PVector p1, PVector c1, PVector c2, PVector mid, PVector c3, PVector c4, PVector p2) {
    stroke(0);
    bezier(p1.x,p1.y,   c1.x,c1.y,  c2.x,c2.y,  mid.x,mid.y);
    bezier(mid.x,mid.y, c3.x,c3.y,  c4.x,c4.y,  p2.x, p2.y);

}