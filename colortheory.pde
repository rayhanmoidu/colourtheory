boolean mouselocked = false;

int w = 1200;
int h = 800;
int panel_width = 240;

int colorgrid_width = w - panel_width;
int colorgrid_height = h;
Vector[][] emptyColorGrid = new Vector[colorgrid_width][colorgrid_height];
Vector[][] colorGrid = new Vector[colorgrid_width][colorgrid_height];
int colorgrid_hoffset = 240;
int colorgrid_voffset = 0;

int cur_color_a = 0;
int cur_color_b = 0;
int cur_color_c = 0;

Button[] baseColors = new Button[6];
int numColors = 5;
int curSelectedColor = 0;

Button[] incrementors = new Button[4];
int numIncrementors = 4;

Button[] rectangleButtons = new Button[6];
int numRectangleButtons = 6;


int radius_circle = 55;
float leftover_space = panel_width - (2 * radius_circle);
float color_gapX = leftover_space / 3;
float color_gapY = 75;
int numColorRows = (numColors / 2) + (numColors % 2);
float buttonWidth = 40;
float buttonHeight = 15;
float buttonGap = (panel_width - 3*buttonWidth) / 5;
float colorbox_dimension = panel_width / 2;
float colorbox_gap = (colorbox_dimension - radius_circle) / 2;

float hbarrier1_y = color_gapX*2 + radius_circle + (numColorRows - 1)*color_gapY;
float hbarrier2_y = hbarrier1_y + color_gapX * 3;
float hbarrier3_y = hbarrier2_y + color_gapX + buttonHeight;
float hbarrier4_y = hbarrier3_y + colorbox_dimension - colorbox_gap + color_gapX + buttonHeight;
float hbarrier5_y = hbarrier4_y + colorbox_dimension;
float vbarrier1_x = buttonGap*2 + buttonWidth;
float vbarrier2_x = colorbox_dimension;
float vbarrier3_x = colorbox_dimension;


int sliderMargin = 24;

int numOpacityLevels = 10;
int curOpacityLevel = 5;
float opacityFactor = 0.0005;

int numRadiusLevels = 10;
int curRadiusLevel = 5;
float radiusFactor = 10;

int laststamp_x = -1;
int laststamp_y = -1;
int spacing = 1;

boolean isDrawMode = true;

Mixbox mixbox;

float[] destinationColor = {-1, -1, -1};
float[] sampleColor = {-1, -1, -1};
float[] winningColor = {-1, -1, -1};

int sampleRadius = 3;
float finalResult = -1;
int numCorrect = 0;
int numGoals = 0;
boolean hasWonThisRound = false;

void setup() {
  mixbox = new Mixbox();
  size(1200, 800);
  setupDefaultColors();
  setRandomDestinationColor();
  
  for (int i = 0; i < colorgrid_width; i++) {
    for (int j = 0; j < colorgrid_height; j++) {
      emptyColorGrid[i][j] = new Vector(255,255, 255);
    }
  }
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

void setRandomDestinationColor() {
  destinationColor[0] = random(0, 255);
  destinationColor[1] = random(0, 255);
  destinationColor[2] = random(0, 255);
  numGoals ++;
  finalResult = -1;
  hasWonThisRound = false;
}

Vector[][] copyCanvasColors(Vector[][] src, Vector[][] dest) {
  for (int i = 0; i < colorgrid_width; i++) {
    for (int j = 0; j < colorgrid_height; j++) {
      dest[i][j].a = src[i][j].a;
      dest[i][j].b = src[i][j].b;
      dest[i][j].c = src[i][j].c;
    }
  }
  return dest;
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
    Button newcolor = new Button("circle", colors[i][0], colors[i][1], colors[i][2], (color_gapX*gapMult) + (radius_circle * xMult), color_gapX + (radius_circle / 2) + color_gapY * (i / 2), radius_circle, radius_circle);
    baseColors[i] = newcolor;
  }
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
  drawHBarrier(hbarrier1_y);
  drawSlider(hbarrier1_y, curOpacityLevel, "opacity", 0);
  drawSlider(hbarrier1_y + color_gapX, curRadiusLevel, "radius", 2);
  drawHBarrier(hbarrier2_y);
  
  drawButton(buttonGap, hbarrier2_y + color_gapX/2, buttonWidth, buttonHeight, "Reset", true, 0);
  drawVBarrier(vbarrier1_x, hbarrier2_y, hbarrier3_y);
  drawButton(buttonGap*3 + buttonWidth, hbarrier2_y + color_gapX/2, buttonWidth, buttonHeight, "Draw", isDrawMode, 1);
  drawButton(buttonGap*4 + buttonWidth*2, hbarrier2_y + color_gapX/2, buttonWidth, buttonHeight, "Sample", !isDrawMode, 2);
  drawHBarrier(hbarrier3_y);
  drawHBarrier(hbarrier4_y);
  drawHBarrier(hbarrier5_y);
  drawVBarrier(vbarrier2_x, hbarrier3_y, hbarrier4_y);
  drawVBarrier(vbarrier3_x, hbarrier4_y, hbarrier5_y);
  drawColor(true);
  drawColor(false);
  drawButton(colorbox_dimension/2 - buttonWidth/2, hbarrier3_y + colorbox_dimension - colorbox_gap + color_gapX/2, buttonWidth, buttonHeight, "Refresh", true, 3);
  float samplebutton_gap = (colorbox_dimension - buttonWidth*2) / 3;
  drawButton(colorbox_dimension + samplebutton_gap, hbarrier3_y + colorbox_dimension - colorbox_gap + color_gapX/2, buttonWidth, buttonHeight, "Submit", true, 4);
  drawButton(colorbox_dimension + samplebutton_gap*2 + buttonWidth, hbarrier3_y + colorbox_dimension - colorbox_gap + color_gapX/2, buttonWidth, buttonHeight, "Save", true, 5);
  drawScore();
  drawResult();
  //drawButtonS
}

