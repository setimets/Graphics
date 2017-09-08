static class Camera
{
  float fov;
  float aspect;
  float near;
  float far;
  
  Vector3f position;
  
  Camera(float fov, float aspect, float near, float far, Vector3f position)
  {
    this.fov = fov;
    this.aspect = aspect;
    this.near = near;
    this.far = far;
    this.position = position;
    // Vector3f right, Vector3f up, Vector3f forward, Vector3f position
  }
  
  public static Matrix4x4 ToMatrix4x4(PVector right, PVector up, PVector forward, PVector position)
  {
    Matrix4x4 cm = new Matrix4x4(new float[]
    {
      right.x, up.x, forward.x, position.x,
      right.y, up.y, forward.y, position.y,
      right.z, up.z, forward.z, position.z,
            0,    0,         0,          1
    });
    return cm;
  }
}