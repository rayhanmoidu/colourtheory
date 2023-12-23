class Button {
  String type = "";
  int a, b, c = 0;
  float cX, cY = 0;
  float w, h = 0;
  String buttonId = "";
  boolean isPlus = false;
  
  Button(String buttonType, int aa, int bb, int cc, float cx, float cy, float ww, float hh) {
    type = buttonType;
    a = aa;
    b = bb;
    c = cc;
    cX = cx;
    cY = cy;
    w = ww;
    h = hh;
  }
  
  Button(String buttonType, int aa, int bb, int cc, float cx, float cy, float ww, float hh, String buttonid, boolean isplus) {
    type = buttonType;
    a = aa;
    b = bb;
    c = cc;
    cX = cx;
    cY = cy;
    w = ww;
    h = hh;
    buttonId = buttonid;
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
    if (type=="circle") {
      float diffx = x - cX;
      float diffy = y - cY;
      float diff = sqrt(diffx*diffx + diffy*diffy);
      return diff < (w/2);
    } else if (type=="rectangle") {
      boolean insideX = (x >= (cX - w/2)) && (x <= (cX + w/2));
      boolean insideY = (y >= (cY - h/2)) && (y <= (cY + h/2));
      return insideX && insideY;
    }
    return false;
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
