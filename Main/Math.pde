static class Vector2f
{
  public static final Vector2f Zero = new Vector2f(0, 0);
  
  public static final Vector2f Right = new Vector2f(1, 0);
  
  public static final Vector2f Up = new Vector2f(0, 1);
  
  float x;
  float y;
  
  Vector2f()
  {
    x = 0;
    y = 0;
  }
  
  Vector2f(int x, int y)
  {
    this.x = (float)x;
    this.y = (float)y;
  }
  
  Vector2f(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  Vector2f(PVector v)
  {
    this.x = v.x;
    this.y = v.y;
  }
  
  Vector2f(Vector2f v)
  {
    this.x = v.x;
    this.y = v.y;
  }
  
  void Add(Vector2f v)
  {
    x += v.x;
    y += v.y;
  }
  
  void Sub(Vector2f v)
  {
    x -= v.x;
    y -= v.y;
  }
  
  void Scale(float s)
  {
    x *= s;
    y *= s;
  }
  
  void Normalize()
  {
    float mag = Magnitude();
    x = x / mag;
    y = y / mag;
  }
  
  float Magnitude()
  {
    return sqrt(x * x + y * y);
  }
  
  float SqrMagnitude()
  {
    return x * x + y * y;
  }
  
  PVector ToVector3()
  {
    return new PVector(x, y, 0);
  }
  
  static Vector2f Add(Vector2f v0, Vector2f v1)
  {
    return new Vector2f(v0.x + v1.x, v0.y + v1.y);
  }
  
  static Vector2f Sub(Vector2f v0, Vector2f v1)
  {
    return new Vector2f(v0.x - v1.x, v0.y - v1.y);
  }
  
  static float Dot(Vector2f v0, Vector2f v1)
  {
    return v0.x * v1.x + v0.y * v1.y;
  }
  
  static float Cross(Vector2f v0, Vector2f up)
  {
    return v0.x * up.y - up.x * v0.y;
  }
  
  static float Distance(Vector2f v0, Vector2f v1)
  {
    Vector2f v = Vector2f.Sub(v1, v0);
    return v.Magnitude();
  }
  
  static Vector2f Divide(Vector2f v0, Vector2f v1)
  {
    return new Vector2f(v0.x / v1.x, v0.y / v1.y);
  }
  
  static float Angle(Vector2f v0, Vector2f v1)
  {
    float sin = v0.x * v1.y - v1.x * v0.y; // cross
    float cos = v0.x * v1.x + v0.y * v1.y; // dot

    return atan2(sin, cos) * (180 / PI);
  }
  
  static Vector2f Normalize(Vector2f v)
  {
    float mag = v.Magnitude();
    return new Vector2f(v.x / mag, v.y / mag);
  }
  
  static Vector2f Project(Vector2f v, Vector2f n)
  {
    Vector2f r = Normalize(n);
    r.Scale(Dot(v, r));
    return r;
  }
  
  static Vector2f Lerp(Vector2f s, Vector2f e, float t)
  {
    return new Vector2f(lerp(s.x, e.x, t), lerp(s.y, e.y, t));
  }
  
  static Vector2f Scale(Vector2f v, float s)
  {
    return new Vector2f(v.x * s, v.y * s);
  }
}

static class Vector3f extends Vector2f 
{
  public static final Vector3f Zero = new Vector3f(0, 0, 0);
  
  public static final Vector3f Right = new Vector3f(1, 0, 0);
  
  public static final Vector3f Left = new Vector3f(-1, 0, 0);
  
  public static final Vector3f Up = new Vector3f(0, 1, 0);
  
  public static final Vector3f Down = new Vector3f(0, -1, 0);
  
  public static final Vector3f Forward = new Vector3f(0, 0, 1);
  
  public static final Vector3f Backward = new Vector3f(0, 0, -1);
  
  float z;
  
  Vector3f()
  {
    x = 0;
    y = 0;
    z = 0;
  }
  
  Vector3f(float x, float y)
  {
    this.x = x;
    this.y = y;
    z = 0;
  }
  
  Vector3f(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  void Normalize()
  {
    float mag = Magnitude();
    x = x / mag;
    y = y / mag;
    z = z / mag;
  }
  
  float Magnitude()
  {
    return sqrt(x * x + y * y + z * z);
  }
  
  float SqrMagnitude()
  {
    return x * x + y * y + z * z;
  }
  
  static Vector3f Normalize(Vector3f v)
  {
    float mag = v.Magnitude();
    Vector3f r = new Vector3f();
    r.x = v.x / mag;
    r.y = v.y / mag;
    r.z = v.z / mag;
    
    return r;
  }
  
  static Vector3f Add(Vector3f v0, Vector3f v1)
  {
    return new Vector3f(v0.x + v1.x, v0.y + v1.y, v0.z + v1.z);
  }
  
  static Vector3f Sub(Vector3f v0, Vector3f v1)
  {
    return new Vector3f(v0.x - v1.x, v0.y - v1.y, v0.z - v1.z);
  }
  
  static float Dot(Vector3f v0, Vector3f v1)
  {
    return v0.x * v1.x + v0.y * v1.y + v0.z * v1.z;
  }
  
  static Vector3f Cross(Vector3f v0, Vector3f v1)
  {
    return new Vector3f(v0.y * v1.z - v0.z * v1.y, v0.z * v1.x - v0.x * v1.z, v0.x * v1.y - v0.y * v1.x);
  }
  
  static Vector3f Project(Vector3f v, Vector3f n)
  {
    Vector3f r = Normalize(n);
    r.Scale(Dot(v, r));
    return r;
  }
  
  static Vector3f Lerp(Vector3f s, Vector3f e, float t)
  {
    return new Vector3f(lerp(s.x, e.x, t), lerp(s.y, e.y, t), lerp(s.z, e.z, t));
  }
  
  static Vector3f Scale(Vector3f v, float s)
  {
    return new Vector3f(v.x * s, v.y * s, v.z * s);
  }
}


static class Vector4f extends Vector3f 
{
  float w;
  
  Vector4f() { }
  
  Vector4f(Vector3f v)
  {
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
    this.w = 0;
  }
  
  Vector4f(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = 0;
  }
  
  Vector4f(float x, float y, float z, float w)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
  }
  
  void Normalize()
  {
    float mag = Magnitude();
    x = x / mag;
    y = y / mag;
    z = z / mag;
    w = w / mag;
  }
  
  float Magnitude()
  {
    return sqrt(x * x + y * y + z * z + w * w);
  }
  
  float SqrMagnitude()
  {
    return x * x + y * y + z * z + w * w;
  }
  
  static Vector4f Normalize(Vector4f v)
  {
    float mag = v.Magnitude();
    Vector4f r = new Vector4f();
    r.x = v.x / mag;
    r.y = v.y / mag;
    r.z = v.z / mag;
    r.w = v.w / mag;
    
    return r;
  }
  
  static Vector4f Add(Vector4f v0, Vector4f v1)
  {
    return new Vector4f(v0.x + v1.x, v0.y + v1.y, v0.z + v1.z, v0.w + v1.w);
  }
  
  static Vector4f Sub(Vector4f v0, Vector4f v1)
  {
    return new Vector4f(v0.x - v1.x, v0.y - v1.y, v0.z - v1.z, v0.w - v1.w);
  }
  
  static Vector4f Lerp(Vector4f s, Vector4f e, float t)
  {
    return new Vector4f(lerp(s.x, e.x, t), lerp(s.y, e.y, t), lerp(s.z, e.z, t), lerp(s.w, e.w, t));
  }
  
  static Vector3f Scale(Vector3f v, float s)
  {
    return new Vector3f(v.x * s, v.y * s, v.z * s);
  }
}

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
  
  static Matrix3x3 Multiply(Matrix3x3 m0, Matrix3x3 m1)
  {
    return new Matrix3x3(Multiply(m0.E, m1.E)); 
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
  
  
  Vector3f TransformVector(Vector3f p)
  {
    Vector3f r = new Vector3f(); 
    r.x = E[0] * p.x + E[1] * p.y + E[2] * p.z;
    r.y = E[3] * p.x + E[4] * p.y + E[5] * p.z;
    r.z = E[6] * p.x + E[7] * p.y + E[8] * p.z;
    return r;
  }
  
  Vector2f TransformPoint(Vector3f p)
  {
    Vector3f r = new Vector3f(); 
    r.x = E[0] * p.x + E[1] * p.y + E[2];
    r.y = E[4] * p.x + E[5] * p.y + E[6];
    
    float z = E[7] * p.x + E[8] * p.y + E[8];
    
    if(z != 1) {
      r.x /= z;
      r.y /= z;
    }
    return r;
  }
}

// It uses the column major convention. But when it is calculated, it uses row major like an OpenGL.
// https://www.scratchapixel.com/lessons/mathematics-physics-for-computer-graphics/geometry/row-major-vs-column-major-vector
// https://velitchko.wordpress.com/2013/02/04/basic-math-ii-welcome-to-the-matrix/
static class Matrix4x4
{
  public static final Matrix4x4 Identity = new Matrix4x4(new float[]{1, 0, 0, 0,
                                                                     0, 1, 0, 0,
                                                                     0, 0, 1, 0,
                                                                     0, 0, 0, 1 });
  
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
    
    /*
    r.x = E[0] * p.x + E[4] * p.y + E[8] * p.z + E[12] * 1;
    r.y = E[1] * p.x + E[5] * p.y + E[9] * p.z + E[13] * 1;
    r.z = E[2] * p.x + E[6] * p.y + E[10] * p.z + E[14] * 1;
    */
    return r;
  }
  
  PVector TransformPoint(PVector p)
  {
    PVector r = new PVector(); 
    
    r.x = E[0] * p.x + E[1] * p.y + E[2] * p.z + E[3] * 1;
    r.y = E[4] * p.x + E[5] * p.y + E[6] * p.z + E[7] * 1;
    r.z = E[8] * p.x + E[9] * p.y + E[10] * p.z + E[11] * 1;
    float w = E[12] * p.x + E[13] * p.y + E[14] * p.z + E[15] * 1;
    
    /*
    r.x = E[0] * p.x + E[4] * p.y + E[8] * p.z + E[12] * 1;
    r.y = E[1] * p.x + E[5] * p.y + E[9] * p.z + E[13] * 1;
    r.z = E[2] * p.x + E[6] * p.y + E[10] * p.z + E[14] * 1;
    float w = E[3] * p.x + E[7] * p.y + E[11] * p.z + E[15] * 1;
    */
    
    if(w != 1) 
    {
      r.x /= w;
      r.y /= w;
      r.z /= w;
    }
    return r;
  }
  
  // Opengl's convention.
  Vector3f TransformPoint(Vector3f p)
  {
    Vector3f r = new Vector3f(); 
    
    // column-major
    // [ 0 1  2  3 ][x]
    // [ 4 5  6  7 ][y]
    // [ 8 9 10 11 ][z]
    r.x = E[0] * p.x + E[1] * p.y + E[2] * p.z + E[3] * 1;
    r.y = E[4] * p.x + E[5] * p.y + E[6] * p.z + E[7] * 1;
    r.z = E[8] * p.x + E[9] * p.y + E[10] * p.z + E[11] * 1;
    float w = E[12] * p.x + E[13] * p.y + E[14] * p.z + E[15] * 1;
    
    /*
    // row-major
    r.x = E[0] * p.x + E[4] * p.y + E[8] * p.z + E[12] * 1;
    r.y = E[1] * p.x + E[5] * p.y + E[9] * p.z + E[13] * 1;
    r.z = E[2] * p.x + E[6] * p.y + E[10] * p.z + E[14] * 1;
    float w = E[3] * p.x + E[7] * p.y + E[11] * p.z + E[15] * 1;
    */
    
    if(w != 1) {
      r.x /= w;
      r.y /= w;
      r.z /= w;
    }
    return r;
  }
  
  static Matrix4x4 Multiply(Matrix4x4 m0, Matrix4x4 m1)
  {
    return new Matrix4x4(Multiply(m0.E, m1.E)); 
  }
  
  static Vector4f Multiply(Matrix4x4 m, Vector3f v)
  {
    Vector4f r = new Vector4f(); 
    r.x = m.E[0] * v.x + m.E[1] * v.y + m.E[2] * v.z + m.E[3] * 1; //<>//
    r.y = m.E[4] * v.x + m.E[5] * v.y + m.E[6] * v.z + m.E[7] * 1;
    r.z = m.E[8] * v.x + m.E[9] * v.y + m.E[10] * v.z + m.E[11] * 1;
    r.w = m.E[12] * v.x + m.E[13] * v.y + m.E[14] * v.z + m.E[15] * 1;
    return r;
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
  
  static Matrix4x4 Viewport(float x, float y, float w, float h)
  {
    float[] sm = new float[]
    {
      w, 0, 0, x + w * 0.5f,
      0, -h, 0, y + h * 0.5f,
      0, 0, 1, 0,
      0, 0, 0, 1
    };
    return new Matrix4x4(sm);
  }
  
  static Matrix4x4 LookAtRH(Vector3f eye, Vector3f target, Vector3f up)
  {
    Vector3f forward = Vector3f.Sub(eye, target);
    forward.Normalize();
    
    Vector3f right = Vector3f.Cross(forward, up);
    right.Normalize();
    
    Vector3f y = Vector3f.Cross(right, forward);
    Vector3f e = Vector3f.Scale(eye, -1);
    
    float[] m = new float[]
    {
      right.x, y.x, forward.x, Vector3f.Dot(right, e),
      right.y, y.y, forward.y, Vector3f.Dot(y, e),
      right.z, y.z, forward.z, Vector3f.Dot(forward, e),
      0, 0, 0, 1
    };
    return new Matrix4x4(m);
  }
  
  // https://www.gamedev.net/articles/programming/graphics/perspective-projections-in-lh-and-rh-systems-r3598/
  static Matrix4x4 Perspective(float fov, float aspect, float near, float far)
  {
    float n = near;
    float f = far;
    float t = tan(fov);
    float h = 1 / t; // cot
    
    float[] pm = new float[]
    {
      h / aspect , 0, 0, 0,
      0, h, 0, 0,
      0, 0, (n+f)/(n-f), (2*n*f) / (n-f),
      0, 0, -1, 0
    };
    
    return new Matrix4x4(pm);
  }
  
  static Matrix4x4 Perspective(int screenW, int screenH, float angle, float near, float far)
  {
    float fov = ((angle * 0.5f * PI) / 180f);
    float n = near;
    float f = far;
    float aspect = screenW/(float)screenH;
    float t = tan(fov);
    float h = 1 / t; // cot
    
    float[] pm = new float[]
    {
      h / aspect , 0, 0, 0,
      0, h, 0, 0,
      0, 0, (n+f)/(n-f), (2*n*f) / (n-f),
      0, 0, -1, 0
    };
    
    return new Matrix4x4(pm);
  }
  
  // X-Axis
  static Matrix4x4 Roll(float ang)
  {
    float rad = ang * (PI/180);
    Matrix4x4 rm = new Matrix4x4(new float[]
    {
      1, 0, 0, 0,
      0, cos(rad), -sin(rad), 0,
      0, sin(rad), cos(rad), 0,
      0, 0, 0, 1
    });
    return rm;
  }
  
  // Y-Axis
  static Matrix4x4 Pitch(float ang)
  {
    float rad = ang * (PI/180);
    Matrix4x4 rm = new Matrix4x4(new float[]
    {
      cos(rad), 0, sin(rad), 0,
      0, 1, 0, 0,
      -sin(rad), 0, cos(rad), 0,
      0, 0, 0, 1
    });
    return rm;
  }
  
  // Z-Axis
  static Matrix4x4 Yaw(float ang)
  {
    float rad = ang * (PI/180);
    Matrix4x4 rm = new Matrix4x4(new float[]
    {
      cos(rad), -sin(rad), 0, 0,
      sin(rad), cos(rad), 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1
    });
    return rm;
  }
  
  // Z-Axis
  static Matrix4x4 Translate(float x, float y, float z)
  {
    Matrix4x4 rm = new Matrix4x4(new float[]
    {
      1, 0, 0, x,
      0, 1, 0, y,
      0, 0, 1, z,
      0, 0, 0, 1
    });
    return rm;
  }
}


// https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation
// https://www.3dgep.com/understanding-quaternions/
// https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
// https://gist.github.com/shihyu/c5abf3ebff2f5f1cfd32a90968f04a3b
static class Quaternion 
{
  public static final Quaternion Identity = new Quaternion(1, 0, 0, 0);  
    
  float x, y, z, w;
  
  public Quaternion() { }
  
  public Quaternion(float w, float x, float y, float z)
  {
    this.x = x; this.y = y; this.z = z; this.w = w;
  }
  
  public Quaternion(PVector axis, float angle)
  {
    this.x = axis.x;
    this.y = axis.y;
    this.z = axis.z;
    this.w = angle;
  }
  
  // https://kr.mathworks.com/help/aeroblks/quaternionmultiplication.html
  public static Quaternion Multiply(Quaternion a, Quaternion b)
  {
    float q0 = a.w; float q1 = a.x; float q2 = a.y; float q3 = a.z;
    float r0 = b.w; float r1 = b.x; float r2 = b.y; float r3 = b.z;
    
    float t0 = (r0 * q0 - r1 * q1 - r2 * q2 - r3 * q3);
    float t1 = (r0 * q1 + r1 * q0 - r2 * q3 + r3 * q2);
    float t2 = (r0 * q2 + r1 * q3 + r2 * q0 - r3 * q1);
    float t3 = (r0 * q3 - r1 * q2 + r2 * q1 + r3 * q0);
    
    Quaternion ret = new Quaternion(t1, t2, t3, t0);
    
    return ret;
  }
  
  public static Vector3f Multiply(Quaternion q, Vector3f v)
  {
    float e1 = q.x * 2f;
    float e2 = q.y * 2f;
    float e3 = q.z * 2f;
    
    float e4 = q.x * e1;
    float e5 = q.y * e2;
    float e6 = q.z * e3;
    
    float e7 = q.x * e2;
    float e8 = q.x * e3;
    float e9 = q.y * e3;
    
    float e10 = q.w * e1;
    float e11 = q.w * e2;
    float e12 = q.w * e3;
    
    Vector3f r = new Vector3f();
    
    r.x = (1f - (e5 + e6)) * v.x + (e7 - e12) * v.y + (e8 + e11) * v.z;
    r.y = (e7 + e12) * v.x + (1 - (e4 + e6)) * v.y + (e9 - e10) * v.z;
    r.z = (e8 - e11) * v.z + (e9 + e10) * v.y + (1f - (e4 + e5)) * v.z;
    
    return r;
  }
  
  public static PVector Multiply(Quaternion q, PVector v)
  {
    float e1 = q.x * 2f;
    float e2 = q.y * 2f;
    float e3 = q.z * 2f;
    
    float e4 = q.x * e1;
    float e5 = q.y * e2;
    float e6 = q.z * e3;
    
    float e7 = q.x * e2;
    float e8 = q.x * e3;
    float e9 = q.y * e3;
    
    float e10 = q.w * e1;
    float e11 = q.w * e2;
    float e12 = q.w * e3;
    
    PVector r = new PVector();
    
    r.x = (1f - (e5 + e6)) * v.x + (e7 - e12) * v.y + (e8 + e11) * v.z;
    r.y = (e7 + e12) * v.x + (1 - (e4 + e6)) * v.y + (e9 - e10) * v.z;
    r.z = (e8 - e11) * v.z + (e9 + e10) * v.y + (1f - (e4 + e5)) * v.z;
    
    return r;
  }
  
  public void Normalize()
  {
    float mag = sqrt(w * w + x * x + y * y + z * z);
    w /= mag;
    x /= mag;
    y /= mag;
    z /= mag;
  }
  
  public Matrix4x4 ToMatrix()
  {
    float xx = x * x;
    float xy = x * y;
    float xz = x * z;
    float xw = x * w;

    float yy = y * y;
    float yz = y * z;
    float yw = y * w;

    float zz = z * z;
    float zw = z * w;

    float m00 = 1 - 2 * ( yy + zz );
    float m01 = 2 * ( xy - zw );
    float m02 = 2 * ( xz + yw );
    
    float m10 = 2 * ( xy + zw );
    float m11 = 1 - 2 * ( xx + zz );
    float m12 = 2 * ( yz - xw );
    
    float m20 = 2 * ( xz - yw );
    float m21 = 2 * ( yz + xw );
    float m22 = 1 - 2 * ( xx + yy );
    
    float[] a = new float[] 
    {
      m00, m01, m02, 0,
      m10, m11, m12, 0,
      m20, m21, m22, 0,
      0, 0, 0, 1
    };
    
    return new Matrix4x4(a);
  }
  
  public static Quaternion Normalize(Quaternion q) 
  {
    float mag = sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z);
    return new Quaternion(q.w / mag, q.x / mag, q.y / mag, q.z / mag);
  }
  
  public static Quaternion Euler(float x, float y, float z)
  {
    Quaternion r = new Quaternion();
    final float RAD = 0.0174532925f * 0.5f;
    float _x = x * RAD;
    float _y = y * RAD;
    float _z = z * RAD;

    float sinx = sin(_x);
    float siny = sin(_y);
    float sinz = sin(_z);
    
    float cosx = cos(_x);
    float cosy = cos(_y);
    float cosz = cos(_z);
    
    r.w = cosx * cosy * cosz + sinx * siny * sinz;
    r.x = sinx * cosy * cosz + cosx * siny * sinz;
    r.w = cosx * siny * cosz + sinx * cosy * sinz;
    r.w = cosx * cosy * sinz + sinx * siny * cosz;
    
    return r;
  }
  
  public PVector ToEulerAngle()
  {
    float ysqr = y * y;
    float t0 = 2.0 * (w * x + y * z);
    float t1 = 1.0 - 2.0 * (x * x + ysqr);
    float _x = atan2(t0, t1);
    
    // pitch (y-axis rotation)
    float t2 = 2.0 * (w * y - z * x);
    t2 = ((t2 > 1.0) ? 1.0 : t2);
    t2 = ((t2 < -1.0) ? -1.0 : t2);
    float _y = asin(t2);
    
    // yaw (z-axis rotation)
    float t3 = 2.0 * (w * z + x * y);
    float t4 = 1.0 - 2.0 * (ysqr + z * z);  
    float _z = atan2(t3, t4);
    
    return new PVector(_x, _y, _z);
  }
  
  public static Quaternion Conjugate(Quaternion q)
  {
    return new Quaternion(q.w, -1 * q.x, -1 * q.y, -1 * q.z); 
  }
  
  public static float Angle(Quaternion a, Quaternion b)
  {
    float r = acos((Quaternion.Multiply(b, Quaternion.Inverse(a)).w)) * 2.0f * 57.2957795f;
    if (r > 180.0f)
      return 360.0f - r;
    return r;
  }
  
  public static float Dot(Quaternion a, Quaternion b)
  {
    return a.w * b.w + a.x * b.x + a.y * b.y + a.z * b.z;
  }
  
  public static Quaternion Inverse(Quaternion q)
  {
    Quaternion r = new Quaternion();
    float s = q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z;
    float n = 1f / s;
    
    r.x = -q.x * n;
    r.y = -q.y * n;
    r.z = -q.z * n;
    r.w = q.w * n;
    
    return r;
  }
}