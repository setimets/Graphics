
static class Vector2
{
  float x;
  float y;
  
  Vector2()
  {
    x = 0;
    y = 0;
  }
  
  Vector2(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  Vector2(PVector v)
  {
    this.x = v.x;
    this.y = v.y;
  }
  
  void Add(Vector2 v)
  {
    x += v.x;
    y += v.y;
  }
  
  void Sub(Vector2 v)
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
  
  static Vector2 Add(Vector2 v0, Vector2 v1)
  {
    return new Vector2(v0.x + v1.x, v0.y + v1.y);
  }
  
  static Vector2 Sub(Vector2 v0, Vector2 v1)
  {
    return new Vector2(v0.x - v1.x, v0.y - v1.y);
  }
  
  static float Dot(Vector2 v0, Vector2 v1)
  {
    return v0.x * v1.x + v0.y * v1.y;
  }
  
  static float Cross(Vector2 v0, Vector2 up)
  {
    return v0.x * up.y - up.x * v0.y;
  }
  
  static float Angle(Vector2 v0, Vector2 v1)
  {
    float sin = v0.x * v1.y - v1.x * v0.y; // cross
    float cos = v0.x * v1.x + v0.y * v1.y; // dot

    return atan2(sin, cos) * (180 / PI);
  }
  
  static Vector2 Normalize(Vector2 v)
  {
    float mag = v.Magnitude();
    return new Vector2(v.x / mag, v.y / mag);
  }
  
  static Vector2 Project(Vector2 v, Vector2 n)
  {
    Vector2 r = Normalize(n);
    r.Scale(Dot(v, r));
    return r;
  }
}