void drawResult() {
  if (finalResult == -1) {
    return;
  }
  int numDigits = finalResult >= 10 ? finalResult >= 100 ? 3 : 2 : 1;
  String finalres_string = nf(finalResult, numDigits, 0) + "%";
  textSize(32);
  if (finalResult >= 95) {
    fill(winningColor[0], winningColor[1], winningColor[2]);    
    text(finalres_string, colorbox_dimension*1.5, hbarrier4_y + colorbox_dimension/2 - 20);
    //fill(255 - sampleColor[0], 255 - sampleColor[1], 255 - sampleColor[2]);
    textSize(24);
    text("YAY!", colorbox_dimension*1.5, hbarrier4_y + colorbox_dimension/2 + 20);
    
  } else {
    fill(0);
    text(finalres_string, colorbox_dimension*1.5, hbarrier4_y + colorbox_dimension/2 - 20);
    //fill(255, 255, 255);
    textSize(24);
    text("Oh no :(", colorbox_dimension*1.5, hbarrier4_y + colorbox_dimension/2 + 20);
  }
}

void drawScore() {
  textSize(32);
  strokeWeight(2);
  float result_fractionWidth = 24;
  text(numCorrect, colorbox_dimension/2, hbarrier4_y + colorbox_dimension/2 - 20);
  line(colorbox_dimension/2 - result_fractionWidth/2, hbarrier4_y + colorbox_dimension/2, colorbox_dimension/2 + result_fractionWidth/2, hbarrier4_y + colorbox_dimension/2);
  text(numGoals, colorbox_dimension/2, hbarrier4_y + colorbox_dimension/2 + 20);
}

void drawColor(boolean isDestination) {
  if (isDestination) {
    fill(destinationColor[0], destinationColor[1], destinationColor[2]);
    stroke(destinationColor[0], destinationColor[1], destinationColor[2]);
    circle(colorbox_dimension / 2, hbarrier3_y + colorbox_dimension / 2, radius_circle);
  } else {
    if (sampleColor[0]==-1 && sampleColor[1]==-1 && sampleColor[2]==-1) {
      stroke(0);
      fill(175);
      circle(colorbox_dimension * 1.5, hbarrier3_y + colorbox_dimension / 2, radius_circle);
    } else {
      fill(sampleColor[0], sampleColor[1], sampleColor[2]);
      stroke(sampleColor[0], sampleColor[1], sampleColor[2]);
      circle(colorbox_dimension * 1.5, hbarrier3_y + colorbox_dimension / 2, radius_circle);
    }
  }
  stroke(0);
}

void drawVBarrier(float xPos, float startYPos, float endYPos) {
  stroke(0, 0, 0);
  strokeWeight(1);
  line(xPos, startYPos, xPos, endYPos);
}

void drawHBarrier(float yPos) {
  stroke(0, 0, 0);
  strokeWeight(1);
  line(0, yPos, panel_width-1, yPos);
}

