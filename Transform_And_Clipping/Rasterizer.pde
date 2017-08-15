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
  
  static Color Lerp(Color a, Color b, float t)
  {
    Color c = new Color();
    c.r = lerp(a.r, b.r, t);
    c.g = lerp(a.g, b.g, t);
    c.b = lerp(a.b, b.b, t);
    c.a = lerp(a.a, b.a, t);
    return c;
  }
}

static class Vertex extends Vector2f
{
  float z;
  PVector normal;
  Vector2f texCoord;
  Color c;
  
  Vertex(){ }
  
  Vertex(int x, int y, int z, Color c)
  {
    this.x = (float)x;
    this.y = (float)y;
    this.z = (float)z;
    this.c = c;  
  }
  
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
  int x, y;
  Color c;
  
  Pixel(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  
  Pixel(int x, int y, Color c)
  {
    this.x = x;
    this.y = y;
    this.c = c;
  }
  
  Pixel(float x, float y)
  {
    this.x = (int)x;
    this.y = (int)y;
  }
  
  Pixel(float x, float y, Color c)
  {
    this.x = (int)x;
    this.y = (int)y;
    this.c = c;
  }
}
    
static class ScanLine
{
  ArrayList<Pixel> intersectX = new ArrayList<Pixel>();
}

static class AET
{
  Edge[] edges;
  
  Bound2D bounds;
  
  ScanLine[] lines;
  
  AET(Edge[] edges)
  {
    this.edges = edges;
    
    Vector2f min = new Vector2f(Float.MAX_VALUE, Float.MAX_VALUE);
    Vector2f max = new Vector2f(Float.MIN_VALUE, Float.MIN_VALUE);
    
    for(Edge edge : edges)
    {
      for(Vector2f p : edge.points)
      {
        min.x = min(min.x, p.x);
        min.y = min(min.y, p.y);
        
        max.x = max(max.x, p.x);
        max.y = max(max.y, p.y);
      }
    }
    
    Vector2f extend = new Vector2f((max.x - min.x) * 0.5f, (max.y - min.y) * 0.5f);
    bounds = new Bound2D(new Vector2f(min.x + extend.x, min.y + extend.y), extend);
  }
  
  void Create()
  {
    Vector2f min = bounds.Min();
    Vector2f max = bounds.Max();
    
    int len = ceil(abs(max.y - min.y));
    
    lines = new ScanLine[len];
    
    for(int i=0;i<len;++i)
    {
      ScanLine line = lines[i] = new ScanLine();
      for(Edge e : edges)
      {
        Vector2f p = Line2D.Intersection(new Vector2f(min.x, min.y + i), new Vector2f(max.x, min.y + i), e.p0, e.p1);
        
        if(!(Float.isNaN(p.x) || Float.isNaN(p.y)))
        {
          float dx = (p.x - e.p0.x) / abs(e.p1.x - e.p0.x);
          float dy = (p.y - e.p0.y) / abs(e.p1.x - e.p0.x);
          
          float t = max(dx, dy);
          
          Color c = Color.Lerp(e.p0.c, e.p1.c, t);
          
          line.intersectX.add(new Pixel(p.x, p.y, c));
        }
      }
    }
  }
}

static class Edge
{
  Vertex p0, p1;
  Vertex[] points;
  
  Edge next;
  
  Edge(Pixel p0, Pixel p1)
  {
    this(new Vertex(p0.x, p0.y, 0, p0.c), new Vertex(p1.x, p1.y, 0, p1.c));
  }
  
  Edge(Vertex p0, Vertex p1)
  {
    this.p0 = p0;
    this.p1 = p1;
    
    points = new Vertex[] { p0, p1 };
  }
  
