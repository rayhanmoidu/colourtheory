boolean mouselocked = false;

void setup() {
  size(500, 500);
  rectMode(RADIUS);  
}

void draw() {
  background(0);
}

void mousePressed() {
  mouselocked = true;
}

void mouseDragged() {
  if (mouselocked) {
  }
}

void mouseReleased() {
  mouselocked = false;
}
