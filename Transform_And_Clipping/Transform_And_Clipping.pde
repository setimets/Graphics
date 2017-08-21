
void setup() 
{
  size(640, 360); 
}

float rad;

void draw() 
{
  background(0);
  stroke(255);
  noFill();
  drawStep();
  //box(200);
}

void keyPressed()
{
  
}

void drawStep()
{
  float x = 50;
  float y = 50;
  float z = 50;
  
  PVector[] box = new PVector[]
  {
    new PVector(-x, y, z), new PVector(x, y, z),
    new PVector(x, -y, z), new PVector(-x, -y, z),
    
    new PVector(x, y, -z), new PVector(-x, y, -z),
    new PVector(-x, -y, -z), new PVector(x, -y, -z),
  };
  
  rad += 0.01f;
  
  Matrix4x4 tm = new Matrix4x4(new float[]
  {
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, -200 + -100 * sin(rad),
    0, 0, 0, 1
  });
  
  /*
  // yaw
  Matrix4x4 rm = new Matrix4x4(new float[]
  {
    cos(r), -sin(r), 0, 0,
    sin(r), cos(r), 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  });
  */
  
  // pitch
  Matrix4x4 rm = new Matrix4x4(new float[]
  {
    cos(rad), 0, sin(rad), 0,
    0, 1, 0, 0,
    -sin(rad), 0, cos(rad), 0,
    0, 0, 0, 1
  });
  
  
  /*
  // roll
  Matrix4x4 rm = new Matrix4x4(new float[]
  {
    1, 0, 0, 0,
    0, cos(r), -sin(r), 0,
    0, sin(r), cos(r), 0,
    0, 0, 0, 1
  });
  */
  
  Vertex[] vb = new Vertex[] 
  { 
    //new Vertex(30f, 90f, 0f, new Color(1f, 0f, 0f, 1f)), 
    //new Vertex(60f, 60f, 0f, new Color(0f, 1f, 0f, 1f)),
    //new Vertex(90f, 90f, 0f, new Color(0f, 0f, 1f, 1f)),
    new Vertex(100f, 100f, 0f, new Color(1f, 0f, 0f, 1f)),
    //new Vertex(146, 20, 0f, new Color(0f, 1f, 0f, 1f)),
    new Vertex(mouseX, mouseY, 0f, new Color(0f, 1f, 0f, 1f)),
    new Vertex(8f, 40.3f, 0f, new Color(0f, 0f, 1f, 1f)) 
  };
  
  //println(mouseX, mouseY);
  
  ArrayList<Pixel> fb = Rasterizer.ScanLine(vb[0], vb[1], vb[2]);
  //ArrayList<Pixel> fb = Rasterizer.DrawBresenHamLine(vb[0], vb[1]);
  //ArrayList<Pixel> fb = Rasterizer.DrawDDALine(vb[0], vb[1]);
  //ArrayList<Pixel> fb = Rasterizer.Triangle(vb[0], vb[1], vb[2]);
  
  //for(Pixel p : fb)
  for(int i=0;i<fb.size();++i)
  {
    Pixel p = fb.get(i);
    int r = (int)(p.c.r * 255);
    int g = (int)(p.c.g * 255);
    int b = (int)(p.c.b * 255);
    color cc = color(r, g, b);
    
    set((int)p.x, (int)p.y, cc);
  }
  
  Matrix4x4 sm = Matrix4x4.Viewport(10, 10, 320, 180);
  Matrix4x4 pm = Matrix4x4.Perspective(width, height, 45f, 1, 1000);
  
  Matrix4x4 mm = Matrix4x4.Multiply(tm, rm);
  Matrix4x4 wm = mm;
  
  //float[][] vm = Camera(new PVector(1, 0, 0), new PVector(0, 1, 0), new PVector(0, 0, 1), new PVector(sin(r) * 50, 0, -50));
  Matrix4x4 vm = Matrix4x4.LookAt(new PVector(sin(rad) * 50, 0, -50), new PVector(0, 0, -200 + -100 * sin(rad)), new PVector(0, 1, 0));
  Matrix4x4 wvp = Matrix4x4.Multiply(Matrix4x4.Multiply(pm, vm), wm);
  Matrix4x4 tt = Matrix4x4.Multiply(sm, wvp);
  
  PVector[] pa = new PVector[box.length];
  
  for(int i=0;i<box.length;++i)
  {
    pa[i] = tt.TransformPoint(box[i]);
  }
  
  int[] pi = new int[]
  {
    0, 1, 2, 3,
    1, 4, 7, 2,
    4, 5, 6, 7,
    5, 0, 3, 6,
  };
  
  for(int i=0;i<pi.length;i+=4)
  {
    PVector[] pt = new PVector[]
    {
      pa[pi[i]], pa[pi[i+1]], pa[pi[i+2]], pa[pi[i+3]]
    };
    
    PVector[] p = Rasterizer.SHClipping(10, 10, 320, 180, pt);
    
    for(int j=1;j<p.length;++j)
    {
      line(p[j-1].x, p[j-1].y, p[j].x, p[j].y);
    }
    line(p[0].x, p[0].y, p[p.length-1].x, p[p.length-1].y);
  }
  
  DrawRect(10, 10, 320, 180);
  
}

void DrawRect(float x, float y, float w, float h)
{
  line(x, y, x+w, y);
  line(x+w, y, x+w, y+h);
  line(x+w, y+h, x, y+h);
  line(x, y+h, x, y);
}

void DrawRect(PVector p0, PVector p1, PVector p2, PVector p3)
{
  line(p0.x, p0.y, p1.x, p1.y);
  line(p1.x, p1.y, p2.x, p2.y);
  line(p3.x, p3.y, p2.x, p2.y);
  line(p3.x, p3.y, p0.x, p0.y);
}

float[][] Camera(PVector right, PVector up, PVector forward, PVector position)
{
  float[][] cm = new float[][]
  {
    {right.x, up.x, forward.x, position.x},
    {right.y, up.y, forward.y, position.y},
    {right.z, up.z, forward.z, position.z},
    {      0,    0,         0,          1}
  };
  return cm;
}