// Row major.

static class Matrix3x3
{
  float[] E;
  
  Matrix3x3(float[] ma)
  {
    Set(ma);
  }
  
  Matrix3x3() 
  {
    Set(new float[]
    {
      1, 0, 0,
      0, 1, 0,
      0, 0, 1
    });
  }
  
  float Get(int i, int j)
  {
    return E[i*3 + j];
  }
  
  void Set(float[] ma)
  {
    E = ma;
  }
  
  float Determinant()
  {
    float a = E[0], b = E[1], c = E[2];
    float d = E[3], e = E[4], f = E[5];
    float g = E[6], h = E[7], i = E[8];
    
    return a*e*i + b*f*g + c*d*h - c*e*g - b*d*i - a*f*h;
  }
  
  void Inverse() 
  {
    float[] inv = new float[9];
    float det;
    float a = E[0], b = E[1], c = E[2];
    float d = E[3], e = E[4], f = E[5];
    float g = E[6], h = E[7], i = E[8];
    
    inv[0] = e*i - f*h; inv[1] = c*h - b*i; inv[2] = b*f - c*e;
    inv[3] = f*g - d*i; inv[4] = a*i - c*g; inv[5] = c*d - a*f;
    inv[6] = d*h - e*g; inv[7] = b*g - a*h; inv[8] = a*e - b*d;
    
    det = 1 / (a*e*i + b*f*g + c*d*h - c*e*g - b*d*i - a*f*h);
    
    if (det == 0)
        throw new Error("Not exist inverse");
        
    for (int t = 0; t < 9; t++)
        E[t] = inv[t] * det;
  }
  
  void Transpose()
  {
    E = Transpose(E);
  }
  
  static Matrix3x3 Transpose(Matrix3x3 m)
  {
    Matrix3x3 r = new Matrix3x3(m.E);
    r.Transpose();
    return r;
  }
  
  static float[] Transpose(float[] ma)
  {
    float[] r = new float[ma.length];
    
    for(int i=0;i<3;++i)
    {
      for(int j=0;j<3;++j)
      {
        r[j * 3 + i] = ma[i * 3 + j];
      }
    }
    return r;
  }
  
  static Matrix4x4 Multiply(Matrix4x4 m0, Matrix4x4 m1)
  {
    return new Matrix4x4(Multiply(m0.E, m1.E)); 
  }
  
  static float[] Multiply(float[] m0, float[] m1)
  {
    float[] r = new float[m0.length];
    
    for(int i=0;i<3;++i)
    {
      for(int j=0;j<3;++j)
      {
        r[i * 3 + j] = (m0[i*3] * m1[j]) + (m0[i*3 + 1] * m1[j + 3]) + (m0[i*3 + 2] * m1[j + 6]); 
      }
    }
    return r;
  }
}
 
static class Matrix4x4
{
  float[] E;
  
  Matrix4x4(float[] ma)
  {
    Set(ma);
  }
  
  Matrix4x4() 
  {
    Set(new float[]
    {
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1
    });
  }
  
  float Get(int i, int j)
  {
    return E[i*4 + j];
  }
  
  void Set(float[] ma)
  {
    E = ma;
  }
  
  float Determinant()
  {
    float a = E[0], b = E[1], c = E[2], d = E[3];
    float e = E[4], f = E[5], g = E[6], h = E[7];
    float i = E[8], j = E[9], k = E[10], l = E[11];
    float m = E[12], n = E[13], o = E[14], p = E[15];
    
    float ret = a*f*k*p - a*f*l*o - a*g*i*p + a*g*l*n + a*h*j*o - a*h*k*n - b*e*k*p + b*e*l*o + b*g*i*p
              - b*g*l*m - b*h*i*o + b*h*k*m + c*e*j*p - c*e*l*n - c*f*i*p + c*f*l*m + c*h*i*n - c*h*j*m 
              - d*e*j*o + d*e*k*n + d*f*i*o - d*f*k*m - d*g*i*n + d*g*j*m;
    
    return ret;
  }
  