  Pixel Interpolate(float t)
  {
    Pixel r = null;
    float dy = abs(p1.y - p0.y);
    float dx = abs(p1.x - p0.x);
    float sx = p0.x;
    float sy = p0.y;
    float signX = (p0.x > p1.x) ? -1 : 1;
    float signY = (p0.y > p1.y) ? -1 : 1;
    
    if(dx > dy)
    {
      float slope = dy / dx;
      r = new Pixel(sx + signX * round(dx * t), sy + round(signY * slope * (dx * t)), Color.Lerp(p0.c, p1.c, t));
      //println("dx > dy");
    }
    else 
    {
      float slope = dx / dy;
      r = new Pixel(sx + round(signX * slope * (dy * t)), sy + signY * round(dy * t), Color.Lerp(p0.c, p1.c, t));
      //println("dy > dx");
    }  
    
    return r;
  }
  
  int Length()
  {
    float dy = abs(p1.y - p0.y);
    float dx = abs(p1.x - p0.x);
    if(dx > dy)
    {
      return ceil(dx);
    }
    else
    {
      return ceil(dy);
    }
  }
  
  Vector2f Min()
  {
    float minX = min(p0.x, p1.x);
    float minY = min(p0.y, p1.y);
    Vector2f r = new Vector2f(minX, minY);
    return r;
  }
  
  Vector2f Max()
  {
    float maxX = max(p0.x, p1.x);
    float maxY = max(p0.y, p1.y);
    Vector2f r = new Vector2f(maxX, maxY);
    return r;
  }
}

static class Rasterizer 
{
  
  static ArrayList<Pixel> Triangle(Vertex v0, Vertex v1, Vertex v2)
  {
    ArrayList<Pixel> r = new ArrayList<Pixel>();
    
    //Triangle.BarycentricCoords(v0, v1, v2);
    
    return r;
  }
  
  
  static ArrayList<Pixel> ScanLine(Vertex v0, Vertex v1, Vertex v2)
  {
    ArrayList<Pixel> r = new ArrayList<Pixel>();
    
    float s0 = (v1.x - v0.x) / (v1.y - v0.y);
    float s1 = (v2.x - v1.x) / (v2.y - v1.y);
    float s2 = (v0.x - v2.x) / (v0.y - v2.y);
    
    float[] slope = new float[] { s0, s1, s2 };
    Vertex[] vb = new Vertex[] { v0, v1, v2, v0 };
    
    /*
    for(int i=1;i<vb.length;++i)
    {
      int dy = (int)(vb[i].y - vb[i-1].y);
      int dx = (int)(vb[i].x - vb[i-1].x);
      
      //int d = (abs(dx) > abs(dy))? dx : dy;
      int d = dy;
      
      int len = abs(d);
      int sign = (d > 0)? 1 : -1;
      int inc = 0;
      
      while(len - abs(inc) > 0)
      {
        float k = 0;
        float rest = 0;
        float xx = 0;
        float yy = 0;
        
        if(abs(dx) > abs(dy))
        {
          k = ((sign > 0)? ceil(vb[i-1].x + inc) : floor(vb[i-1].x + inc));
          rest = k - vb[i-1].x;
          
          xx = vb[i-1].x + inc;
          yy = vb[i-1].y + rest * slope[i-1];
        }
        else 
        {
          k = ((sign > 0)? ceil(vb[i-1].y + inc) : floor(vb[i-1].y + inc));
          rest = k - vb[i-1].y;
          
          xx = vb[i-1].x + rest * slope[i-1];
          yy = vb[i-1].y + inc;
        }
        
        float rr = vb[i-1].c.r + (slope[i-1] * ((vb[i].c.r - vb[i-1].c.r)/len));
        float gg = vb[i-1].c.g + (slope[i-1] * ((vb[i].c.g - vb[i-1].c.g)/len));
        float bb = vb[i-1].c.b + (slope[i-1] * ((vb[i].c.b - vb[i-1].c.b)/len));
        
        Color cc = new Color(rr, gg, bb, 1f);
        Pixel pp = new Pixel(xx, yy, cc);
        
        r.add(pp);
        inc += sign;
      }
    }
    */
    return r;
  }
  
