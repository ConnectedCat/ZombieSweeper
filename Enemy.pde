class Enemy {
  boolean alive, fire, spawn, walk, die;
  int PosX, PosY, movementSpeed;

  PImage[] enemy_spawn;
  PImage[] enemy_walk;
  PImage[] enemy_fire;
  PImage[] enemy_die;

  int spawn_playhead, walk_playhead, fire_playhead, die_playhead;

  int ct, st, tt;
  int fire_ct, fire_st, fire_tt;
  int attack_ct, attack_st, attack_tt;

  Enemy(int _x, int _y) {
    enemy_spawn = new PImage[6];
    enemy_walk = new PImage[5];
    enemy_fire = new PImage[12];
    enemy_die = new PImage[4];
    PosX = _x;
    PosY = _y;

    spawn = true;
    die = false;

    for (int i=0; i < 6; i++) {
      enemy_spawn[i] = loadImage("zombie_" +i + ".png");
    }

    for (int i=0; i < 5; i++) {
      int tag = i+5;
      enemy_walk[i] = loadImage("zombie_" + tag + ".png");
    }

    for (int i=0; i < 12; i++) {
      int tag = i+14;
      enemy_fire[i] = loadImage("zombie_" + tag + ".png");
    }

    for (int i=0; i < 4; i++) {
      int tag = i+10;
      enemy_die[i] = loadImage("zombie_" + tag + ".png");
    }

    spawn_playhead = walk_playhead = fire_playhead = die_playhead = 0;

    movementSpeed = 1;
    alive = true;

    ct = 0;
    st = 0;
    tt = 150;
    
    attack_ct = 0;
    attack_st = 0;
    attack_tt = 150;
    
    fire_ct = 0;
    fire_st = 0;
    fire_tt = 2500;
  }//end constructor

  void update() {
    if(!die){
    fire_ct=millis();            //update timer
    if (fire_ct-fire_st > fire_tt) {
      fire = true;
      walk = false;
      fire_st = fire_ct;
    }
    }
    if (spawn) {
      spawn();
    }
    else if (fire) {
      fire();
    }
    else if(walk){
      walk();
    }
    else{
      die();
    }
    
    if (bullets.size()>0) {
      for (int i=0; i<bullets.size();i++) {  
        PVector bullet=(PVector)(bullets.get(i));
        if (bullet.x+40 < PosX) {
          if(bullet.y < PosY+80 && bullet.y > PosY){
          println("Hit!");
          fire = false;
          walk = false;
          die = true;
          bullets.remove(i);
          }
        }
      }
    }
    if(PosX > width){
      alive = false;
    }
  }//end update()

  void spawn() {
    ct=millis();            //update timer
    if (ct-st>tt) {         //if timer is up, advance playhead to the next image
      spawn_playhead+=1;
      st=millis();
    }
    if (spawn_playhead < 6) {
      image(enemy_spawn[spawn_playhead], PosX, PosY);
    }
    else {
      walk = true;
      spawn = false;
    }
  }//end spawn

  void walk() {
    PosX += movementSpeed;

    ct=millis();            //update timer
    if (ct-st>tt) {         //if timer is up, advance playhead to the next image
      walk_playhead+=1;
      if (walk_playhead > 4) { //if it exceeds the last image, set playhead back
        walk_playhead = 0;   //to the first image of this pose.
      }
      st=millis();
    }
    image(enemy_walk[walk_playhead], PosX, PosY);
  }//end walk

  void fire() {
    attack_ct=millis();            //update timer
    if (attack_ct - attack_st > attack_tt) {         //if timer is up, advance playhead to the next image
      fire_playhead+=1;
      if (fire_playhead > 11) { //if it exceeds the last image, set playhead back
        fire_playhead = 0;   //to the first image of this pose.
        walk = true;
        fire = false;
      }
      attack_st=millis();
    }
    image(enemy_fire[fire_playhead], PosX, PosY);
  }//end fire

  void die() {
    ct=millis();            //update timer
    if (ct-st>tt) {         //if timer is up, advance playhead to the next image
      die_playhead+=1;
      st=millis();
    }
    if (die_playhead < 4) {
      image(enemy_die[die_playhead], PosX, PosY);
    }
    else {
      alive = false;
    }
  }//end die
}//end class

