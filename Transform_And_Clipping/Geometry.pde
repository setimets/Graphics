
static class Line2D
{
  Vector2f s, e;
  
  Line2D(Vector2f p0, Vector2f p1)
  {
    s = p0;
    e = p1;
  }
  
  Vector2f Intersection(Line2D l)
  {
    return Intersection(s, e, l.s, l.e);
  }
  
  static PVector Intersection(PVector p1, PVector p2, PVector p3, PVector p4)
  {
    Vector2f r = Intersection(new Vector2f(p1.x, p1.y), new Vector2f(p2.x, p2.y), new Vector2f(p3.x, p3.y), new Vector2f(p4.x, p4.y));
    return new PVector(r.x, r.y);
  }
  
  static Vector2f Intersection(Vector2f p1, Vector2f p2, Vector2f p3, Vector2f p4)
  {
    Vector2f r = new Vector2f();
    
    if((p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x) == 0)
    {
      float x1 = min(min(p1.x, p2.x), min(p3.x, p4.x));
      float x2 = max(min(p1.x, p2.x), min(p3.x, p4.x));
      float x3 = min(max(p1.x, p2.x), max(p3.x, p4.x));
      float x4 = max(max(p1.x, p2.x), max(p3.x, p4.x));
      
      float y1 = min(min(p1.y, p2.y), min(p3.y, p4.y));
      float y2 = max(min(p1.y, p2.y), min(p3.y, p4.y));
      float y3 = min(max(p1.y, p2.y), max(p3.y, p4.y));
      float y4 = max(max(p1.y, p2.y), max(p3.y, p4.y));
      
      r.x = Float.NaN;
      r.y = Float.NaN;
      
      if(x2 < x3 || x1 > x4) return r;
      if(y2 < y3 || y1 > y4) return r;
      
      r.x = Float.POSITIVE_INFINITY;
      r.y = Float.POSITIVE_INFINITY;
      
      return r;
    }
    
    float den = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y);
    float ua = ((p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x)) / den;
    float ub = ((p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x)) / den;
    
    if(!((ua >= 0 && ua <= 1) && (ub >= 0 && ub <= 1)))
    {
      r.x = Float.NaN;
      r.y = Float.NaN;
      return r;
    }
    //float t = (p4.x - p3.x) * (p1.y - p3.x) 
    
    r.x = ((p1.x * p2.y - p1.y * p2.x) * (p3.x - p4.x) - (p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x)) 
          / ((p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x));
    
    r.y = ((p1.x * p2.y - p1.y * p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x * p4.y - p3.y * p4.x)) 
          / ((p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x));
          
    return r;
  }
}

static class Rect
{
  Vector2f position;
  Vector2f size;
  
  public Rect() { }
  
  public Rect(Vector2f pos, Vector2f size)
  {
    this.position = pos;
    this.size = size;
  }
  
  public Rect(float x, float y, float w, float h)
  {
    position = new Vector2f(x, y);
    size = new Vector2f(w, h);
  }
  
  public Rect(Rect rect)
  {
    this.position = new Vector2f(rect.position);
    this.size = new Vector2f(rect.size);
  }
  
  public Rect Expand(Vector2f v)
  {
    Rect r = new Rect(this);
    if(!Contains(v))
    {
      Vector2f min = Min();
      Vector2f max = Max();
      Vector2f s = new Vector2f(min(v.x, min.x), min(v.y, min.y));
      Vector2f e = new Vector2f(max(v.x, max.x), max(v.y, max.y));
      
      r = new Rect(s, new Vector2f(e.x - s.x, e.y - s.y));
    }
    
    return r;
  }
  
  public boolean Contains(Vector2f pos)
  {
    Vector2f min = Min();
    Vector2f max = Max();
    
    return (min.x <= pos.x && pos.x <= max.x) && (min.y <= pos.y && pos.y <= max.y); 
  }
  
