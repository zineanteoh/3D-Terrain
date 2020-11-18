/*
Effect of Water: 
  offChg = 0.05; 
  flyingSpeed = 0.01
Effect of Flying over Ground: 
  offChg = 0.2;
  flyingSpeed = 0.1;
*/

// modifiable variables
float offChg = 0.2;
float flyingSpeed = 0.1;

// optimal settings
float[][] terrain;
int w, h;
int cols, rows;
int scale = 20;

// variables for rotating using arrow keys
float rotation_x, rotation_z;
boolean rotating_L = false, rotating_R = false;
boolean rotating_U = false, rotating_D = false;
float LR_angle = 0.02, UD_angle = 0.02;

// variables for (the effect of) flying 
boolean flying = true;
float flyChg; // using perlin's noise: decrementing yoff by flyChg every loop 

void setup() {
  size(600, 600, P3D);
  w = width * 4;
  h = height * 4;
  cols = w/scale;
  rows = h/scale;
  terrain = new float[cols][rows];
  
  // config 
  flyChg = 0;
  rotation_x = 1;
  rotation_z = 0;
}

void keyPressed() {
  if (key == ' ') {
    flying = !flying;
  } else if (keyCode == LEFT) {
    rotating_L = true;
  } else if (keyCode == RIGHT) {
    rotating_R = true;
  } else if (keyCode == UP) {
    rotating_U = true;
  } else if (keyCode == DOWN) {
    rotating_D = true;
  }
}

void keyReleased() {
  if (keyCode == LEFT) {
    rotating_L = false;
  } else if (keyCode == RIGHT) {
    rotating_R = false;
  } else if (keyCode == UP) {
    rotating_U = false;
  } else if (keyCode == DOWN) {
    rotating_D = false;
  }
}

void draw() {
  if (flying) {
    // decrement to 'fly forward', increment to 'fly backward'
    flyChg -= flyingSpeed;
  }
  float yoff = flyChg;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -100, 100);
      //terrain[x][y] = map(noise(x, y), 0, 1, -50, 50);
      xoff += offChg;
    }
    yoff += offChg;
  }

  background(0);
  noFill();
  //fill(210, 105, 30, 50);
  stroke(255);

  translate(width/2, height/2+100);
  updateRotation();
  rotateX(rotation_x);
  rotateZ(rotation_z);
  translate(-w/2, -h/2);

  for (int y = 0; y < rows - 1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
      //rect(x*scale, y*scale, scale, scale);
    }
    endShape();
  }
}

void updateRotation() {
  if (rotating_L) {
    rotation_z += LR_angle;
  } 
  if (rotating_R) {
    rotation_z -= LR_angle;
  }
  if (rotating_U) {
    rotation_x += UD_angle;
  }
  if (rotating_D) {
    rotation_x -= UD_angle;
  }
}
