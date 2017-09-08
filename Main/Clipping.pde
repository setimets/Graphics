static class Clipping
{
  // TODO : https://en.wikipedia.org/wiki/Weiler%E2%80%93Atherton_clipping_algorithm
  // https://en.wikipedia.org/wiki/Sutherland%E2%80%93Hodgman_algorithm
  //http://www.lighthouse3d.com/tutorials/glsl-tutorial/rasterization-and-interpolation/
  // Sutherland-Hodgman.
  static Vertex[] SutherlandHodgman(float x, float y, float w, float h, Vertex[] vertices)
  {
    ArrayList<Vertex> r = new ArrayList<Vertex>();
    
    r.addAll(Arrays.asList(vertices));
    
    Vector3f[] p = new Vector3f[5];
    
    p[0] = new Vector3f(x, y);
    p[1] = new Vector3f(x, y + h);
    p[2] = new Vector3f(x + w, y + h);
    p[3] = new Vector3f(x + w, y);
    p[4] = new Vector3f(x, y);
    
    // +---x 
    // |      From x-axis to y-axis is clock wise. So these cross-product direction is like a screw pike direction.
    // y
    for(int i=1;i<p.length;++i)
    {
      Vector3f edge = Vector3f.Sub(p[i], p[i-1]);
      edge.Normalize();
      Vector3f right = Vector3f.Cross(edge, Vector3f.Backward);
      
      ArrayList<Vertex> in = new ArrayList<Vertex>(r);
      r.clear();
      
      Vertex s = in.get(in.size()-1);
      for(int j=0;j<in.size();++j)
      {
        Vertex e = in.get(j);
        
        Vector3f vs = Vector3f.Sub(p[i-1], s);
        Vector3f ve = Vector3f.Sub(p[i-1], e);
        
        float dsy = Vector3f.Dot(vs, right);
        float dey = Vector3f.Dot(ve, right);
        
        Boolean insideS = dsy > 0;
        Boolean insideE = dey > 0;
        
        if(insideE)
        {
          if(!insideS)
          {
            Vector2f v = Line2D.Intersection(s, e, p[i-1], p[i], false);
            float t = Vector2f.Distance(s, v) / Vector2f.Distance(s, e);
            Vertex n = new Vertex(v.x, v.y, 0, Vector2f.Lerp(s.uv, e.uv, t), Color.Lerp(s.c, e.c, t));
            r.add(n);
          }
          r.add(e);
        }
        else if(insideS) 
        {
          Vector2f v = Line2D.Intersection(s, e, p[i-1], p[i], false);
          float t = Vector2f.Distance(s, v) / Vector2f.Distance(s, e);
          Vertex n = new Vertex(v.x, v.y, 0, Vector2f.Lerp(s.uv, e.uv, t), Color.Lerp(s.c, e.c, t));
          r.add(n);
        }
        s = e;
      }
    }
    
    Vertex[] ret = new Vertex[r.size()];
    r.toArray(ret);
    return ret;
  }
  
}