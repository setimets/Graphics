
void setup() 
{
  size(640, 360); 
}

float rad;

void draw() 
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
  
  /*
  float[][] pm = new float[][]
  {
    { 1 / (aspect * t) , 0, 0, 0 },
    { 0, (1/t), 0, 0},
    { 0, 0,  -f / (f-n), -(f * n) / (f-n) },
    { 0, 0, -1, 0}
  };
  */
  
  rad += 0.01f;
  
  float[][] tm = new float[][]
  {
    {1, 0, 0, 0},
    {0, 1, 0, 0},
    {0, 0, 1, -200 + -100 * sin(rad)},
    {0, 0, 0, 1}
  };
  
  /*
  // yaw
  float[][] rm = new float[][]
  {
    {cos(r), -sin(r), 0, 0},
    {sin(r), cos(r), 0, 0},
    {0, 0, 1, 0},
    {0, 0, 0, 1}
  };
  */
  
  
  // pitch
  float[][] rm = new float[][]
  {
    {cos(rad), 0, sin(rad), 0},
    {0, 1, 0, 0},
    {-sin(rad), 0, cos(rad), 0},
    {0, 0, 0, 1}
  };
  
  
  /*
  // roll
  float[][] rm = new float[][]
  {
    {1, 0, 0, 0},
    {0, cos(r), -sin(r), 0},
    {0, sin(r), cos(r), 0},
    {0, 0, 0, 1}
  };
  */
  
  background(0);
  stroke(255);
  noFill();
  
  
  Vertex[] vb = new Vertex[] 
  { 
    //new Vertex(30f, 90f, 0f, new Color(1f, 0f, 0f, 1f)), 
    //new Vertex(60f, 60f, 0f, new Color(0f, 1f, 0f, 1f)),
    //new Vertex(90f, 90f, 0f, new Color(0f, 0f, 1f, 1f)),
    new Vertex(100f, 100f, 0f, new Color(1f, 0f, 0f, 1f)),
    new Vertex(mouseX, mouseY, 0f, new Color(0f, 1f, 0f, 1f)),
    new Vertex(8f, 40.3f, 0f, new Color(0f, 0f, 1f, 1f)) 
  };
  
  //ArrayList<Pixel> fb = Rasterizer.ScanLine(vb[0], vb[1], vb[2]);
  //ArrayList<Pixel> fb = Rasterizer.DrawBresenHamLine(vb[0], vb[1]);
  //ArrayList<Pixel> fb = Rasterizer.DrawDDALine(vb[0], vb[1]);
  ArrayList<Pixel> fb = Rasterizer.Triangle(vb[0], vb[1], vb[2]);
  
  Edge[] edges = new Edge[] 
  {
    new Edge(vb[0], vb[1]), new Edge(vb[1], vb[2]), new Edge(vb[2], vb[0])
  };
  
  
  /*
  Edge edge = new Edge(vb[0], vb[1]);
  
  int len = edge.Length();
  for(int i=0;i<len;++i)
  {
    Pixel p = edge.Interpolate(i/(float)len);
    int r = (int)(p.c.r * 255);
    int g = (int)(p.c.g * 255);
    int b = (int)(p.c.b * 255);
    color cc = color(r, g, b);
    
    set((int)p.x, (int)p.y, cc);
  }
  */
  
  for(Pixel p : fb)
  {
    int r = (int)(p.c.r * 255);
    int g = (int)(p.c.g * 255);
    int b = (int)(p.c.b * 255);
    color cc = color(r, g, b);
    
    set((int)p.x, (int)p.y, cc);
  }
  
  float[][] sm = Viewport(10, 10, 320, 180);
  float[][] pm = Perspective(45f, 1, 1000);
  
  float[][] mm = Multiply(tm, rm);
  float[][] wm = mm;
  
  //float[][] vm = Camera(new PVector(1, 0, 0), new PVector(0, 1, 0), new PVector(0, 0, 1), new PVector(sin(r) * 50, 0, -50));
  float[][] vm = CameraLookAt(new PVector(sin(rad) * 50, 0, -50), new PVector(0, 0, -200 + -100 * sin(rad)), new PVector(0, 1, 0));
  float[][] wvp = Multiply(Multiply(pm, vm), wm);
  float[][] tt = Multiply(sm, wvp);
  
  PVector[] pa = new PVector[box.length];
  
  for(int i=0;i<box.length;++i)
  {
    pa[i] = TransformPoint(tt, box[i]);
  }
  
  int[] pi = new int[]
  {
    0, 1, 2, 3,
    1, 4, 7, 2,
    4, 5, 6, 7,
    5, 0, 3, 6,
  };
  /*
  
  for(int i=0;i<pi.length;i+=4)
  {
    PVector[] pt = new PVector[]
    {
      pa[pi[i]], pa[pi[i+1]], pa[pi[i+2]], pa[pi[i+3]]
    };
    
    PVector[] p = SHClipping(10, 10, 320, 180, pt);
    
    for(int j=1;j<p.length;++j)
    {
      line(p[j-1].x, p[j-1].y, p[j].x, p[j].y);
    }
    line(p[0].x, p[0].y, p[p.length-1].x, p[p.length-1].y);
  }
  
  DrawRect(10, 10, 320, 180);
  */
  //box(200);
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

// https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection

ArrayList CreateList(PVector[] vertices)
{
  ArrayList r = new ArrayList();
  for(int i=0;i<vertices.length;++i)
  {
    r.add(vertices[i]);
  }
  return r;
}