  // https://www.slideshare.net/AnkitGarg22/polygon-filling-75128608
  // https://hackernoon.com/computer-graphics-scan-line-polygon-fill-algorithm-3cb47283df6
  // http://www.it.uu.se/edu/course/homepage/grafik1/ht05/Lectures/L02/LinePolygon/x_polyd.htm
  static ArrayList<Pixel> ScanLine(Polygon2D polygon)
  {
    ArrayList<Pixel> r = new ArrayList<Pixel>();
    
    return r;
  }
  
  static ArrayList<Pixel> DDALine(Vertex v0, Vertex v1)
  {
    ArrayList<Pixel> r = new ArrayList<Pixel>();
    
    float x0 = v0.x, x1 = v1.x, y0 = v0.y, y1 = v1.y;
    float dx = abs(x1 - x0);
    float dy = abs(y1 - y0);
    
    float steps;
    float ix, iy;
    float ax = v0.x, ay = v0.y;
    
    int xsign = (x0 <= x1)? 1 : -1;
    int ysign = (y0 <= y1)? 1 : -1;
    
    if(dx > dy)
    {
      steps = dx;
      if(x0 > x1)
      {
        ix = x1; x1 = x0; x0 = ix;
        iy = y1; y1 = y0; y0 = iy;
      }
    }
    else
    {
      steps = dy;
      if(y0 > y1)
      {
        ix = x1; x1 = x0; x0 = ix;
        iy = y1; y1 = y0; y0 = iy;
      }
    }
    
    ix = dx / steps;
    iy = dy / steps;
   
    for(int i=0;i<=steps;++i)
    {
      Pixel p = new Pixel(round(ax - 1), round(ay - 1), Color.Lerp(v0.c, v1.c, i/steps));
      
      r.add(p);
      ax += xsign * ix;
      ay += ysign * iy;
    }
    
    return r;
  }
  
  static ArrayList<Pixel> BresenHamLine(Vertex v0, Vertex v1)
  {
    ArrayList<Pixel> r = new ArrayList<Pixel>();
    
    int pitch = 0;
    
    float x0 = v0.x, x1 = v1.x, y0 = v0.y, y1 = v1.y;
    float dx = abs(x1 - x0);
    float dy = abs(y1 - y0);
    float ix = x0;
    float iy = y0;
    
    Color sc = v0.c;
    Color ec = v1.c;
    
    int sign = 1;
    
    if(dx >= dy)
    {
      if(x0 > x1)
      {
        ix = x1; x1 = x0; x0 = ix; // swap
        iy = y1; y1 = y0; y0 = iy;
        
        Color t = sc;
        sc = ec;
        ec = t;
      }
      
      sign = (y0 < y1)? 1 : -1;
      
      pitch = (int)(2*dy - dx);
      while(ix <= x1)
      {
        Pixel p = new Pixel(ix-1, iy-1, Color.Lerp(sc, ec, (ix - x0) / dx));
        r.add(p);
        if(pitch < 0) pitch += 2*dy;
        else
        {
          pitch += 2*(int)(dy - dx);
          iy += sign;
        }
        ix++;
      }
    }
    else
    {
      if(y0 > y1)
      {
        ix = x1; x1 = x0; x0 = ix;
        iy = y1; y1 = y0; y0 = iy;
        
        Color t = sc;
        sc = ec;
        ec = t;
      }
      
      sign = (x0 < x1)? 1 : -1;
      
      pitch = (int)(2*dx - dy);
      while(iy <= y1)
      {
        Pixel p = new Pixel(ix-1, iy-1, Color.Lerp(sc, ec, (iy - y0) / dy));
        r.add(p);
        if(pitch < 0) pitch += 2*dx;
        else
        {
          pitch += 2*(int)(dx - dy);
          ix += sign;
        }
        iy++;
      }
    }
    
    return r;
  }
  
}