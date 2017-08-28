

static public class Renderer3D
{
  void Render(PGraphics pg)
  {
    
  }
}

static public class TestRenderer
{
  float rad;
  
  void Render(PGraphics pg)
  {
    float x = 50;
    float y = 50;
    float z = 50;
    
    Vertex[] box = new Vertex[]
    {
      new Vertex(-x, y, z, Color.Red), new Vertex(x, y, z, Color.Green),
      new Vertex(x, -y, z, Color.Blue), new Vertex(-x, -y, z, Color.Red),
      
      new Vertex(x, y, -z, Color.Red), new Vertex(-x, y, -z, Color.Green),
      new Vertex(-x, -y, -z, Color.Blue), new Vertex(x, -y, -z, Color.Red),
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
      Vertex[] pt = new Vertex[]
      {
        pa[pi[i]], pa[pi[i+1]], pa[pi[i+2]], pa[pi[i+3]]
      };
      
      Vertex[] p = Rasterizer.SHClipping(10, 10, 320, 180, pt);
      
      ArrayList<Pixel> fb = new ArrayList<Pixel>();
      if(p.length > 3)
      {
        ArrayList<Pixel> fb0 = Rasterizer.Triangle(p[1], p[0], p[3]);
        fb.addAll(fb0);
      }
      
      if(p.length > 3)
      {
        ArrayList<Pixel> fb1 = Rasterizer.Triangle(p[3], p[2], p[1]);
        fb.addAll(fb1);
      }
      
      for(Pixel pp : fb)
      {
        pg.set((int)pp.x, (int)pp.y, pp.c.ToInt());
      }
    }
    
    Rasterizer.DrawRect(pg, 10, 10, 320, 180);
  }
}

public class LineRenderer
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
      int r = (int)(p.c.r * 255);
      int g = (int)(p.c.g * 255);
      int b = (int)(p.c.b * 255);
      
      set((int)p.x, (int)p.y, p.c.ToInt());
    }
  }
}