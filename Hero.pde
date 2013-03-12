class Hero {
  int posX, posY, velX, velY, movementSpeed, myWidth, myHeight;
  boolean movingUp, movingDown, movingRight, movingLeft;
  boolean facingUp, facingDown, facingRight, facingLeft;
  boolean alive, bury;

  PImage[] hero_down;
  PImage[] hero_side;
  PImage[] hero_up;
  PImage[] hero_die;
  float x, y, speed;
  String current_pose;
  int totalImages = 7;
  int walk_start, walk_end, playhead, die_start, die_end, dead_playhead;

  int ct, st, tt;

  void init(int _x, int _y) {
    movingUp = movingDown = movingRight = movingLeft = false;
    facingUp = false;
    facingDown = false;
    facingRight = false;
    facingLeft = true;
    posX = _x;
    posY = _y;
    myWidth = 15;
    myHeight = 15;
    velX = velY = 0;
    movementSpeed = 2;
    
    alive = true;
    bury = false;

    hero_down = new PImage[totalImages];
    hero_side = new PImage[totalImages];
    hero_up = new PImage[totalImages];
    hero_die = new PImage[16];

    for (int i=0; i < totalImages; i++) {
      hero_down[i] = loadImage("hero_down_" +i + ".png");
      hero_side[i] = loadImage("hero_left_" + i + ".png");
      hero_up[i] = loadImage("hero_up_" + i + ".png");
    }

    for (int i=0; i < 16; i++) {
      hero_die[i] = loadImage("boom_" +i + ".png");
    }

    ct = 0;
    st = 0;
    tt = 150;

    walk_start = 1;
    walk_end = 6;
    die_start = 0;
    die_end = 15;
    playhead = 0;
    dead_playhead = 0;
  }//end constructor

  void update() {
    if (alive) {
      movement();
      dead_playhead = 0;

      if (facingUp) {
        image(hero_up[0], posX, posY);
      }
      if (facingDown) {
        image(hero_down[0], posX, posY);
      }
      if (facingLeft) {
        image(hero_side[0], posX, posY);
      }
      if (facingRight) {
        pushMatrix();
        translate(posX, posY);
        scale(-1, 1);
        image(hero_side[0], -hero_side[0].width, 0);
        popMatrix();
      }
    }//end alive
    else {
      ct=millis();     //update timer
      if (ct-st>75) {         //if timer is up, advance playhead to the next image
        dead_playhead+=1;
        st=millis();
      }
      if (dead_playhead < 16) {
        image(hero_die[dead_playhead], posX, posY);
      }
      else {
        bury = true;
      }
    }//end dead
  }//end update

  void movement() {
    ct=millis();            //update timer
    if (ct-st>tt) {         //if timer is up, advance playhead to the next image
      playhead+=1;
      if (playhead>walk_end) { //if it exceeds the last image, set playhead back
        playhead=walk_start;   //to the first image of this pose.
      }
      st=millis();
    }

    if (movingUp) {
      posY -= movementSpeed;
      facingDown = facingRight = facingLeft = false;
      image(hero_up[playhead], posX, posY);
    }//end if movingUp
    if (movingDown) {
      posY += movementSpeed;
      facingUp = facingRight = facingLeft = false;
      image(hero_down[playhead], posX, posY);
    }
    if (movingLeft) {
      posX -= movementSpeed;
      facingRight = facingUp = facingDown = false;
      image(hero_side[playhead], posX, posY);
    }
    if (movingRight) {
      posX += movementSpeed;
      facingLeft = facingUp = facingDown = false;
      pushMatrix();
      translate(posX, posY);
      scale(-1, 1);
      image(hero_side[playhead], -hero_side[0].width, 0);
      popMatrix();
    }
  }//end movement
}//end class