ArrayList CopyList(ArrayList t)
{
  ArrayList r = new ArrayList();
  for(int i=0;i<t.size();++i)
  {
    r.add(t.get(i));
  }
  return r;
}

// TODO : https://en.wikipedia.org/wiki/Weiler%E2%80%93Atherton_clipping_algorithm
// https://en.wikipedia.org/wiki/Sutherland%E2%80%93Hodgman_algorithm
// Sutherland-Hodgman.
PVector[] SHClipping(float x, float y, float w, float h, PVector[] vertices)
{
  ArrayList r = CreateList(vertices);
  PVector[] p = new PVector[5];
  
  p[0] = new PVector(x, y);
  p[1] = new PVector(x, y + h);
  p[2] = new PVector(x + w, y + h);
  p[3] = new PVector(x + w, y);
  p[4] = new PVector(x, y);
  
  for(int i=1;i<p.length;++i)
  {
    PVector v = PVector.sub(p[i], p[i-1]);
    PVector xAxis = v.normalize();
    PVector yAxis = xAxis.cross(new PVector(0, 0, 1)).normalize();
    
    ArrayList in = CopyList(r);
    r.clear();
    
    PVector s = (PVector)in.get(in.size()-1);
    for(int j=0;j<in.size();++j)
    {
      PVector e = (PVector)in.get(j);
      
      PVector vs = PVector.sub(s, p[i-1]);
      PVector ve = PVector.sub(e, p[i-1]);
      
      float dsy = yAxis.dot(vs);
      float dey = yAxis.dot(ve);
      Boolean insideS = dsy > 0;
      Boolean insideE = dey > 0;
      
      if(insideE)
      {
        if(!insideS)
        {
          r.add(Line2D.Intersection(s, e, p[i-1], p[i]));
        }
        r.add(e);
      }
      else if(insideS) 
      {
        r.add(Line2D.Intersection(s, e, p[i-1], p[i]));
      }
      
      s = e;
    }
  }
  
  PVector[] ret = new PVector[r.size()];
  for(int k=0;k<ret.length;++k)
  {
    ret[k] = (PVector)r.get(k);
  }
  return ret;
}

float[][] Viewport(float x, float y, float w, float h)
{
  float[][] sm = new float[][]
  {
    {w, 0, 0, x + w * 0.5f},
    {0, -h, 0, y + h * 0.5f},
    {0, 0, 1, 0},
    {0, 0, 0, 1}
  };
  return sm;
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

float[][] CameraLookAt(PVector pos, PVector target, PVector up)
{
  PVector z = PVector.sub(target, pos);
  z.normalize();
  
  PVector x = up.cross(z);
  x.normalize();
  
  PVector y = z.cross(x);
  
  float[][] cm = new float[][]
  {
    {x.x, y.x, z.x, 0},
    {x.y, y.y, z.y, 0},
    {x.z, y.z, z.z, 0},
    {0,0,0,1}
  };
  
  float[][] tm = new float[][]
  {
    {1, 0, 0, -pos.x},
    {0, 1, 0, -pos.y},
    {0, 0, 1, -pos.z},
    {0, 0, 0, 1},
  };
  
  return Multiply(tm, cm);
}

float[][] Perspective(float angle, float near, float far)
{
  float fov = ((angle * 0.5f * PI) / 180f);
  float n = near;
  float f = far;
  float aspect = width/(float)height;
  float t = tan(fov);
  float h = 1 / t;
  
  float[][] pm = new float[][]
  {
    { h / aspect , 0, 0, 0 },
    { 0, h, 0, 0},
    { 0, 0,  (f+n) / (n-f), -1 },
    { 0, 0, (2*n*f) / (n-f), 0}
  };
  
  return pm;
}

float[][] Multiply(float[][] m0, float[][] m1)
{
  float[][] r = new float[m0.length][];
  
  for(int i=0;i<m0.length;++i)
  {
    r[i] = new float[m0[i].length];
    for(int j=0;j<m0[i].length;++j)
    {
      r[i][j] = (m0[i][0] * m1[0][j]) + (m0[i][1] * m1[1][j]) + (m0[i][2] * m1[2][j]) + (m0[i][3] * m1[3][j]);
    }
  }
  return r;
}

PVector TransformVector(float[][] m, PVector p)
{
  PVector r = new PVector(); 
  r.x = m[0][0] * p.x + m[0][1] * p.y + m[0][2] * p.z + m[0][3] * 1;
  r.y = m[1][0] * p.x + m[1][1] * p.y + m[1][2] * p.z + m[1][3] * 1;
  r.z = m[2][0] * p.x + m[2][1] * p.y + m[2][2] * p.z + m[2][3] * 1;
  
  return r;
}

PVector TransformPoint(float[][] m, PVector p)
{
  PVector r = new PVector(); 
  r.x = m[0][0] * p.x + m[0][1] * p.y + m[0][2] * p.z + m[0][3] * 1;
  r.y = m[1][0] * p.x + m[1][1] * p.y + m[1][2] * p.z + m[1][3] * 1;
  r.z = m[2][0] * p.x + m[2][1] * p.y + m[2][2] * p.z + m[2][3] * 1;
  float w = m[3][0] * p.x + m[3][1] * p.y + m[3][2] * p.z + m[3][3] * 1;
  
  if(w != 1) {
    r.z /= w;
    r.x /= w;
    r.y /= w;
  }
  return r;
}