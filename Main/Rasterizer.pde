import java.util.Arrays;

static class Color
{
  public static final Color White = new Color(1, 1, 1);
  
  public static final Color Black = new Color(0, 0, 0);
  
  public static final Color Red = new Color(1, 0, 0);
  
  public static final Color Blue = new Color(0, 1, 0);
  
  public static final Color Green = new Color(0, 0, 1);
  
  float r;
  float g;
  float b;
  float a;
  
  public Color(int c)
  {
    this.a = ((c & 0xFF000000) >> 24) / 255f;
    this.r = ((c & 0x00FF0000) >> 16) / 255f;
    this.g = ((c & 0x0000FF00) >> 8) / 255f;
    this.b = ((c & 0x000000FF)) / 255f;
  }
  
  public Color(float r, float g, float b)
  {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = 1;
  }
  
  public Color() { }
  
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
  
  static Color Add(Color a, Color b)
  {
    return new Color(a.r + b.r, a.g + b.g , a.b + b.b, a.a + b.a);
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
  Vector2f uv = Vector3f.Zero;
  Color c = Color.Black;
  float w;
  
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
  
  Vertex(float x, float y, float z, Vector3f uvw)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    this.uv = uvw;
  }
  
  Vertex(float x, float y, float z, Vector2f uv, Color c)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    this.c = c;
    this.uv = uv;
  }
  
  Vertex(Vector3f v, Vector2f uv, Color c)
  {
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
    this.c = c;
    this.uv = uv;
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
  ArrayList<Vertex> intersectX = new ArrayList<Vertex>();
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
    
    int minY = floor(min.y);
    int len = abs(ceil(max.y) - minY);
    
    if(len == 0)
      throw new Error("Len is 0");
      
    lines = new ScanLine[len];
    
    Vector2f s0 = new Vector2f(floor(min.x), minY);
    Vector2f s1 = new Vector2f(ceil(max.x), minY);
    
    for(int i=0;i<len;++i)
    {
      ScanLine line = lines[i] = new ScanLine();
      Vector2f last = Vector2f.Zero;
      
      for(int j=0;j<edges.length;++j)
      {
        Edge e = edges[j];
        Vector2f p = Line2D.Intersection(e.p0, e.p1, s0, s1);
        s0.y = s1.y = minY + i;
        
        if(p.x == Float.POSITIVE_INFINITY || p.y == Float.POSITIVE_INFINITY)
          continue;
          
        if(!(Float.isNaN(p.x) || Float.isNaN(p.y)))
        {
          float t = Vector2f.Distance(e.p0, p) / Vector2f.Distance(e.p1, e.p0);
          Color c = Color.Lerp(e.p0.c, e.p1.c, t);
          Vector2f uv = Vector2f.Lerp(e.p0.uv, e.p1.uv, t);
          
          if(last.x == p.x && last.y == minY + i)
            continue;
          
          Vertex v = new Vertex(p.x, minY + i, 0, uv, c);
          line.intersectX.add(v);
          
          last = v;
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
  
  Edge(Vertex p0, Vertex p1)
  {
    this.p0 = new Vertex((int)p0.x, (int)p0.y, p0.z, p0.uv, p0.c);
    this.p1 = new Vertex((int)p1.x, (int)p1.y, p1.z, p1.uv, p1.c);
    
    points = new Vertex[] { this.p0, this.p1 };
  }
  
  Vector2f Interpolate(float t)
  {
    Vector2f r = null;
    float dy = abs(p1.y - p0.y);
    float dx = abs(p1.x - p0.x);
    float sx = p0.x;
    float sy = p0.y;
    float signX = (p0.x > p1.x) ? -1 : 1;
    float signY = (p0.y > p1.y) ? -1 : 1;
    
    if(dx > dy)
    {
      float slope = round(dy / dx);
      r = new Vector2f(sx + signX * round(dx * t), sy + signY * slope * round(dx * t));
      //r = new Pixel(sx + signX * round(dx * t), sy + signY * slope * round(dx * t), Color.Lerp(p0.c, p1.c, t));
    }
    else 
    {
      float slope = round(dx / dy);
      r = new Vector2f(sx + signX * slope * round(dy * t), sy + signY * round(dy * t));
      //r = new Pixel(sx + signX * slope * round(dy * t), sy + signY * round(dy * t), Color.Lerp(p0.c, p1.c, t));
    }  
    
    return r;
  }
  
  int Length()
  {
    int dy = abs(ceil(p1.y) - floor(p0.y));
    int dx = abs(ceil(p1.x) - floor(p0.x));
    if(dx > dy)
    {
      return dx;
    }
    else
    {
      return dy;
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
  
  static ArrayList<Pixel> TriangleFan(Vertex[] vertices, PImage tex)
  {
    ArrayList<Pixel> r = new ArrayList<Pixel>();
    
    for(int i=2;i<vertices.length;i++)
    {
      r.addAll(Triangle(vertices[0], vertices[i-1], vertices[i], tex));
    }
    return r;
  }
  
  static ArrayList<Pixel> Triangle(Vertex v0, Vertex v1, Vertex v2, PImage tex)
  {
    ArrayList<Pixel> r = new ArrayList<Pixel>();
    
    Triangle triangle = new Triangle(v0, v1, v2);
    
    PVector min = triangle.bounds.Min();
    PVector max = triangle.bounds.Max();
    
    for(int i=(int)min.y;i<max.y;++i)
    {
      for(int j=(int)min.x;j<max.x;++j)
      {
        Vector2f f = new Vector2f(j, i);
        PVector p = triangle.BarycentricCoords(f);
        
        if(p.x >= 0 && p.y >= 0 && p.z >= 0)
        {
          float v0w = 1f / v0.w;
          float v1w = 1f / v1.w;
          float v2w = 1f / v2.w;
          
          Vector2f uv0 = Vector2f.Scale(v0.uv, p.x);
          Vector2f uv1 = Vector2f.Scale(v1.uv, p.y);
          Vector2f uv2 = Vector2f.Scale(v2.uv, p.z);
          
          uv0 = Vector2f.Scale(uv0, v0w);
          uv1 = Vector2f.Scale(uv1, v1w);
          uv2 = Vector2f.Scale(uv2, v2w);
          
          Vector2f uv = new Vector2f(uv0.x+uv1.x+uv2.x, uv0.y+uv1.y+uv2.y);
          
          //float w = 1;
          float w = 1f / (p.x * v0w + p.y * v1w + p.z * v2w);
          
          uv.x *= w;
          uv.y *= w;
          uv.y = 1 - uv.y;
          
          uv.x *= tex.width;
          uv.y *= tex.height;
          
          Color cc = new Color(tex.get((int)uv.x , (int)uv.y));
          
          Color a = Color.Multify(v0.c, p.x);
          Color b = Color.Multify(v1.c, p.y);
          Color c = Color.Multify(v2.c, p.z);
          
          cc = Color.Add(cc, a);
          cc = Color.Add(cc, b);
          cc = Color.Add(cc, c);
          
          r.add(new Pixel(j, i, cc));
        }
      }
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
          
          Color cc = Color.Add(a, b);
          cc = Color.Add(cc, c);
          
          r.add(new Pixel(j, i, cc));
        }
      }
    }
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
    
    for(int w=0;w<aet.lines.length;w++)
    {
      ScanLine line = aet.lines[w];
      int size = line.intersectX.size();
      
      for(int i=1; i < size; i++)
      {
        Vertex v0 = line.intersectX.get(i-1);
        Vertex v1 = line.intersectX.get(i);
        
        int minX = floor(min(v0.x, v1.x));
        int maxX = ceil(max(v0.x, v1.x));
        int len = abs(maxX - minX);
        
        for(int j=0;j<=len;++j)
        {
          float t = j/(float)len;
          Pixel p = new Pixel(lerp(v0.x, v1.x, t), v0.y, Color.Lerp(v0.c, v1.c, t));
          ret.add(p);
        }
      }
    }
    
    return ret;
  }
  
  static ArrayList<Pixel> ScanLine(Vertex[] polygon, PImage tex)
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
      
      for(int i=1; i < size; i++)
      {
        Vertex v0 = line.intersectX.get(i-1);
        Vertex v1 = line.intersectX.get(i);
        
        int minX = floor(min(v0.x, v1.x));
        int maxX = ceil(max(v0.x, v1.x));
        int len = abs(maxX - minX);
        
        for(int j=0;j<=len;++j)
        {
          float t = j/(float)len;
            
          Vector2f uv = Vector2f.Lerp(v0.uv, v1.uv, t);
          
          uv.x *= tex.width;
          uv.y *= tex.height;
          
          Color cc = new Color(tex.get((int)uv.x, (int)uv.y));
          
          Pixel p = new Pixel(lerp(v0.x, v1.x, t), v0.y, Color.Add(cc, Color.Lerp(v0.c, v1.c, t)));
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
  
  public static void DrawLines(PGraphics g, Vector2f[] pa)
  {
    for(int i=1;i<pa.length;++i)
    {
      g.line(pa[i-1].x,pa[i-1].y, pa[i].x, pa[i].y);
    }
  }
  
  public static void DrawRect(PGraphics g, Rect rect)
  {
    DrawRect(g, rect.pos.x, rect.pos.y, rect.size.x, rect.size.y);
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