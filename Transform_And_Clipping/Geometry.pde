
static class Line
{
  PVector s, e;
  
  Line(PVector p0, PVector p1)
  {
    s = p0;
    e = p1;
  }
  
  PVector Intersection(Line l)
  {
    return Intersection(s, e, l.s, l.e);
  }
  
  static PVector Intersection(PVector p1, PVector p2, PVector p3, PVector p4)
  {
    PVector r = new PVector();
    
    if((p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x) == 0)
    {
      r.x = Float.NaN;
      r.y = Float.NaN;
      return r;
    }
    
    float den = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y);
    float ua = ((p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x)) / den;
    float ub = ((p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x)) / den;
    
    if(!((ua > 0 && ua < 1) && (ub > 0 && ub < 1)))
    {
      r.x = Float.NaN;
      r.y = Float.NaN;
      return r;
    }
    //float t = (p4.x - p3.x) * (p1.y - p3.x) 
    
    // I don't know that how to prove line intersection by matrix determinant.
    r.x = ((p1.x * p2.y - p1.y * p2.x) * (p3.x - p4.x) - (p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x)) 
          / ((p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x));
    
    r.y = ((p1.x * p2.y - p1.y * p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x * p4.y - p3.y * p4.x)) 
          / ((p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x));
          
    return r;
  }
}