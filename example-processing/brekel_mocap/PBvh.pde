import java.util.List;

class PBvh
{
  BvhParser parser;  

  PBvh(String[] data) {
    parser = new BvhParser();
    parser.init();
    parser.parse( data );
  }

  void update( int ms ) {
    parser.moveMsTo( ms );//30-sec loop 
    parser.update();
  }

  //------------------------------------------------
  void draw() {
    // Previous method of drawing, provided by Rhizomatiks/Perfume
    
    fill(color(255));
    for ( BvhBone b : parser.getBones()) {
      pushMatrix();
      translate(b.absPos.x, b.absPos.y, b.absPos.z);
      ellipse(0, 0, 2, 2);
      popMatrix();
      if (!b.hasChildren()) {
        pushMatrix();
        translate( b.absEndPos.x, b.absEndPos.y, b.absEndPos.z);
        ellipse(0, 0, 10, 10);
        popMatrix();
      }
    }
  }

  //------------------------------------------------
  // Alternate method of drawing, added by Golan
  void drawBones() {
    noFill(); 
    stroke(255); 
    strokeWeight(1.0); 

    List<BvhBone> theBvhBones = parser.getBones();
    int nBones = theBvhBones.size();       // How many bones are there?
    for (int i=0; i<nBones; i++) {         // Loop over all the bones
      BvhBone aBone = theBvhBones.get(i);  // Get the i'th bone

      PVector boneCoord0 = aBone.absPos;   // Get its start point
      float x0 = boneCoord0.x;             // Get the (x,y,z) values 
      float y0 = boneCoord0.y;             // of its start point
      float z0 = boneCoord0.z;

      if (aBone.hasChildren()) {           

        // If this bone has children, 
        // draw a line from this bone to each of its children
        List<BvhBone> childBvhBones = aBone.getChildren(); 
        int nChildren = childBvhBones.size();
        for (int j=0; j<nChildren; j++) {
          BvhBone aChildBone = childBvhBones.get(j); 
          PVector boneCoord1 = aChildBone.absPos;

          float x1 = boneCoord1.x;
          float y1 = boneCoord1.y;
          float z1 = boneCoord1.z;

          stroke(255);
          line(x0, y0, z0, x1, y1, z1);

          if (bDrawMeat) {
            float dx = x1 - x0; 
            float dy = y1 - y0; 
            float dz = z1 - z0; 
            float dh = dist(x0, y0, z0, x1, y1, z1); // r
            float cx = (x0+x1)/2.0; 
            float cy = (y0+y1)/2.0; 
            float cz = (z0+z1)/2.0; 
            float theta = atan2(dx, dz); 
            float phi = acos(dy/dh); 

            if (true) {//aBone.getName().equals("LeftUpLeg")) {
              PVector boneOrientation = new PVector(dx, dy, dz); 

              stroke(255);
              fill(222, 111, 55); 

              // draw a sphere at the start joint of each bone. 
              float boneR = 12; 
              pushMatrix(); 
              translate(x0, y0, z0); 
              sphereDetail(6, 6);
              sphere(boneR); 
              popMatrix();

              // http://mathworld.wolfram.com/SphericalCoordinates.html
              // Draw a cylinder oriented along the leg. Whew!
              pushMatrix(); 
              translate (cx, cy, cz);
              rotateY(theta);
              rotateX(HALF_PI + phi); 
              // box (dh/3, dh/3, dh); //Or a box, if you want

              beginShape(QUAD_STRIP); 
              int cylinderResolution = 12; 
              for (int c=0; c<=cylinderResolution; c++) {
                float ang = map(c, 0, cylinderResolution, 0, TWO_PI); 
                float ex = boneR * cos(ang); 
                float ey = boneR * sin(ang);
                float ez0 = 0- dh/2;
                float ez1 =    dh/2;
                vertex(ex, ey, ez0); 
                vertex(ex, ey, ez1);
              }
              endShape();
              popMatrix();
            }
          }
        }
      } else {
        // Otherwise, if this bone has no children (it's a terminus)
        // then draw it differently. 

        PVector boneCoord1 = aBone.absEndPos;  // Get its start point
        float x1 = boneCoord1.x;
        float y1 = boneCoord1.y;
        float z1 = boneCoord1.z;

        line(x0, y0, z0, x1, y1, z1);

        String boneName = aBone.getName(); 
        if (boneName.equals("Head")) { 
          pushMatrix();
          translate( x1, y1, z1);
          noFill();
          ellipse(0, 0, 30, 30);
          popMatrix();
        }
      }
    }
  }
}
