

interface IRenderer
{
  void Render(PGraphics pg);
}


static public class TestRenderer implements IRenderer
{
  float rad;
  PImage texture;
  Rect screen = new Rect(100, 30, 350, 250);
  
  TestRenderer(PImage texture)
  {
    this.texture = texture;
  }
  
  void Render(PGraphics pg) 
  {
    float x = 10;
    float y = 10;
    float z = 10;
    
    /*
    Vertex[] box = new Vertex[]
    {
      new Vertex(-x, y, z, Color.Red), new Vertex(x, y, z, Color.Green),
      new Vertex(x, -y, z, Color.Blue), new Vertex(-x, -y, z, Color.Red),
      
      new Vertex(x, y, -z, Color.Red), new Vertex(-x, y, -z, Color.Green),
      new Vertex(-x, -y, -z, Color.Blue), new Vertex(x, -y, -z, Color.Red),
    };
    */
        
    Vertex[] box = new Vertex[]
    {
      new Vertex(-x, y, -z, new Vector3f(0, 1f)), new Vertex(x, y, -z, new Vector3f(1f, 1f)),
      new Vertex(x, -y, -z, new Vector3f(1f, 0)), new Vertex(-x, -y, -z, new Vector3f(0, 0)),
      
      new Vertex(x, y, z, new Vector3f(0, 1)), new Vertex(-x, y, z, new Vector3f(1, 1)),
      new Vertex(-x, -y, z, new Vector3f(1, 0)), new Vertex(x, -y, z, new Vector3f(0, 0)),
    };
    
    rad += 0.01f;
    
    // pitch
    Matrix4x4 T = Matrix4x4.Translate(0, 0, 20);
    Matrix4x4 R = Matrix4x4.Pitch(rad * 100);
    Matrix4x4 S = Matrix4x4.Identity;
    
    // TRS = (T * R * S)
    Matrix4x4 TRS = Matrix4x4.Multiply(T, Matrix4x4.Multiply(R, S));
    Matrix4x4 V = Matrix4x4.LookAtRH(new Vector3f(0, 20, -60), new Vector3f(0, 0, 10), Vector3f.Up);
    Matrix4x4 P = Matrix4x4.Perspective(pg.width, pg.height, 45f, 1, 1000);
    
    // MVP = (P * V * M)
    Matrix4x4 PVM = Matrix4x4.Multiply(P, Matrix4x4.Multiply(V, TRS));
    
    Matrix4x4 SS = Matrix4x4.Viewport(screen.pos.x, screen.pos.y, screen.size.x, screen.size.y);
    
    Vertex[] pa = new Vertex[box.length];
    for(int i=0;i<box.length;++i)
    {
      Vector4f v = Matrix4x4.Multiply(PVM, box[i]);
      
      if(v.w != 1)
      {
        v.x /= v.w;
        v.y /= v.w;
        v.z /= v.w;
      }
      
      pa[i] = new Vertex(v, box[i].uv, box[i].c);
      pa[i].w = v.w;
    }

    //    5-----4
    // 0--|--1  |
    // |  6--|--7
    // 3-----2
    
    int[] pi = new int[]
    {
      0,3,2,
      2,1,0,
      1,2,7,
      7,4,1,
      4,7,6,
      6,5,4,
      5,6,3,
      3,0,5,      
    };
    
    for(int i=0;i<pi.length;i+=3)
    {
      Vertex[] pt = new Vertex[]
      {
        pa[pi[i]], pa[pi[i+1]], pa[pi[i+2]]
      };
      
      // Backface culling.
      // https://en.wikipedia.org/wiki/Back-face_culling
      Matrix3x3 mat = new Matrix3x3(new float[]
      {
        pt[1].x - pt[0].x, pt[2].x - pt[0].x, pt[0].x,
        pt[1].y - pt[0].y, pt[2].y - pt[0].y, pt[0].y,
        0, 0, 1
      });
      
      if(mat.Determinant() < 0)
        continue;
      
      Vertex[] ps = new Vertex[pt.length];
      for(int k=0;k<pt.length;++k)
      {
        Vector3f v = SS.TransformPoint(pt[k]);
        ps[k] = new Vertex(v, pt[k].uv, pt[k].c);
        ps[k].w = pt[k].w;
      }
      
      Vertex[] p = Clipping.SutherlandHodgman(screen.pos.x, screen.pos.y, screen.size.x, screen.size.y, ps);
      
      if(p == null)
        continue;
      
      ArrayList<Pixel> fb = new ArrayList<Pixel>();
      
      // TODO : Affine Problem
      // http://www.cs.cornell.edu/courses/cs4620/2012fa/lectures/notes.pdf
      ArrayList<Pixel> fb0 = Rasterizer.TriangleFan(p, texture);  
      //ArrayList<Pixel> fb0 = Rasterizer.ScanLine(p, texture);
      
      fb.addAll(fb0);
      
      for(Pixel pp : fb)
      {
        pg.set((int)pp.x, (int)pp.y, pp.c.ToInt());
      }
    }
    
    Rasterizer.DrawRect(pg, screen);
  }
}

