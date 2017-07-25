static class Matrix4x4
{
  float[] m;
  
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
  
  void Set(float[] ma)
  {
    m = ma;
  }
  
  float Get(int i, int j)
  {
    return m[i*4 + j];
  }
  
  int Determinant()
  {
    return 0;
  }
  
  void Transpose()
  {
    Matrix4x4 r = Matrix4x4.Transpose(this);
    Set(r.m);
  }
  
  static Matrix4x4 Transpose(Matrix4x4 m)
  {
    Matrix4x4 r = new Matrix4x4();
    
    for(int i=0;i<4;++i)
    {
      for(int j=0;j<4;++j)
      {
        r.m[j * 4 + i] = m.m[i * 4 + j];
      }
    }
    return r;
  }
  
  PVector TransformVector(PVector p)
  {
    PVector r = new PVector(); 
    r.x = m[0] * p.x + m[1] * p.y + m[2] * p.z + m[3] * 1;
    r.y = m[4] * p.x + m[5] * p.y + m[6] * p.z + m[7] * 1;
    r.z = m[8] * p.x + m[9] * p.y + m[10] * p.z + m[12] * 1;
    
    return r;
  }
  
  PVector TransformPoint(PVector p)
  {
    PVector r = new PVector(); 
    r.x = m[0] * p.x + m[1] * p.y + m[2] * p.z + m[3] * 1;
    r.y = m[4] * p.x + m[5] * p.y + m[6] * p.z + m[7] * 1;
    r.z = m[8] * p.x + m[9] * p.y + m[10] * p.z + m[11] * 1;
    float w = m[12] * p.x + m[13] * p.y + m[14] * p.z + m[15] * 1;
    
    if(w != 1) {
      r.z /= w;
      r.x /= w;
      r.y /= w;
    }
    return r;
  }

  static Matrix4x4 Multiply(Matrix4x4 m0, Matrix4x4 m1)
  {
    return new Matrix4x4(Multiply(m0.m, m1.m)); 
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