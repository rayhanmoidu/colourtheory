boolean mouselocked = false;

int w = 700;
int h = 500;
int colorgrid_width = 500;
int colorgrid_height = 500;
Vector[][] colorGrid;
int colorgrid_hoffset = 200;
int colorgrid_voffset = 0;

int cur_color_a = 0;
int cur_color_b = 0;
int cur_color_c = 0;

Button[] baseColors = new Button[6];
int numColors = 5;
int curSelectedColor = 0;

Button[] incrementors = new Button[4];
int numIncrementors = 2;

int panel_width = 200;
int radius_circle = 55;
float leftover_space = panel_width - (2 * radius_circle);
float color_gapX = leftover_space / 3;
float color_gapY = 75;
int numColorRows = (numColors / 2) + (numColors % 2);
float barrier1_y = color_gapX*2 + radius_circle + (numColorRows - 1)*color_gapY;
int sliderMargin = 24;

int numOpacityLevels = 5;
int curOpacityLevel = 1;
float opacityFactor = 0.005;

int numRadiusLevels = 5;
int curRadiusLevel = 1;
float radiusFactor = 25;
int radius = round(radiusFactor * curRadiusLevel);

int laststamp_x = -1;
int laststamp_y = -1;
int spacing = 3;

void setup() {
  print(color_gapX);
  size(700, 500);
  setupDefaultColors();
  
  colorGrid = new Vector[colorgrid_width][colorgrid_height];
  for (int i = 0; i < colorgrid_width; i++) {
    for (int j = 0; j < colorgrid_height; j++) {
      colorGrid[i][j] = new Vector(255, 255, 255);
    }
  }
  
  cur_color_a = baseColors[curSelectedColor].getA();
  cur_color_b = baseColors[curSelectedColor].getB();
  cur_color_c = baseColors[curSelectedColor].getC();
  
  rectMode(RADIUS);  
}

void setupDefaultColors() {
  int[] red = {255, 0, 0};
  int[] blue = {0, 0, 255};
  int[] green = {0, 255, 0};
  int[] black = {0, 0, 0};
  int[] white = {255, 255, 255};
  
  int[][] colors = {red, blue, green, black, white};
    
  for (int i = 0; i < colors.length; i++) {
    float xMult = (i%2==0) ? 0.5 : 1.5;
    float gapMult = (i%2==0) ? 1 : 2;
    print(color_gapX + (radius_circle / 2) + color_gapY * (i / 2), "\n");
    Button newcolor = new Button(colors[i][0], colors[i][1], colors[i][2], (color_gapX*gapMult) + (radius_circle * xMult), color_gapX + (radius_circle / 2) + color_gapY * (i / 2), radius_circle);
    baseColors[i] = newcolor;
  }
  
  //baseColors[0] = red;
  //baseColors[1] = blue;
  //baseColors[2] = green;
  //baseColors[3] = black;
  //baseColors[4] = white;
  
  //for (int i = 0; i < 10; i++) {
  //  print("\n", baseColors[i].length);
  //}
}

void draw() {
  background(175);
  
  // Canvas
  for (int i = 0; i < colorgrid_width; i++) {
    for (int j = 0; j < colorgrid_height; j++) {
      set(colorgrid_hoffset + i, colorgrid_voffset + j, colorGrid[i][j].getColor());
    }
  }
  
  // Control Panel
  drawColors();
  drawBarrier(barrier1_y);
  drawSliders();
    
}

void drawBarrier(float yPos) {
  stroke(0, 0, 0);
  strokeWeight(1);
  line(0, yPos, panel_width, barrier1_y);
}

void drawSliders() {
  stroke(0, 0, 0);
  strokeWeight(2);
  float outerTickLength = 5;
  float innerTickLength = 3;
  float innerTickGap = (panel_width - 2*color_gapX - 2*sliderMargin) / numOpacityLevels;
  
  // Opacity slider
  // Main line
  line(color_gapX + sliderMargin, barrier1_y + color_gapX, panel_width - color_gapX - sliderMargin, barrier1_y + color_gapX);
  // Outer ticks
  line(color_gapX + sliderMargin, barrier1_y + color_gapX - outerTickLength, color_gapX + sliderMargin, barrier1_y + color_gapX + outerTickLength);
  line(panel_width - color_gapX - sliderMargin, barrier1_y + color_gapX - outerTickLength, panel_width - color_gapX - sliderMargin, barrier1_y + color_gapX + outerTickLength);
  // Inner ticks
  strokeWeight(1);
  for (int i = 1; i <= numOpacityLevels; i++) {
    line(color_gapX + sliderMargin + innerTickGap*i, barrier1_y + color_gapX - innerTickLength, color_gapX + sliderMargin + innerTickGap*i, barrier1_y + color_gapX + innerTickLength);
  }
  // Value indicator
  strokeWeight(3);
  stroke(255, 255, 0);
  line(color_gapX + sliderMargin + 3, barrier1_y + color_gapX, color_gapX + sliderMargin + innerTickGap*curOpacityLevel, barrier1_y + color_gapX);
  
  // Incrementors
  // circles
  fill(236);
  strokeWeight(0);
  circle(color_gapX + sliderMargin/2, barrier1_y + color_gapX, 12);
  circle(panel_width - color_gapX - sliderMargin/2, barrier1_y + color_gapX, 12);
  Button opacity_minus_indicator = new Button(236, 236, 236, color_gapX + sliderMargin/2, barrier1_y + color_gapX, 12, "opacity", true);
  Button opacity_plus_indicator = new Button(236, 236, 236, panel_width - color_gapX - sliderMargin/2, barrier1_y + color_gapX, 12, "opacity", false);
  incrementors[0] = opacity_minus_indicator;
  incrementors[1] = opacity_plus_indicator;

  // plus / minus
  strokeWeight(1);
  stroke(2);
  line(color_gapX + sliderMargin/2 - 3, barrier1_y + color_gapX, color_gapX + sliderMargin/2 + 3, barrier1_y + color_gapX);
  line(panel_width - color_gapX - sliderMargin/2 - 3, barrier1_y + color_gapX, panel_width - color_gapX - sliderMargin/2 + 3, barrier1_y + color_gapX);
  line(panel_width - color_gapX - sliderMargin/2, barrier1_y + color_gapX - 3, panel_width - color_gapX - sliderMargin/2, barrier1_y + color_gapX + 3);
}

