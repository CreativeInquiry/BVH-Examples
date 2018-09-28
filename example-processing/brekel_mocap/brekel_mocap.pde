// Renders a BVH file with Processing v3.4
// Note: mouseX controls the camera.
// Based off of com.rhizomatiks.bvh
// Golan Levin, September 2018

PBvh myBrekelBvh;
boolean bDrawMeat = true; 
boolean bDrawLineConnectingHands = false; 
boolean bDrawCircleAtOrigin = false; 
boolean bDrawLineToBoneInScreenspace = false; 
float boneScreenX; 
float boneScreenY; 

//------------------------------------------------
void setup() {
  size( 1280, 720, P3D );

  // Load a BVH file recorded with a Kinect v2, made in Brekel Pro Body v2.
  myBrekelBvh = new PBvh( loadStrings("Brekel_03_11_2016_15_47_42_body1.bvh" ) );
}

//------------------------------------------------
void draw() {
  lights() ;
  background(0, 0, 0);

  pushMatrix(); 
  setMyCamera();        // Position the camera. See code below.
  drawMyGround();       // Draw the ground. See code below.
  updateAndDrawBody();  // Update and render the BVH file. See code below.
  popMatrix(); 

  drawHelpInfo();
  drawLineToHead();
}

void keyPressed() {
  switch (key) {
  case 'M': 
  case 'm': 
    bDrawMeat = !bDrawMeat; 
    break;
  case 'L':
  case 'l': 
    bDrawLineConnectingHands = !bDrawLineConnectingHands;
    break;
  case 'O': 
  case 'o': 
    bDrawCircleAtOrigin = !bDrawCircleAtOrigin; 
    break;
  case 'H': 
  case 'h':
    bDrawLineToBoneInScreenspace = !bDrawLineToBoneInScreenspace; 
    break;
  }
}


//------------------------------------------------
void updateAndDrawBody() {

  pushMatrix(); 
  translate(width/2, height/2, 0); // position the body in space
  scale(-1, -1, 1); // correct for the coordinate system orientation

  myBrekelBvh.update(millis()); // update the BVH playback

  myBrekelBvh.draw();        // one way to draw the BVH file (see PBvh.pde)
  if (bDrawMeat) {
    myBrekelBvh.drawBones(); // a different way to draw the BVH file
  }

  if (bDrawLineConnectingHands) {
    drawLineConnectingHands();
  }

  if (bDrawCircleAtOrigin) {
    drawCircleAtOrigin();
  }

  if (bDrawLineToBoneInScreenspace) {
    myBrekelBvh.calculateScreenspaceLocationOfBone("Head");
  }

  popMatrix();
}

//------------------------------------------------
void drawHelpInfo() {
  fill(255); 
  float ty = 20; 
  float dy = 15; 
  text("BVH Loader for Processing 3.4", 20, ty+=dy);
  text("Displays files recorded with Kinect v2 + Brekel Pro Body 2", 20, ty+=dy);

  text("", 20, ty+=dy);
  text("Press 'M' to toggle meat", 20, ty+=dy);
  text("Press 'L' to draw line connecting hands", 20, ty+=dy);
  text("Press 'O' to draw circle at Origin", 20, ty+=dy);
  text("Press 'H' to draw line from mouse to Head", 20, ty+=dy);
}


//------------------------------------------------
void drawLineToHead() {
  if (bDrawLineToBoneInScreenspace) {
    stroke(0, 255, 255); 
    strokeWeight(3); 
    line (mouseX, mouseY, boneScreenX, boneScreenY);
  }
}


//------------------------------------------------
void drawCircleAtOrigin() {
  fill(255); 
  stroke(255, 0, 0); 
  strokeWeight(4); 
  ellipse(0, 0, 20, 20);
}


//------------------------------------------------
void drawLineConnectingHands() {
  // This example code shows how to reach into the skeleton 
  // in order to get specific joint locations (in 3D)

  int L_HAND_BONE_INDEX = 12;
  BvhBone leftHandBone = myBrekelBvh.parser.getBones().get(L_HAND_BONE_INDEX); 
  PVector leftHandPos = leftHandBone.absPos;

  int R_HAND_BONE_INDEX = 31;
  BvhBone rightHandBone = myBrekelBvh.parser.getBones().get(R_HAND_BONE_INDEX); 
  PVector rightHandPos = rightHandBone.absPos;

  stroke(255, 0, 0); 
  strokeWeight(4); 
  line(
    leftHandPos.x, leftHandPos.y, leftHandPos.z, 
    rightHandPos.x, rightHandPos.y, rightHandPos.z
    );
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
