// Renders a BVH file with Processing v3.2.1
// Note: mouseX controls the camera.

PBvh myBrekelBvh;

//------------------------------------------------
void setup() {
  size( 1280, 720, P3D );
  
  // Load a BVH file recorded with a Kinect v2, made in Brekel Pro Body v2.
  myBrekelBvh = new PBvh( loadStrings( "Brekel_03_11_2016_15_47_42_body1.bvh" ) );
}

//------------------------------------------------
void draw() {
  background(0, 0, 0);

  setMyCamera();        // Position the camera. See code below.
  drawMyGround();       // Draw the ground. See code below.
  updateAndDrawBody();  // Update and render the BVH file. See code below.
}


//------------------------------------------------
void updateAndDrawBody() {
  pushMatrix(); 
  translate(width/2, height/2, 0); // position the body in space
  scale(-1, -1, 1); // correct for the coordinate system orientation

  myBrekelBvh.update(millis()); // update the BVH playback
  
  // myBrekelBvh.draw();        // one way to draw the BVH file (see PBvh.pde)
  myBrekelBvh.drawBones();      // a different way to draw the BVH file

  popMatrix();
}


//------------------------------------------------
void setMyCamera() {

  // Adjust the position of the camera
  float eyeX = mouseX;          // x-coordinate for the eye
  float eyeY = height/2.0f - 200;   // y-coordinate for the eye
  float eyeZ = 350;             // z-coordinate for the eye
  float centerX = width/2.0f;   // x-coordinate for the center of the scene
  float centerY = height/2.0f;  // y-coordinate for the center of the scene
  float centerZ = -400;         // z-coordinate for the center of the scene
  float upX = 0;                // usually 0.0, 1.0, or -1.0
  float upY = 1;                // usually 0.0, 1.0, or -1.0
  float upZ = 0;                // usually 0.0, 1.0, or -1.0

  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
}

//------------------------------------------------
void drawMyGround() {
  // Draw a grid in the center of the ground 
  pushMatrix(); 
  translate(width/2, height/2, 0); // position the body in space
  scale(-1, -1, 1);

  stroke(100);
  strokeWeight(1); 
  
  float gridSize = 400; 
  int nGridDivisions = 10; 
  
  for (int col=0; col<=nGridDivisions; col++) {
    float x = map(col, 0, nGridDivisions, -gridSize, gridSize);
    line (x, 0, -gridSize, x, 0, gridSize);
  }
  for (int row=0; row<=nGridDivisions; row++) {
    float z = map(row, 0, nGridDivisions, -gridSize, gridSize); 
    line (-gridSize, 0, z, gridSize, 0, z);
  }

  popMatrix();
}