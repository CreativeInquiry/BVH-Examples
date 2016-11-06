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
    strokeWeight(2);

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

          line(x0, y0, z0, x1, y1, z1);
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
          ellipse(0, 0, 30, 30);
          popMatrix();
        }
      }
    }
  }
}