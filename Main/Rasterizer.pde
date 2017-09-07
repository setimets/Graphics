import java.util.Arrays;

static class Color
{
  float r;
  float g;
  float b;
  float a;
  
  public static final Color Red = new Color(1, 0, 0);
  
  public static final Color Blue = new Color(0, 1, 0);
  
  public static final Color Green = new Color(0, 0, 1);
  
  public Color() { }
  
  public Color(float r, float g, float b)
  {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = 1;
  }
  
  public Color(float r, float g, float b, float a)
  {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }
  
  public int ToInt()
  {
    int aa = ((int)(a*255)) << 24;
    int rr = ((int)(r*255)) << 16;
    int gg = ((int)(g*255)) << 8;
    int bb = ((int)(b*255));
    
    return aa + rr + gg + bb;
  }
  
  static Color Multify(Color c, float v)
  {
    Color r = new Color(c.r * v, c.g * v, c.b * v, c.a * v);
    return r;
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

static class Vertex extends Vector3f
{
  Vector3f normal;
  Vector2f texCoord;
  Color c;
  
  Vertex(){ }
  
  Vertex(Vector3f v)
  {
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;  
  }
  
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
        float Y = min.y + i;
        Vector2f s0 = new Vector2f(floor(min.x), Y);
        Vector2f s1 = new Vector2f(ceil(max.x), Y);
        
        Vector2f p = Line2D.Intersection(s0, s1, e.p0, e.p1);
        
        if(!(Float.isNaN(p.x) || Float.isNaN(p.y)))
        {
          float t = Vector2f.Distance(e.p0, p) / Vector2f.Distance(e.p1, e.p0);
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
      float slope = round(dy / dx);
      
      r = new Pixel(sx + signX * round(dx * t), sy + signY * slope * round(dx * t), Color.Lerp(p0.c, p1.c, t));
      
      //println("dx > dy");
    }
    else 
    {
      float slope = round(dx / dy);
      
      r = new Pixel(sx + signX * slope * round(dy * t), sy + signY * round(dy * t), Color.Lerp(p0.c, p1.c, t));
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
  static ArrayList<Pixel> TriangleFan(Vertex[] vertices)
  {
    ArrayList<Pixel> r = new ArrayList<Pixel>();
    
    for(int i=2;i<vertices.length;i++)
    {
      r.addAll(Triangle(vertices[0], vertices[i-1], vertices[i]));
    }
    return r;
  }
  
  static ArrayList<Pixel> Triangle(Vertex v0, Vertex v1, Vertex v2)
  {
    ArrayList<Pixel> r = new ArrayList<Pixel>();
    
    Triangle triangle = new Triangle(v0, v1, v2);
    
    PVector min = triangle.bounds.Min();
    PVector max = triangle.bounds.Max();
    
    for(int i=(int)min.y;i<max.y;++i)
    {
      for(int j=(int)min.x;j<max.x;++j)
      {
        PVector p = triangle.BarycentricCoords(new Vector2f(j, i));
        
        if(p.x >= 0 && p.y >= 0 && p.z >= 0)
        {
          Color a = Color.Multify(v0.c, p.x);
          Color b = Color.Multify(v1.c, p.y);
          Color c = Color.Multify(v2.c, p.z);
          
          r.add(new Pixel(j, i, new Color(a.r + b.r + c.r, a.g + b.g + c.g, a.b + b.b + c.b, a.a + b.a + c.a)));
        }
      }
    }
    return r;
  }
  
  // It has some problem.
  static ArrayList<Pixel> ScanLine(Vertex v0, Vertex v1, Vertex v2)
  {
    ArrayList<Pixel> ret = new ArrayList<Pixel>();
    AET aet = new AET(new Edge[] { new Edge(v0, v1), new Edge(v1, v2), new Edge(v2, v0) });
    
    aet.Create();
    
    for(ScanLine line : aet.lines)
    {
      int size = line.intersectX.size();
      for(int i=0; i < size && size % 2 == 0; i+=2)
      {
        Edge e = new Edge(line.intersectX.get(i), line.intersectX.get(i+1));
        int len = e.Length();
        
        for(int j=0;j<len;++j)
        {
          float t = j/(float)len;
          Pixel p = e.Interpolate(t);
          ret.add(p);
        }
      }
    }
    
    return ret;
  }
  
  // https://www.slideshare.net/AnkitGarg22/polygon-filling-75128608
  // https://hackernoon.com/computer-graphics-scan-line-polygon-fill-algorithm-3cb47283df6
  // http://www.it.uu.se/edu/course/homepage/grafik1/ht05/Lectures/L02/LinePolygon/x_polyd.htm
  static ArrayList<Pixel> ScanLine(Polygon2D polygon)
  {
    ArrayList<Pixel> r = new ArrayList<Pixel>();
    
    return r;
  }
  
  static ArrayList<Pixel> ScanLine(Vertex[] polygon)
  {
    ArrayList<Pixel> ret = new ArrayList<Pixel>();
    
    Edge[] edges = new Edge[polygon.length];
    for(int i=1;i< polygon.length;i++)
    {
      edges[i-1] = new Edge(polygon[i-1], polygon[i]);
    }
    edges[edges.length-1] = new Edge(polygon[polygon.length-1], polygon[0]);
    
    AET aet = new AET(edges);
    
    aet.Create();
    
    for(ScanLine line : aet.lines)
    {
      int size = line.intersectX.size();
      for(int i=0; i < size && size % 2 == 0; i+=2)
      {
        Edge e = new Edge(line.intersectX.get(i), line.intersectX.get(i+1));
        int len = e.Length();
        
        for(int j=0;j<len;++j)
        {
          float t = j/(float)len;
          Pixel p = e.Interpolate(t);
          ret.add(p);
        }
      }
    }
    
    return ret;
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
  
  // TODO : https://en.wikipedia.org/wiki/Weiler%E2%80%93Atherton_clipping_algorithm
  // https://en.wikipedia.org/wiki/Sutherland%E2%80%93Hodgman_algorithm
  // Sutherland-Hodgman.
  // It has some problem.
  static Vertex[] SHClipping(float x, float y, float w, float h, Vertex[] vertices)
  {
    ArrayList<Vertex> r = new ArrayList<Vertex>();
    
    r.addAll(Arrays.asList(vertices));
    
    Vector3f[] p = new Vector3f[5];
    
    p[0] = new Vector3f(x, y);
    p[1] = new Vector3f(x, y + h);
    p[2] = new Vector3f(x + w, y + h);
    p[3] = new Vector3f(x + w, y);
    p[4] = new Vector3f(x, y);
    
    
    // +---x 
    // |      From x-axis to y-axis is clock wise. So these cross-product direction is like a screw pike direction.
    // y
    for(int i=1;i<p.length;++i)
    {
      Vector3f edge = Vector3f.Sub(p[i], p[i-1]);
      edge.Normalize();
      Vector3f right = Vector3f.Cross(edge, Vector3f.Backward);
      
      ArrayList<Vertex> in = new ArrayList<Vertex>(r);
      r.clear();
      
      Vertex s = in.get(in.size()-1);
      for(int j=0;j<in.size();++j)
      {
        Vertex e = in.get(j);
        
        Vector3f vs = Vector3f.Sub(p[i-1], s);
        Vector3f ve = Vector3f.Sub(p[i-1], e);
        
        float dsy = Vector3f.Dot(vs, right);
        float dey = Vector3f.Dot(ve, right);
        
        Boolean insideS = dsy >= 0;
        Boolean insideE = dey >= 0;
        
        if(insideE)
        {
          if(!insideS)
          {
            Vector2f v = Line2D.Intersection(s, e, p[i-1], p[i], false);
            float t = Vector2f.Distance(s, v) / Vector2f.Distance(s, e);
            
            r.add(new Vertex(v.x, v.y, 0, Color.Lerp(s.c, e.c, t)));
          }
          r.add(e);
        }
        else if(insideS) 
        {
          Vector2f v = Line2D.Intersection(s, e, p[i-1], p[i], false);
          float t = Vector2f.Distance(s, v) / Vector2f.Distance(s, e);
          
          r.add(new Vertex(v.x, v.y, 0, Color.Lerp(s.c, e.c, t)));
        }
        
        s = e;
      }
    }
    
    Vertex[] ret = new Vertex[r.size()];
    r.toArray(ret);
    return ret;
  }
  
  public static void DrawRect(PGraphics g, float x, float y, float w, float h)
  {
    g.line(x, y, x+w, y);
    g.line(x+w, y, x+w, y+h);
    g.line(x+w, y+h, x, y+h);
    g.line(x, y+h, x, y);
  }
  
  public static void DrawRect(PGraphics g, PVector p0, PVector p1, PVector p2, PVector p3)
  {
    g.line(p0.x, p0.y, p1.x, p1.y);
    g.line(p1.x, p1.y, p2.x, p2.y);
    g.line(p3.x, p3.y, p2.x, p2.y);
    g.line(p3.x, p3.y, p0.x, p0.y);
  }

}