  public Rect Overlaps(Rect rect)
  {
    Rect r = null;
    
    Vector2f minA = Min();
    Vector2f maxA = Max();
    
    Vector2f minB = rect.Min();
    Vector2f maxB = rect.Max();
    
    float minX = min(maxA.x, maxB.x);
    float maxX = max(minA.x, minB.x);
    
    float minY = min(maxA.y, maxB.y);
    float maxY = max(minA.y, minA.y);
    
    float ox = minX - maxX;
    float oy = minY - maxY;
    
    if(ox > 0 && oy > 0)
      r = new Rect(new Vector2f(minX, minY), new Vector2f(ox, oy));
      
    return r;
  }
  
  public Vector2f Center()
  {
    return new Vector2f(position.x + size.x * 0.5f, position.y + size.y * 0.5f);
  }
  
  public Vector2f Min()
  {
    return new Vector2f(min(position.x, position.x + size.x), min(position.y, position.y + size.y));
  }
  
  public Vector2f Max()
  {
    return new Vector2f(max(position.x, position.x + size.x), max(position.y, position.y + size.y));
  }
}

static class Triangle
{
  Vertex[] vertice;
  
  Bound3D bounds;
  
  Triangle(Vertex v0, Vertex v1, Vertex v2)
  {
    this(new Vertex[]{ v0, v1, v2 });
  }
  
  Triangle(Vertex[] vertice)
  {
    this.vertice = vertice;
    
    PVector min = new PVector(Float.MAX_VALUE, Float.MAX_VALUE, Float.MAX_VALUE);
    PVector max = new PVector(Float.MIN_VALUE, Float.MIN_VALUE, Float.MIN_VALUE);
    
    for(Vertex p : vertice)
    {
      min.x = min(min.x, p.x);
      min.y = min(min.y, p.y);
      min.z = min(min.z, p.z);
      
      max.x = max(max.x, p.x);
      max.y = max(max.y, p.y);
      max.z = max(max.y, p.z);
    }
    
    PVector extend = new PVector((max.x - min.x) * 0.5f, (max.y - min.y) * 0.5f, (max.z - min.z) * 0.5f);
    bounds = new Bound3D(new PVector(min.x + extend.x, min.y + extend.y, min.z + extend.z), extend);
  }
  
  
  PVector BarycentricCoords(Vector2f p)
  {
    return BarycentricCoords(vertice[0], vertice[1], vertice[2], p);
  }
  
  // http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.100140_0100_00_en/nic1408628343483.html
  // https://www.youtube.com/watch?v=E5papKQGrGU
  // https://en.wikipedia.org/wiki/Barycentric_coordinate_system
  static PVector BarycentricCoords(Vector2f p1, Vector2f p2, Vector2f p3, Vector2f p)
  {
    float determine = ((p2.y - p3.y) * (p1.x - p3.x) + (p3.x - p2.x) * (p1.y - p3.y));
    float l1 = ((p2.y - p3.y) * (p.x - p3.x) + (p3.x - p2.x) * (p.y - p3.y)) / determine;
    float l2 = ((p3.y - p1.y) * (p.x - p3.x) + (p1.x - p3.x) * (p.y - p3.y)) / determine;
    float l3 = 1 - l1 - l2;
    
    return new PVector(l1, l2, l3);
  }
  
}

static class Polygon2D
{
  Vector2f[] points;
  
  Bound2D bounds;
  
  Polygon2D(Vector2f[] points)
  {
    this.points = points;
    
    Vector2f min = new Vector2f(Float.MAX_VALUE, Float.MAX_VALUE);
    Vector2f max = new Vector2f(Float.MIN_VALUE, Float.MIN_VALUE);
    
    for(Vector2f p : points)
    {
      min.x = min(min.x, p.x);
      min.y = min(min.y, p.y);
      
      max.x = max(max.x, p.x);
      max.y = max(max.y, p.y);
    }
    Vector2f extend = new Vector2f((max.x - min.x) * 0.5f, (max.y - min.y) * 0.5f);
    bounds = new Bound2D(new Vector2f(min.x + extend.x, min.y + extend.y), extend);
  }
}