  // http://msparkms.tistory.com/entry/2x2-3x3-4x4-%EC%97%AD%ED%96%89%EB%A0%AC-%EA%B3%B5%EC%8B%9D
  void Inverse()
  {
    float[] inv = new float[16];
    float det;
    
    float a = E[0],  b = E[1],  c = E[2],  d = E[3];
    float e = E[4],  f = E[5],  g = E[6],  h = E[7];
    float i = E[8],  j = E[9],  k = E[10], l = E[11];
    float m = E[12], n = E[13], o = E[14], p = E[15];
    
    // a=11, b=12, c=13, d=14
    // e=21, f=22, g=23, h=24
    // i=31, j=32, k=33, l=34
    // m=41, n=42, o=43, p=44
    
    // f=22, g=23, h=24
    // j=32, k=33, l=34
    // n=42, o=43, p=44
    
    // b=12, c=13, d=14
    // j=32, k=33, l=34
    // n=42, o=43, p=44
    
    // b=12, c=13, d=14
    // f=22, g=23, h=24
    // n=42, o=43, p=44
    
    // b=12, c=13, d=14
    // f=22, g=23, h=24
    // j=32, k=33, l=34
    
    inv[0] = f*k*p + g*l*n + h*j*o - f*l*o - g*j*p - h*k*n;
    inv[1] = b*l*o + c*j*p + d*k*n - b*k*p - c*l*n - d*j*o;
    inv[2] = b*g*p + c*h*n + d*f*o - b*h*o - c*f*p - d*g*n;
    inv[3] = b*h*k + c*f*l + d*g*j - b*g*l - c*h*j - d*f*k;
    
    // e=21, g=23, h=24
    // i=31, k=33, l=34
    // m=41, o=43, p=44
    
    // a=11, c=13, d=14
    // i=31, k=33, l=34
    // m=41, o=43, p=44
    
    // a=11, c=13, d=14
    // e=21, g=23, h=24
    // m=41, o=43, p=44
    
    // a=11, c=13, d=14
    // e=21, g=23, h=24
    // i=31, k=33, l=34
    
    inv[4] = e*l*o + g*i*p + h*k*m - e*k*p - g*l*m - h*i*o;
    inv[5] = a*k*p + c*l*m + d*i*o - a*l*o - c*i*p - d*k*m;
    inv[6] = a*h*o + c*e*p + d*g*m - a*g*p - c*h*m - d*e*o;
    inv[7] = a*g*l + c*h*i + d*e*k - a*h*k - c*e*l - d*g*i;
    
    // e=21, f=22, h=24
    // i=31, j=32, l=34
    // m=41, n=42, p=44
    
    // a=11, b=12, d=14
    // i=31, j=32, l=34
    // m=41, n=42, p=44
    
    // a=11, b=12, d=14
    // e=21, f=22, h=24
    // m=41, n=42, p=44
    
    // a=11, b=12, d=14
    // e=21, f=22, h=24
    // i=31, j=32, l=34
    
    inv[8] = e*j*p + f*l*m + h*i*n - e*l*n - f*i*p - h*j*m;
    inv[9] = a*l*n + b*i*p + d*j*m - a*j*p - b*l*m - d*i*n;
    inv[10] = a*f*p + b*h*m + d*e*n - a*h*n - b*e*p - d*f*m;
    inv[11] = a*h*j + b*e*l + d*f*i - a*f*l - b*h*i - d*e*j;
    
    // e=21, f=22, g=23
    // i=31, j=32, k=33
    // m=41, n=42, o=43
    
    // a=11, b=12, c=13
    // i=31, j=32, k=33
    // m=41, n=42, o=43
    
    // a=11, b=12, c=13
    // e=21, f=22, g=23
    // m=41, n=42, o=43
    
    // a=11, b=12, c=13
    // e=21, f=22, g=23
    // i=31, j=32, k=33
    
    inv[12] = e*k*n + f*i*o + g*j*m - e*j*o - f*k*m - g*i*n;
    inv[13] = a*j*o + b*k*m + c*i*n - a*k*n - b*i*o - c*j*m;
    inv[14] = a*g*n + b*e*o + c*f*m - a*f*o - b*g*m - c*e*n;
    inv[15] = a*f*k + b*g*i + c*e*j - a*g*j - b*e*k - c*f*i;
    
    /*
    // column major
    inv[0] = f*k*p - f*l*o - j*g*p + j*h*o + n*g*l - n*h*k;
    inv[1] = -b*k*p + b*l*o + j*c*p - j*d*o - n*c*l + n*d*k;
    inv[2] = b*g*p - b*h*o - f*c*p + f*d*o + n*c*h - n*d*g;
    inv[3] = -b*g*l + b*h*k + f*c*l - f*d*k - j*c*h + j*d*g;
    inv[4] = -e*k*p + e*l*o + i*g*p - i*h*o - m*g*l + m*h*k;
    inv[5] = a*k*p - a*l*o - i*c*p + i*d*o + m*c*l - m*d*k;
    inv[6] = -a*g*p + a*h*o + e*c*p - e*d*o - m*c*h + m*d*g;
    inv[7] = a*g*l - a*h*k - e*c*l + e*d*k + i*c*h - i*d*g;
    inv[8] = e*j*p - e*l*n - i*f*p + i*h*n + m*f*l - m*h*j;
    inv[9] = -a*j*p + a*l*n + i*b*p - i*d*n - m*b*l + m*d*j;
    inv[10] = a*f*p - a*h*n - e*b*p + e*d*n + m*b*h - m*d*f;
    inv[11] = -a*f*l + a*h*j + e*b*l - e*d*j - i*b*h + i*d*f;
    inv[12] = -e*j*o + e*k*n + i*f*o - i*g*n - m*f*k + m*g*j;
    inv[13] = a*j*o - a*k*n - i*b*o + i*c*n + m*b*k - m*c*j;
    inv[14] = -a*f*o + a*g*n + e*b*o - e*c*n - m*b*g + m*c*f;
    inv[15] = a*f*k - a*g*j - e*b*k + e*c*j + i*b*g - i*c*f;
    */
    det = a*f*k*p - a*f*l*o - a*g*i*p + a*g*l*n + a*h*j*o - a*h*k*n - b*e*k*p + b*e*l*o + b*g*i*p
              - b*g*l*m - b*h*i*o + b*h*k*m + c*e*j*p - c*e*l*n - c*f*i*p + c*f*l*m + c*h*i*n - c*h*j*m 
              - d*e*j*o + d*e*k*n + d*f*i*o - d*f*k*m - d*g*i*n + d*g*j*m;
              
    if (det == 0)
        throw new Error("Not exist inverse");
    det = 1 / det;
    
    for (int t = 0; t < 16; t++)
        E[t] = inv[t] * det;
  }
  
