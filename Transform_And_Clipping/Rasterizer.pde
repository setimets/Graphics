static class Color
{
  float r;
  float g;
  float b;
  float a;
  
  public Color() { }
  
  public Color(float r, float g, float b, float a)
  {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }
}

static class Vertex
{
  float x, y, z;
  PVector normal;
  Vector2 texCoord;
  Color c;
  
  Vertex(){ }
  Vertex(float x, float y, float z, Color c) 
  {  
    this.x = x;
    this.y = y;
    this.z = z;
    this.c = c;
  }
}

static class Pixel
{
  float x, y;
  Color c;
  
  Pixel(float x, float y, Color c)
  {
    this.x = x;
    this.y = y;
    this.c = c;
  }
}

static class Rasterizer 
{
  
  static ArrayList<Pixel> ScanConversion(Vertex v0, Vertex v1, Vertex v2)
  {
    ArrayList<Pixel> r = new ArrayList<Pixel>();
    
    float s0 = (v1.x - v0.x) / (v1.y - v0.y);
    float s1 = (v2.x - v1.x) / (v2.y - v1.y);
    float s2 = (v0.x - v2.x) / (v0.y - v2.y);
    
    float[] slope = new float[] { s0, s1, s2 };
    Vertex[] vb = new Vertex[] { v0, v1, v2, v0 };
    
    for(int i=1;i<vb.length;++i)
    {
      int dy = (int)(vb[i].y - vb[i-1].y);
      int iy = abs(dy);
      int sign = (dy > 0)? 1 : -1;
      int y = 0;
      while(iy - abs(y) > 0)
      {
        float k = ((sign > 0)? ceil(vb[i-1].y + y) : floor(vb[i-1].y + y));;
        float rest = k - vb[i-1].y;
        float yy = vb[i-1].y + y;
        float xx = vb[i-1].x + rest * slope[i-1];
        
        float rr = vb[i-1].c.r + slope[i-1] * ((vb[i].c.r - vb[i-1].c.r)/iy);
        float gg = vb[i-1].c.g + slope[i-1] * ((vb[i].c.g - vb[i-1].c.g)/iy);
        float bb = vb[i-1].c.b + slope[i-1] * ((vb[i].c.b - vb[i-1].c.b)/iy);
        
        Color cc = new Color(rr, gg, bb, 1f);
        Pixel pp = new Pixel(xx, yy, cc);
        
        r.add(pp);
        y += sign;
      }
    }
    return r;
  }
}