void drawButton(float xPos, float yPos, float rectw, float recth, String id, boolean isEnabled, int index) {
  fill(236);
  rectMode(CORNER);
  rect(xPos, yPos, rectw, recth);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(10);
  text(id, xPos + rectw/2, yPos + recth/2);
  
  Button newRectangleButton = new Button("rectangle", 0, 0, 0, xPos + rectw/2, yPos + recth/2, rectw, recth, id, false);
  rectangleButtons[index] = newRectangleButton;
  
  if (!isEnabled) {
    fill(0, 125);
    rect(xPos, yPos, rectw, recth);
  }
}

void drawSlider(float yPos, float value, String sliderId, int buttonStartIndex) {
  stroke(0, 0, 0);
  strokeWeight(2);
  float outerTickLength = 5;
  float innerTickLength = 3;
  float innerTickGap = (panel_width - 2*color_gapX - 2*sliderMargin) / numOpacityLevels;
  
  // Opacity slider
  // Main line
  line(color_gapX + sliderMargin, yPos + color_gapX, panel_width - color_gapX - sliderMargin, yPos + color_gapX);
  // Outer ticks
  line(color_gapX + sliderMargin, yPos + color_gapX - outerTickLength, color_gapX + sliderMargin, yPos + color_gapX + outerTickLength);
  line(panel_width - color_gapX - sliderMargin, yPos + color_gapX - outerTickLength, panel_width - color_gapX - sliderMargin, yPos + color_gapX + outerTickLength);
  // Inner ticks
  strokeWeight(1);
  for (int i = 1; i <= numOpacityLevels; i++) {
    line(color_gapX + sliderMargin + innerTickGap*i, yPos + color_gapX - innerTickLength, color_gapX + sliderMargin + innerTickGap*i, yPos + color_gapX + innerTickLength);
  }
  // Value indicator
  strokeWeight(3);
  stroke(255, 255, 0);
  line(color_gapX + sliderMargin + 3, yPos + color_gapX, color_gapX + sliderMargin + innerTickGap*value, yPos + color_gapX);
  
  // Incrementors
  // circles
  fill(236);
  strokeWeight(0);
  circle(color_gapX + sliderMargin/2, yPos + color_gapX, 12);
  circle(panel_width - color_gapX - sliderMargin/2, yPos + color_gapX, 12);
  Button opacity_minus_indicator = new Button("circle", 236, 236, 236, color_gapX + sliderMargin/2, yPos + color_gapX, 12, 12, sliderId, false);
  Button opacity_plus_indicator = new Button("circle", 236, 236, 236, panel_width - color_gapX - sliderMargin/2, yPos + color_gapX, 12, 12, sliderId, true);
  incrementors[buttonStartIndex] = opacity_minus_indicator;
  incrementors[buttonStartIndex+1] = opacity_plus_indicator;

  // plus / minus
  strokeWeight(1);
  stroke(2);
  line(color_gapX + sliderMargin/2 - 3, yPos + color_gapX, color_gapX + sliderMargin/2 + 3, yPos + color_gapX);
  line(panel_width - color_gapX - sliderMargin/2 - 3, yPos + color_gapX, panel_width - color_gapX - sliderMargin/2 + 3, yPos + color_gapX);
  line(panel_width - color_gapX - sliderMargin/2, yPos + color_gapX - 3, panel_width - color_gapX - sliderMargin/2, yPos + color_gapX + 3);
}

void drawColors() {
  for (int i = 0; i < numColors; i++) {
    if (i==curSelectedColor) {
      stroke(255, 255, 0);
      fill(255, 255, 0);
      circle(baseColors[i].getX(), baseColors[i].getY(), radius_circle + 6);
    }
    stroke(baseColors[i].getColor());
    fill(baseColors[i].getColor());
    circle(baseColors[i].getX(), baseColors[i].getY(), radius_circle);
  }
  if (numColors==5) {
      strokeWeight(1);
      stroke(0);
      fill(175);
      circle((color_gapX*2) + (radius_circle * 1.5), color_gapX + (radius_circle / 2) + color_gapY * (2), radius_circle);
  }
}

float distFromLastStamp(int x, int y) {
  float diffx = x - laststamp_x;
  float diffy = y - laststamp_y;
  return sqrt(diffx*diffx + diffy*diffy);
}

