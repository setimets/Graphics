
static class Bound2D
{
  Vector2f center;
  Vector2f extend;
  
  public Bound2D() { }
  public Bound2D(Vector2f center, Vector2f extend)
  {
    this.center = center;
    this.extend = extend;
  }
  
  public void Expand(Vector2f v)
  {
    extend.x = abs(v.x - center.x);
    extend.y = abs(v.y - center.y);
  }
  
  public Vector2f Min()
  {
    return new Vector2f(center.x - extend.x, center.y - extend.y);
  }
  
  public Vector2f Max()
  {
    return new Vector2f(center.x + extend.x, center.y + extend.y);
  }
  
  public Rect ToRect()
  {
    return new Rect(center.x - extend.x, center.y - extend.y, extend.x * 2, extend.y * 2);
  }
}

static class Bound3D
{
  PVector center;
  PVector extend;
  
  public Bound3D() { }
  public Bound3D(PVector center, PVector extend)
  {
    this.center = center;
    this.extend = extend;
  }
  
  public void Expand(PVector v)
  {
    extend.x = abs(v.x - center.x);
    extend.y = abs(v.y - center.y);
    extend.z = abs(v.z - center.z);
  }
  
  
  public PVector Min()
  {
    return new PVector(center.x - extend.x, center.y - extend.y, center.z - extend.z);
  }
  
  public PVector Max()
  {
    return new PVector(center.x + extend.x, center.y + extend.y, center.z + extend.z);
  }
}
 