  
PGraphics pg;
int frame;

TestRenderer renderer;

void setup() 
{
  size(640, 360);
  
  pg = createGraphics(640, 360); //<>//
  renderer = new TestRenderer();
}

void draw() 
{
  Render(1);
}

void Render(int targetFrame)
{
  for(int i=0;i<targetFrame;++i)
  {
    pg.beginDraw();
    pg.background(0);
    pg.stroke(255);
    pg.noFill();
    renderer.Render(pg); //<>//
    pg.endDraw();
    image(pg, 0, 0); 
    
    textSize(32);
    fill(255, 255, 255);
    text(frame++, width - 100, height - 100);
  }
}

void keyPressed()
{
  //Render(9);
}