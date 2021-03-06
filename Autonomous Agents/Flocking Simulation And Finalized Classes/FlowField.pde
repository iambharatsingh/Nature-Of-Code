// FLOW FIELD CLASS THAT GENERATES FLOW FIELD BASED OF BRIGHTNESS OF THE PIXELS OF AN IMAGE

class ImageFlowField extends FlowField {

  PImage image;

  ImageFlowField(int resolution, PImage image) {

    super(resolution);
    this.image = image;
    image.loadPixels();
    for(int i = 0 ; i < rows ; i++) {
      for(int j = 0 ; j < cols ; j++) {

        int x = j * resolution;
        int y = i * resolution;
        int c = image.pixels[x + y * image.width];
        float theta  = map(brightness(c), 0, 255, 0, TWO_PI);
        vectors[i][j] = PVector.fromAngle(theta);
        vectors[i][j].normalize();
      }
    }
  }

  void draw() {

    image(image,0,0);
     super.draw();
  }
}

class FlowField {

  PVector[][] vectors;
  int rows;
  int cols;
  int resolution;
  float xOff = 0;
  float yOff = 0;
  float zOff = 0;
  
  //DRAW PARAMETERS PRECALCULATED FOR BETTER PERFORMANCE

  float offset;
  float aYOffset;
  float aXOffset;

  FlowField(int resolution) {

    this.resolution = resolution;
    rows = (int)height / resolution;
    cols = (int)width / resolution;

    offset = resolution / 2;
    aYOffset = offset * 0.25;
    aXOffset = offset * 0.5;


    vectors = new PVector[rows][cols];

    for(int i = 0 ; i < rows ; i++) {
      xOff = 0;
      for(int j = 0 ; j < cols ; j++) {
        float angle = map(noise(xOff,yOff,zOff), 0, 1, 0,TWO_PI * 2);
        vectors[i][j] = PVector.fromAngle(angle);
        xOff += 0.1;
      }
      yOff += 0.1;
    }

  //  EXERCISE 6.6

  //   for(int i = 0 ; i < rows ; i++) {
  //     for(int j = 0 ; j < cols ; j++) {
  //       PVector v = new PVector(width/2 - j * resolution, height/2 - i * resolution);
  //       v.normalize();
  //       vectors[i][j] = v;
  //     }
  //   }
   
  }

  PVector lookup(PVector lookup) {

    int row = (int) constrain(lookup.y/resolution, 0, rows - 1);
    int col = (int) constrain(lookup.x/resolution, 0, cols - 1);
    return vectors[row][col].get();

  }

  // 3D Perlin Noise (Performance Overhead)
  // Updates complete field when called

  void updateFlowField() { 
    
    yOff = 0;
    for(int i = 0 ; i < rows ; i++) {
      xOff = 0;
      for(int j = 0 ; j < cols ; j++) {
        float angle = map(noise(xOff,yOff,zOff), 0, 1, 0,TWO_PI * 2);
        vectors[i][j] = PVector.fromAngle(angle);
        xOff += 0.1;
      }
      yOff += 0.1;
    } 
    zOff += 0.03;
  }

  void draw() {

    for(int i = 0 ; i < rows ; i++) {
      for(int j = 0 ; j < cols ; j++) {
        pushMatrix();
        stroke(0,75);
        translate(j * resolution + offset, i * resolution + offset);
        rotate(vectors[i][j].heading());
        line(-offset, 0, offset,0);
        line(offset,0,aXOffset, aYOffset);
        line(offset,0,aXOffset, -aYOffset);
        popMatrix();
      }
    }

  }
}
