class CanvasPixel {
  int a, b, c;
  int start_a, start_b, start_c;
  float weight = 0;
  boolean hasChanged = false;
  
  CanvasPixel(int one, int two, int three) {
    a = one;
    b = two;
    c = three;
  }
  
  float bias(float val, float param) {
    if (val == 0 || param == 0) {
      return 0;
    }
    if (val==1 || param==1) {
      return 1;
    }
    return (val / ((((1.0/param) - 2.0)*(1.0 - val))+1.0));
  }
   
  void merge_light(int new_a, int new_b, int new_c, float u2) {
      if (!hasChanged) {
        hasChanged = true;
      }

      float fac_a = float(new_a) / 255;
      float fac_b = float(new_b) / 255;
      float fac_c = float(new_c) / 255;
      
      float colorsum = new_a + new_b + new_c;

      if (colorsum == 0) {
        fac_a = 1;
        fac_b = 1;
        fac_c = 1;
      }

      float finalWeight_a = weight * 1;
      float finalWeight_b = weight * 1;
      float finalWeight_c = weight * 1;
      
      a = round( finalWeight_a*new_a + (1-finalWeight_a)*start_a );
      b = round( finalWeight_b*new_b + (1-finalWeight_b)*start_b );
      c = round( finalWeight_c*new_c + (1-finalWeight_c)*start_c );
  }
  
  void merge_pigment(int new_a, int new_b, int new_c, float u2, byte[] lut) {
    if (!hasChanged) {
      hasChanged = true;
    }
    
    float[] new_color = {float(new_a)/255, float(new_b)/255, float(new_c)/255};
    float[] start_color = {float(start_a)/255, float(start_b)/255, float(start_c)/255};
    float[] res = Mixbox.lerpFloat(start_color, new_color, weight, lut);
    
    a = round(res[0]*255);
    b = round(res[1]*255);
    c = round(res[2]*255);
  }
  
  void setStartColors() {
    start_a = a;
    start_b = b;
    start_c = c;
  }
  
  void accumulateWeight(float u2, float opacity) {
    weight += (1-weight) * (opacity) * (1-u2);
    weight = min(1, weight);
  }
  
  void resetWeight() {
    weight = 0;
  }
  
  color getColor() {
    return color(a, b, c);
  }
}