public class TestPerpectiveCorrectMappingRenderer implements IRenderer
{
  float rad;
  PImage texture;
  
  Rect screen = new Rect(100, 30, 350, 250);
  
  public TestPerpectiveCorrectMappingRenderer(PImage img)
  {
    texture = img;
  }
  
  public void Render(PGraphics pg)
  {
    float x = 10;
    float y = 10;
    float z = 0;
    
    Vertex[] box = new Vertex[]
    {
      new Vertex(-x, y, -z, new Vector3f(0, 1)), new Vertex(x, y, -z, new Vector3f(1, 1)),
      new Vertex(x, -y, -z, new Vector3f(1, 0)), new Vertex(-x, -y, -z, new Vector3f(0, 0)),
    };
    
    int[] pi = new int[]
    {
      0,3,2,
      2,1,0,
    };
    
    rad += 0.01f;
    
    Vector3f pos = new Vector3f(0, 0, 50); //10*sin(rad)+
    
    // pitch
    Matrix4x4 T = Matrix4x4.Translate(pos.x, pos.y, pos.z);
    Matrix4x4 R = Matrix4x4.Roll(45);
    //Matrix4x4 R = Matrix4x4.Identity;
    //R = Matrix4x4.Multiply(R, Matrix4x4.Pitch(45 * (PI/180)));
    Matrix4x4 S = Matrix4x4.Identity;

    Vector3f eye = new Vector3f(0, 10, -20);
    
    // TRS = (T * R * S)
    Matrix4x4 TRS = Matrix4x4.Multiply(T, Matrix4x4.Multiply(R, S));
    Matrix4x4 V = Matrix4x4.LookAtRH(eye, pos, Vector3f.Up);
    //Matrix4x4 V = Matrix4x4.LookAtRH(new Vector3f(0, 0, -50 - sin(rad) * 25), new Vector3f(0, 0, 50 + -100 * sin(rad)), new Vector3f(0, 1, 0));
    Matrix4x4 P = Matrix4x4.Perspective(pg.width, pg.height, 45f, 1, 1000);
    
    // MVP = (P * V * M)
    Matrix4x4 PVM = Matrix4x4.Multiply(P, Matrix4x4.Multiply(V, TRS)); //<>//
    
    // Screen Space = ((SRT * PV) * vector) * SS = Direct X
    // Screen Space = SS * (vector * (PV * Parent * TRS))) = Opengl
    Matrix4x4 SS = Matrix4x4.Viewport(screen.pos.x, screen.pos.y, screen.size.x, screen.size.y);
    
    Vertex[] pa = new Vertex[box.length];
    for(int i=0;i<box.length;++i)
    {
      Vector4f v = Matrix4x4.Multiply(PVM, box[i]);
      //Vector3f v = PVM.TransformPoint(box[i]);
      
      if(v.w != 1)
      {
        v.x /= v.w;
        v.y /= v.w;
        v.z /= v.w;
      }
      
      pa[i] = new Vertex(v, box[i].uv, box[i].c);
      pa[i].w = v.w;
    }
    
    for(int i=0;i<pi.length;i+=3)
    {
      Vertex[] pt = new Vertex[]
      {
        pa[pi[i]], pa[pi[i+1]], pa[pi[i+2]]
      };
      
      // Backface culling.
      // https://en.wikipedia.org/wiki/Back-face_culling
      Matrix3x3 mat = new Matrix3x3(new float[]
      {
        pt[1].x - pt[0].x, pt[2].x - pt[0].x, pt[0].x,
        pt[1].y - pt[0].y, pt[2].y - pt[0].y, pt[0].y,
        0, 0, 1
      });
      
      if(mat.Determinant() < 0)
        continue;
      
      Vertex[] ps = new Vertex[pt.length];
      for(int k=0;k<ps.length;++k)
      {
        Vector3f v = SS.TransformPoint(pt[k]);
        ps[k] = new Vertex(v, pt[k].uv, pt[k].c);
        ps[k].w = pt[k].w;
      }
    
      Vertex[] p = Clipping.SutherlandHodgman(screen.pos.x, screen.pos.y, screen.size.x, screen.size.y, ps);
      
      if(p == null)
        continue;
      
      ArrayList<Pixel> fb = new ArrayList<Pixel>();
      ArrayList<Pixel> fb0 = Rasterizer.TriangleFan(p, texture);  
      //ArrayList<Pixel> fb0 = Rasterizer.ScanLine(p, texture);
      
      fb.addAll(fb0);
      
      for(Pixel pp : fb)
      {
        pg.set((int)pp.x, (int)pp.y, pp.c.ToInt());
      }
      pg.stroke(255, 0, 0);
      float cx = (pt[0].x + pt[1].x + pt[2].x)/3;
      float cy = (pt[0].y + pt[1].y + pt[2].y)/3;
      pg.fill(255, 0, 0);
      pg.text("v", cx, cy);
      Rasterizer.DrawLines(pg, new Vertex[]{ ps[0], ps[1], ps[2], ps[0] });
    }
    
    Vector3f v0 = SS.TransformPoint(pa[0]);
    Vector3f v1 = SS.TransformPoint(pa[1]);
    Vector3f v2 = SS.TransformPoint(pa[2]);
    Vector3f v3 = SS.TransformPoint(pa[3]);
    
    pg.text("0 ", v0.x, v0.y);
    pg.text("1", v1.x, v1.y);
    pg.text("2 ", v2.x, v2.y);
    pg.text("3", v3.x, v3.y);
    
    Rasterizer.DrawRect(pg, screen);
  }
}

