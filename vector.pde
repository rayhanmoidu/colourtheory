class Vector {
  int a, b, c;
  int start_a, start_b, start_c;
  float weight = 0;
  boolean hasChanged = false;
  //Mixbox mixbox = new Mixbox();
  
  Vector(int one, int two, int three) {
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
      // for black in light mode, need to make a override toggle
    ` // use percents not raw vals, 001 should be 100% fac_c, 000 100% all
      // for ovverride, facs are all 1
      float fac_a = float(new_a) / 255;
      float fac_b = float(new_b) / 255;
      float fac_c = float(new_c) / 255;
      
      float colorsum = new_a + new_b + new_c;
      
      //float fac_a = float(new_a) / colorsum;
      //float fac_b = float(new_b) / colorsum;
      //float fac_c = float(new_c) / colorsum;
      //float fac_a = int(new_a > 0);
      //float fac_b = int(new_b > 0);
      //float fac_c = int(new_c > 0);
      if (colorsum == 0) {
        fac_a = 1;
        fac_b = 1;
        fac_c = 1;
      }
      
      

      
      //if (new_a < 255 && new_b < 255 && new_c < 255) {

      ////print(fac_a, fac_b, fac_c, "\n");
      //}
      
      float finalWeight_a = weight * 1;
      float finalWeight_b = weight * 1;
      float finalWeight_c = weight * 1;
      
      a = round( finalWeight_a*new_a + (1-finalWeight_a)*start_a );
      b = round( finalWeight_b*new_b + (1-finalWeight_b)*start_b );
      c = round( finalWeight_c*new_c + (1-finalWeight_c)*start_c );
  }
  
  float[] encode(float a, float b, float c) {
    float[] c_arr = unmix(a, b, c);
    float[] mixed_c = mix(c_arr[0], c_arr[1], c_arr[2]);
    float[] r = {a - mixed_c[0], b - mixed_c[1], c - mixed_c[2]};
    float[] z = {c_arr[0], c_arr[1], c_arr[2], r[0], r[1], r[2]};
    return z;
  }
  
  float[] decode(float[] z) {
    float[] mixed_c = mix(z[0], z[1], z[2]);
    float[] retVal = {mixed_c[0] + z[3], mixed_c[1] + z[4], mixed_c[2] + z[5]};
    return retVal;
  }
  
  float[] mix(float a, float b, float c) {
    float[] retVal = {1, 1, 1};
    return retVal;
  }
  
  float[] unmix(float a, float b, float c) {
    float[] retVal = {1, 1, 1};
    return retVal;
  }
  
  void merge_pigment(int new_a, int new_b, int new_c, float u2, byte[] lut) {
    
    if (!hasChanged) {
      hasChanged = true;
    }
    
    float[] new_color = {float(new_a)/255, float(new_b)/255, float(new_c)/255};
    float[] start_color = {float(start_a)/255, float(start_b)/255, float(start_c)/255};
    //if (new_color[2]> 0) {
    //  print(start_color[0], start_color[1], start_color[2], new_color[0], new_color[1], new_color[2], "\n");
    //}
    float[] res = Mixbox.lerpFloat(start_color, new_color, weight, lut);
    //print(res[0], res[1], res[2], weight, "\n");
    ////print(res[0]*255, res[1]*255, res[2]*255, "\n");
    ////float[] new_z = encode(new_a, new_b, new_c);
    ////float[] start_z = encode(start_a, start_b, start_c);
    
    ////float merged_1 = weight*new_z[0] + (1-weight)*start_z[0];
    ////float merged_2 = weight*new_z[1] + (1-weight)*start_z[1];
    ////float merged_3 = weight*new_z[2] + (1-weight)*start_z[2];
    ////float merged_4 = weight*new_z[3] + (1-weight)*start_z[3];
    ////float merged_5 = weight*new_z[4] + (1-weight)*start_z[4];
    ////float merged_6 = weight*new_z[5] + (1-weight)*start_z[5];
    ////float[] final_merge = {merged_1, merged_2, merged_3, merged_4, merged_5, merged_6};
    
    ////float[] decoded = decode(final_merge);
    a = round(res[0]*255);
    b = round(res[1]*255);
    c = round(res[2]*255);
    //print(a, b, c, "\n");
    //a = round(decoded[0]);
    //b = round(decoded[1]);
    //c = round(decoded[2]);
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
