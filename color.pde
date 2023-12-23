class Button {
  int a, b, c = 0;
  float cX, cY = 0;
  float radius = 0;
  String sliderId = "";
  boolean isPlus = false;
  
  Button(int aa, int bb, int cc, float cx, float cy, float r) {
    a = aa;
    b = bb;
    c = cc;
    cX = cx;
    cY = cy;
    radius = r/2;
  }
  
  Button(int aa, int bb, int cc, float cx, float cy, float r, String sliderid, boolean isplus) {
    a = aa;
    b = bb;
    c = cc;
    cX = cx;
    cY = cy;
    radius = r/2;
    sliderId = sliderid;
    isPlus = isplus;
  }
  
  color getColor() {
    return color(a, b, c);
  }
  
  float getX() {
    return cX;
  }
  
  float getY() {
    return cY;
  }
  
  boolean testClick(float x, float y) {
    float diffx = x - cX;
    float diffy = y - cY;
    float diff = sqrt(diffx*diffx + diffy*diffy);
    return diff < radius;
  }
  
  int getA() {
    return a;
  }
  
  int getB() {
    return b;
  }
  
  int getC() {
    return c;
  }

}
