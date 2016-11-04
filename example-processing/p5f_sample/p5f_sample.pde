BvhParser parserA = new BvhParser();
PBvh bvh1, bvh2, bvh3;
	
	
public void setup()
{
  size( 1280, 720, P3D );
  background( 0 );
  noStroke();
  frameRate( 30 );
  
  bvh1 = new PBvh( loadStrings( "Brekel_03_11_2016_15_47_42_body1.bvh" ) );

  loop();
}

public void draw()
{
  background( 0 );
  
  //camera
  float _cos = cos(millis() / 5000.f);
  float _sin = sin(millis() / 5000.f);
  camera(width/4.f + width/4.f * _cos +200, height/2.0f-100, 550 + 150 * _sin,width/2.0f, height/2.0f, -400, 0, 1, 0);
  
  //ground 
  fill( color( 255 ));
  stroke(127);
  line(width/2.0f, height/2.0f, -30, width/2.0f, height/2.0f, 30);
  stroke(127);
  line(width/2.0f-30, height/2.0f, 0, width/2.0f + 30, height/2.0f, 0);
  stroke(255);
  
  pushMatrix();
  translate( width/2, height/2-10, 0);
  scale(-1, -1, -1);
  
  //model
  bvh1.update( millis() );
  bvh1.draw();
  popMatrix();
}