static class Camera
{
  float fov;
  float aspect;
  float near;
  float far;
  
  Quaternion rotation = Quaternion.Identity;
  
  Vector3f position;
  
  Camera(int angle, int width, int height, float near, float far)
  {
    this.fov = ((angle * 0.5f * PI) / 180f);
    this.aspect = width / (float)height;
    this.near = near;
    this.far = far;
  }
  
  Camera(float fov, float aspect, float near, float far, Vector3f position)
  {
    this.fov = fov;
    this.aspect = aspect;
    this.near = near;
    this.far = far;
    this.position = position;
    // Vector3f right, Vector3f up, Vector3f forward, Vector3f position
  }
  
}