  void Transpose()
  {
    Set(Matrix4x4.Transpose(E));
  }
  
  static float[] Transpose(float[] ma)
  {
    float[] r = new float[ma.length];
    
    for(int i=0;i<4;++i)
    {
      for(int j=0;j<4;++j)
      {
        r[j * 4 + i] = ma[i * 4 + j];
      }
    }
    return r;
  }
  
  static Matrix4x4 Transpose(Matrix4x4 m)
  {
    Matrix4x4 r = new Matrix4x4(m.E);
    r.Transpose();
    return r;
  }
  
  PVector TransformVector(PVector p)
  {
    PVector r = new PVector(); 
    r.x = E[0] * p.x + E[1] * p.y + E[2] * p.z + E[3] * 1;
    r.y = E[4] * p.x + E[5] * p.y + E[6] * p.z + E[7] * 1;
    r.z = E[8] * p.x + E[9] * p.y + E[10] * p.z + E[12] * 1;
    
    return r;
  }
  
  PVector TransformPoint(PVector p)
  {
    PVector r = new PVector(); 
    r.x = E[0] * p.x + E[1] * p.y + E[2] * p.z + E[3] * 1;
    r.y = E[4] * p.x + E[5] * p.y + E[6] * p.z + E[7] * 1;
    r.z = E[8] * p.x + E[9] * p.y + E[10] * p.z + E[11] * 1;
    float w = E[12] * p.x + E[13] * p.y + E[14] * p.z + E[15] * 1;
    
    if(w != 1) {
      r.z /= w;
      r.x /= w;
      r.y /= w;
    }
    return r;
  }

  static Matrix4x4 Multiply(Matrix4x4 m0, Matrix4x4 m1)
  {
    return new Matrix4x4(Multiply(m0.E, m1.E)); 
  }
  
  static float[] Multiply(float[] m0, float[] m1)
  {
    float[] r = new float[m0.length];
    
    for(int i=0;i<4;++i)
    {
      for(int j=0;j<4;++j)
      {
        r[i * 4 + j] = (m0[i*4] * m1[j]) + (m0[i*4 + 1] * m1[j + 4]) + (m0[i*4 + 2] * m1[j + 8]) + (m0[i*4 + 3] * m1[j + 12]); 
      }
    }
    return r;
  }
}