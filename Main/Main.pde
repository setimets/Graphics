  
PGraphics pg;

TestRenderer renderer;

void setup() 
{
  size(640, 360); 
  pg = createGraphics(640, 360);
  renderer = new TestRenderer();
}

void draw() 
{
  pg.beginDraw();
  pg.background(0);
  pg.stroke(255);
  pg.noFill();
  renderer.Render(pg);
  pg.endDraw();
  image(pg, 0, 0); 
}

void keyPressed()
{
  
}