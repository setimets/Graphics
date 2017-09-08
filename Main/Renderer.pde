

interface IRenderer
{
  void Render(PGraphics pg);
}


static public class TestRenderer implements IRenderer
{
  float rad;
  PImage texture;
  
  TestRenderer(PImage texture)
  {
    this.texture = texture;
  }
  
  void Render(PGraphics pg) 
  {
    float x = 50;
    float y = 50;
    float z = 50;
    
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
      new Vertex(-x, y, z, new Vector2f(0, 1f)), new Vertex(x, y, z, new Vector2f(1f, 1f)),
      new Vertex(x, -y, z, new Vector2f(1f, 0)), new Vertex(-x, -y, z, new Vector2f(0, 0)),
      
      new Vertex(x, y, -z, new Vector2f(0, 1)), new Vertex(-x, y, -z, new Vector2f(1, 1)),
      new Vertex(-x, -y, -z, new Vector2f(1, 0)), new Vertex(x, -y, -z, new Vector2f(0, 0)),
    };
    
    
    rad += 0.01f;
    
    Matrix4x4 tm = new Matrix4x4(new float[]
    {
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, -200 + -100 * sin(rad),
      0, 0, 0, 1
    });
    
    // pitch
    Matrix4x4 rm = Matrix4x4.Pitch(rad);
    
    Matrix4x4 sm = Matrix4x4.Viewport(10, 10, 320, 180);
    Matrix4x4 pm = Matrix4x4.Perspective(pg.width, pg.height, 45f, 1, 1000);
    
    Matrix4x4 mm = Matrix4x4.Multiply(tm, rm);
    Matrix4x4 wm = mm;
    
    //float[][] vm = Camera(new PVector(1, 0, 0), new PVector(0, 1, 0), new PVector(0, 0, 1), new PVector(sin(r) * 50, 0, -50));
    Matrix4x4 vm = Matrix4x4.LookAt(new PVector(sin(rad) * 50, 0, -50), new PVector(0, 0, -200 + -100 * sin(rad)), new PVector(0, 1, 0));
    Matrix4x4 wvp = Matrix4x4.Multiply(Matrix4x4.Multiply(pm, vm), wm);
    Matrix4x4 tt = Matrix4x4.Multiply(sm, wvp);
    
    Vertex[] pa = new Vertex[box.length];
    
    for(int i=0;i<box.length;++i)
    {
       Vector3f v = tt.TransformPoint(box[i]);
       pa[i] = new Vertex(v, box[i].uv, box[i].c);
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
      
      Vertex[] p = Clipping.SutherlandHodgman(10, 10, 320, 180, pt);
      
      ArrayList<Pixel> fb = new ArrayList<Pixel>();
      //ArrayList<Pixel> fb0 = Rasterizer.TriangleFan(p, texture);  
      ArrayList<Pixel> fb0 = Rasterizer.ScanLine(p, texture);
      
      fb.addAll(fb0);
      
      for(Pixel pp : fb)
      {
        pg.set((int)pp.x, (int)pp.y, pp.c.ToInt());
      }
    }
    
    Rasterizer.DrawRect(pg, 10, 10, 320, 180);
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
    
    ArrayList<Pixel> fb = Rasterizer.ScanLine(vb[0], vb[1], vb[2]);
    //ArrayList<Pixel> fb = Rasterizer.DrawBresenHamLine(vb[0], vb[1]);
    //ArrayList<Pixel> fb = Rasterizer.DrawDDALine(vb[0], vb[1]);
    //ArrayList<Pixel> fb = Rasterizer.Triangle(vb[0], vb[1], vb[2]);
    
    for(int i=0;i<fb.size();++i)
    {
      Pixel p = fb.get(i);
      pg.set((int)p.x, (int)p.y, p.c.ToInt());
    }
  }
}

public class TestClippingRenderer implements IRenderer
{
  public void Render(PGraphics pg)
  {
    Vertex[] va = new Vertex[] 
    { 
      new Vertex(100f, 100f, 0f, Color.Red),
      //new Vertex(365, 5, 0f, Color.Green),
      new Vertex(mouseX, mouseY, 0f, Color.Green),
      new Vertex(11f, 40.3f, 0f, Color.Blue) 
    };
    Vertex[] vb = Clipping.SutherlandHodgman(10, 10, 320, 180, va);
    
    ArrayList<Pixel> fb = Rasterizer.ScanLine(vb);
    
    for(int i=0;i<fb.size();++i)
    {
      Pixel p = fb.get(i);
      pg.set((int)p.x, (int)p.y, p.c.ToInt());
    }
    
    pg.line(va[0].x, va[0].y, va[1].x, va[1].y);
    pg.line(va[1].x, va[1].y, va[2].x, va[2].y);
    pg.line(va[2].x, va[2].y, va[0].x, va[0].y);
    Rasterizer.DrawRect(pg, 10, 10, 320, 180);
  }
}