public class TestClippingRenderer implements IRenderer
{
  public void Render(PGraphics pg)
  {
    
    Vertex[] va = new Vertex[] 
    { 
      //new Vertex(mouseX, mouseY, 0f, Color.Green),
      new Vertex(1f, 1f, 0f, Color.Red),
      new Vertex(100f, 100f, 0f, Color.Red),
      new Vertex(372, 38, 0f, Color.Green),
      //new Vertex(11f, 40.3f, 0f, Color.Blue) 
    };
    Vertex[] vb = Clipping.SutherlandHodgman(10, 10, 320, 180, va);
    
    ArrayList<Pixel> fb = Rasterizer.ScanLine(vb);
    
    for(int i=0;i<fb.size();++i)
    {
      Pixel p = fb.get(i);
      pg.set((int)p.x, (int)p.y, p.c.ToInt());
    }
    
    pg.stroke(255, 255, 255);
    pg.line(va[0].x, va[0].y, va[1].x, va[1].y);
    pg.line(va[1].x, va[1].y, va[2].x, va[2].y);
    pg.line(va[2].x, va[2].y, va[0].x, va[0].y);
    Rasterizer.DrawRect(pg, 10, 10, 320, 180);
    
    for(int i=0;i<vb.length;++i)
    {
      Vertex v = vb[i];
      pg.text("p"+i +" "+ (int)v.x + "," + (int)v.y, v.x, v.y);
      pg.stroke(255, 0, 0);
      pg.ellipse(v.x, v.y, 2, 2);
    }
  }
}

public class TestLineRenderer implements IRenderer
{
  public void Render(PGraphics pg)
  {
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
    
    //ArrayList<Pixel> fb = Rasterizer.DrawBresenHamLine(vb[0], vb[1]);
    //ArrayList<Pixel> fb = Rasterizer.DrawDDALine(vb[0], vb[1]);
    ArrayList<Pixel> fb = Rasterizer.Triangle(vb[0], vb[1], vb[2]);
    
    for(int i=0;i<fb.size();++i)
    {
      Pixel p = fb.get(i);
      pg.set((int)p.x, (int)p.y, p.c.ToInt());
    }
  }
}