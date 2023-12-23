class Vector {
  int a, b, c;
  int start_a, start_b, start_c;
  float weight = 0;
  float factor = 0.005;
  
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
      a = round( weight*new_a + (1-weight)*start_a );
      b = round( weight*new_b + (1-weight)*start_b );
      c = round( weight*new_c + (1-weight)*start_c );
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
  
  void merge_pigment(int new_a, int new_b, int new_c, float u2) {
    float[] new_z = encode(new_a, new_b, new_c);
    float[] start_z = encode(start_a, start_b, start_c);
    
    float merged_1 = weight*new_z[0] + (1-weight)*start_z[0];
    float merged_2 = weight*new_z[1] + (1-weight)*start_z[1];
    float merged_3 = weight*new_z[2] + (1-weight)*start_z[2];
    float merged_4 = weight*new_z[3] + (1-weight)*start_z[3];
    float merged_5 = weight*new_z[4] + (1-weight)*start_z[4];
    float merged_6 = weight*new_z[5] + (1-weight)*start_z[5];
    float[] final_merge = {merged_1, merged_2, merged_3, merged_4, merged_5, merged_6};
    
    float[] decoded = decode(final_merge);
    a = round(decoded[0]);
    b = round(decoded[1]);
    c = round(decoded[2]);
  }
  
  void setStartColors() {
    start_a = a;
    start_b = b;
    start_c = c;
  }
  
  void accumulateWeight(float u2, float opacity) {
    weight += (1-weight) * opacity;
    weight = min(1, weight);
  }
  
  void resetWeight() {
    weight = 0;
  }
  
  color getColor() {
    return color(a, b, c);
  }
}
