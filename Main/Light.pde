static class Light 
{
   float intensity = 1f;
   Color c = Color.White;
   Vector3f position;
   
   public float Reflect(Vector3f pos, Vector3f normal)
   {
     return 1f;
   }
}

static class PointLight extends Light
{
  private float _distance;
  
  public PointLight(float distance)
  {
    _distance = distance;
  }
  
  public float Reflect(Vector3f pos, Vector3f normal)
  {
    Vector3f vec = Vector3f.Sub(position, pos);
    float r = Vector3f.Dot(vec, normal);
    float dx = 1 - (vec.Magnitude() / _distance);
    dx = constrain(dx, 0, 1);
    return dx * intensity * r;
  }
}

static class DirectionalLight extends Light 
{
  private Vector3f _direction;
  
  public DirectionalLight(Vector3f direction)
  {
    _direction = Vector3f.Scale(direction, -1);
  }
  
  public float Reflect(Vector3f pos, Vector3f normal)
  {
    float r = Vector3f.Dot(_direction, normal) * intensity;
    return r;
  }
}