void sampleColor(int x, int y) {
  int bbox_minx = max(x - sampleRadius, 0);
  int bbox_miny = max(y - sampleRadius, 0);
  int bbox_maxx = min(x + sampleRadius, colorgrid_width);
  int bbox_maxy = min(y + sampleRadius, colorgrid_height);
  
  float asum = 0;
  float bsum = 0;
  float csum = 0;
  int numPixels = 0;
  
  for (int i = bbox_minx; i < bbox_maxx; i++) {
    for (int j = bbox_miny; j < bbox_maxy; j++) {
      int diffx = x - i;
      int diffy = y - j;
      float diff = sqrt(diffx*diffx + diffy*diffy);
      if (diff <= sampleRadius) {
        numPixels += 1;
        asum += colorGrid[i][j].a;
        bsum += colorGrid[i][j].b;
        csum += colorGrid[i][j].c;
      }
    }
  }
  
  sampleColor[0] = asum / numPixels;
  sampleColor[1] = bsum / numPixels;
  sampleColor[2] = csum / numPixels;
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
  int radius = getRadius();
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
        colorGrid[i][j].merge_pigment(cur_color_a, cur_color_b, cur_color_c, u2, mixbox);
        //print("yes\n");
      }
    }
  }
}

void incrementOpacity(boolean isPlus) {
  if (isPlus) {
    curOpacityLevel += 1;
    if (curOpacityLevel > numOpacityLevels) {
      curOpacityLevel -= 1;
    }
  } else {
    curOpacityLevel -= 1;
    if (curOpacityLevel < 0) {
      curOpacityLevel += 1;
    }
  }
}

int getRadius() {
  return round(radiusFactor * curRadiusLevel);
}

void incrementRadius(boolean isPlus) {
  if (isPlus) {
    curRadiusLevel += 1;
    if (curRadiusLevel > numRadiusLevels) {
      curRadiusLevel -= 1;
    }
  } else {
    curRadiusLevel -= 1;
    if (curRadiusLevel < 0) {
      curRadiusLevel += 1;
    }
  }
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
        isDrawMode = true;
        curSelectedColor = i;
        cur_color_a = baseColors[i].getA();
        cur_color_b = baseColors[i].getB();
        cur_color_c = baseColors[i].getC();
      }
    }
    for (int i = 0; i < numIncrementors; i++) {
      if (incrementors[i].testClick(mouseX, mouseY)) {
        if (incrementors[i].buttonId == "opacity") {
          incrementOpacity(incrementors[i].isPlus);
        } else if (incrementors[i].buttonId == "radius") {
          incrementRadius(incrementors[i].isPlus);
        }
      }
    }
    for (int i = 0; i < numRectangleButtons; i++) {
      if (rectangleButtons[i].testClick(mouseX, mouseY)) {
        if (rectangleButtons[i].buttonId == "Reset") {
          colorGrid = copyCanvasColors(emptyColorGrid, colorGrid);
        } else if (rectangleButtons[i].buttonId == "Draw") {
          isDrawMode = true;
        } else if (rectangleButtons[i].buttonId == "Sample") {
          isDrawMode = false;
        } else if (rectangleButtons[i].buttonId == "Refresh") {
          setRandomDestinationColor();
        } else if (rectangleButtons[i].buttonId == "Submit") {
          submitSample();
        } else if (rectangleButtons[i].buttonId == "Save") {
          saveSampleColor();
        }
      }
    }
  }
}

void saveSampleColor() {
  numColors = min(6, numColors+1);
  Button newcolor = new Button("circle", int(sampleColor[0]), int(sampleColor[1]), int(sampleColor[2]), (color_gapX*2) + (radius_circle * 1.5), color_gapX + (radius_circle / 2) + color_gapY * (2), radius_circle, radius_circle);
  baseColors[5] = newcolor;
}

void submitSample() {
  if (sampleColor[0]==-1 && sampleColor[1]==-1 && sampleColor[2]==-1) {
    return;
  }
  float diff_a = (255 - abs(destinationColor[0]-sampleColor[0])) / 255;
  float diff_b = (255 - abs(destinationColor[1]-sampleColor[1])) / 255;
  float diff_c = (255 - abs(destinationColor[2]-sampleColor[2])) / 255;
  float res = round( ((diff_a + diff_b + diff_c) / 3 ) * 100);
  finalResult = res;
  
  if (finalResult >= 95 && !hasWonThisRound) {
    hasWonThisRound = true;
    numCorrect++;
    winningColor[0] = sampleColor[0];
    winningColor[1] = sampleColor[1];
    winningColor[2] = sampleColor[2];
  }
}

void mouseDragged() {
  if (mouselocked) {
    if (isDrawMode) {
      extendStroke(mouseX - colorgrid_hoffset, mouseY - colorgrid_voffset);
    } else {
      sampleColor(mouseX - colorgrid_hoffset, mouseY - colorgrid_voffset);
    }
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