void drawColors() {
  for (int i = 0; i < numColors; i++) {
    if (i==curSelectedColor) {
      stroke(255, 255, 0);
      fill(255, 255, 0);
      circle(baseColors[i].getX(), baseColors[i].getY(), radius_circle + 5);
    }
    stroke(baseColors[i].getColor());
    fill(baseColors[i].getColor());
    circle(baseColors[i].getX(), baseColors[i].getY(), radius_circle);
  }
}

float distFromLastStamp(int x, int y) {
  float diffx = x - laststamp_x;
  float diffy = y - laststamp_y;
  return sqrt(diffx*diffx + diffy*diffy);
}

void extendStroke(int x, int y) {
  if (x >= 0 && x <= colorgrid_width && y >= 0 && y <= colorgrid_height) {
    if (laststamp_x == -1 && laststamp_y == -1) {
      placeStamp(x, y);
    } else {
        float diffx = x - laststamp_x;
        float diffy = y - laststamp_y;
        float distFromLastStamp = sqrt(diffx*diffx + diffy*diffy);
        
        if (distFromLastStamp > spacing) {
          int numStamps = floor(distFromLastStamp / spacing);
          diffx /= numStamps;
          diffy /= numStamps;
          int startSpot_x = laststamp_x;
          int startSpot_y = laststamp_y;
          for (int i = 1; i <= numStamps; i++) {
            int newx = round(startSpot_x + diffx*i);
            int newy = round(startSpot_y + diffy*i);
            placeStamp(newx, newy);
          }
        }
    }
  }
}

void placeStamp(int x, int y) {
  laststamp_x = x;
  laststamp_y = y;
  int bbox_minx = max(x - radius, 0);
  int bbox_miny = max(y - radius, 0);
  int bbox_maxx = min(x + radius, colorgrid_width);
  int bbox_maxy = min(y + radius, colorgrid_height);
  // make max coords for bbox and factor in screen size for no overflow
  
  for (int i = bbox_minx; i < bbox_maxx; i++) {
    for (int j = bbox_miny; j < bbox_maxy; j++) {
      int diffx = x - i;
      int diffy = y - j;
      float diff = sqrt(diffx*diffx + diffy*diffy);
      if (diff <= radius) {
        float u2 = (diff*diff) / (radius*radius);
        colorGrid[i][j].accumulateWeight(u2, opacityFactor * curOpacityLevel);
        colorGrid[i][j].merge_light(cur_color_a, cur_color_b, cur_color_c, u2);
      }
    }
  }
}

void incrementOpacity(boolean isPlus) {
  print("hehe\n");
  curOpacityLevel = isPlus ? min(numOpacityLevels, curOpacityLevel + 1) : max(1, curOpacityLevel - 1);
}

void incrementRadius(boolean isPlus) {
  curRadiusLevel = isPlus ? min(numRadiusLevels, curRadiusLevel + 1) : max(1, curRadiusLevel - 1);
}

void mousePressed() {
  if (mouseX > colorgrid_hoffset) {
    mouselocked = true;
    for (int i = 0; i < colorgrid_width; i++) {
      for (int j = 0; j < colorgrid_height; j++) {
        colorGrid[i][j].setStartColors();
      }
    }
  } else {
    for (int i = 0; i < numColors; i++) {
      if (baseColors[i].testClick(mouseX, mouseY)) {
        curSelectedColor = i;
        cur_color_a = baseColors[i].getA();
        cur_color_b = baseColors[i].getB();
        cur_color_c = baseColors[i].getC();
      }
    }
    for (int i = 0; i < numButtons; i++) {
      print("hello \n",);
      if (incrementors[i].testClick(mouseX, mouseY)) {
        print("goodbye \n");
        if (incrementors[i].sliderId == "opacity") {
          print("lala \n");
          incrementOpacity(incrementors[i].isPlus);
        } else if (incrementors[i].sliderId == "radius") {
          incrementRadius(incrementors[i].isPlus);
        }
      }
    }
  }
}

void mouseDragged() {
  if (mouselocked) {
    extendStroke(mouseX - colorgrid_hoffset, mouseY - colorgrid_voffset);
  }
}

void mouseReleased() {
  laststamp_x = -1;
  laststamp_y = -1;
  mouselocked = false;
  for (int i = 0; i < colorgrid_width; i++) {
    for (int j = 0; j < colorgrid_height; j++) {
      colorGrid[i][j].resetWeight();
    }
  }
}
