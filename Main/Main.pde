  
PGraphics pg;
int frame;

IRenderer renderer;
PImage image;

void setup() 
{
  size(640, 360);
  
  image = loadImage("drj.jpg");
  pg = createGraphics(640, 360);
  
  //renderer = new TestClippingRenderer();
  renderer = new TestRenderer(image);
}

void draw() 
{
  Render();
}

void Render()
{
    pg.beginDraw();
    pg.background(0);
    pg.stroke(255);
    pg.noFill();
    renderer.Render(pg);
    pg.endDraw();
    image(pg, 0, 0); 
    
    textAlign(RIGHT);
    textSize(10);
    fill(255, 255, 255);
    text("("+mouseX+", "+ mouseY + ")", width - 10, height-22);
    text(frame++ + " frame " + (int)frameRate +" fps", width - 10, height-10);
}

void keyPressed()
{
  //Render();
}