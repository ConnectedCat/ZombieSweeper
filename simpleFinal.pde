import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Board board;
Hero hero;
Minim minim;

AudioSnippet fire_sound;
boolean fire_played;
AudioSnippet boom_sound;
boolean boom_played;
AudioSnippet shot_sound;
boolean shot_played;
AudioPlayer music;

ArrayList enemies;
ArrayList bullets;
ArrayList ammo;
//create a simple timer
int ct, st, tt;
int bulletspeed;

int currentTileX, currentTileY;

boolean opening;
int open_ct, open_st, open_tt;

void setup() {
  size(640, 480);
  background(100);

  opening = true;
  open_ct = 0;
  open_st = 0;
  open_tt = 6000;

  minim = new Minim(this);
  music = minim.loadFile("music.mp3");
  music.loop();

  fire_sound = minim.loadSnippet("fire.mp3");
  fire_played = false;
  boom_sound = minim.loadSnippet("boom.mp3");
  boom_played = false;
  shot_sound = minim.loadSnippet("shot.mp3");
  shot_played = false;

  board = new Board(width, height);
  hero = new Hero();


  bulletspeed = -8;
  bullets = new ArrayList();

  enemies = new ArrayList();
  tt=6000;
  ct=0;
  st=millis();
}//end draw

void draw() {
  if (opening) {
    open_ct=millis();            //update timer
    if (open_ct - open_st > open_tt) {         //if timer is up, advance playhead to the next image
      board.init();
      hero.init(width-20, height/2);
      ammo = new ArrayList();
      for (int i=0; i<8; i++) {
        ammo.add(1);
      }
      opening = false;
    }
    else {
      fill(150);
      rect(0, 0, width, height);
      fill(0);
      text("Welcome to Zombie Sweeper", width/2 - 70, height/2 - 30);
      text("Control keys are ASWD, fire with space bar", width/2 - 110, height/2);
      text("Go get 'em, tiger!", width/2 - 50, height/2 + 30);
      text("And watch out for the mines!", width/2 - 70, height/2 + 60);
    }
  }
  else {
    if (!hero.bury) {
      board.update();
      //background(0, 255, 0);
      hero.update();
      currentTileX = ceil((hero.posX+8)/16);
      currentTileY = ceil((hero.posY+42)/16);
      if (boom_played) {
        boom_played = false;
        boom_sound.rewind();
      }
      if (shot_played) {
        shot_played = false;
        shot_sound.rewind();
      }

      if (board.minemap[currentTileX][currentTileY] == 9) {
        hero.alive = false;
        if (!boom_played && !boom_sound.isPlaying()) {
          boom_sound.play();
          boom_played = true;
        }
      }
      if (board.minemap[currentTileX][currentTileY] == 3) {
        ammo.add(1);
      }

      ct = millis();
      if (ct-st>tt) {
        Enemy en = new Enemy(int(random(0, hero.posX-100)), int(random(hero.posY - 100, hero.posY + 100)));
        enemies.add(en);
        st = ct;
      }

      if (enemies.size() > 0) {
        for (int i = 0; i < enemies.size(); i++) {
          Enemy e = (Enemy)(enemies.get(i));
          if (e.alive) {
            e.update();
            if (e.fire) {
              if (!fire_played && !fire_sound.isPlaying()) {
                fire_sound.play();
                fire_played = true;
              }
              if (e.PosX+110 > hero.posX) {
                if (e.PosY+80 > hero.posY+40 && e.PosY < hero.posY) {
                  hero.alive = false;
                  if (!boom_played && !boom_sound.isPlaying()) {
                    boom_sound.play();
                    boom_played = true;
                  }
                }
              }
            }
            else if (e.walk) {
              fire_played = false;
              fire_sound.rewind();
              if (e.PosX+60 > hero.posX) {
                if (e.PosY+80 > hero.posY+40 && e.PosY < hero.posY) {
                  hero.alive = false;
                  if (!boom_played && !boom_sound.isPlaying()) {
                    boom_sound.play();
                    boom_played = true;
                  }
                }
              }
            }
          }//end if alive
          else {
            enemies.remove(i);
          }
        }//end the for loop
      }//go through the enemy array

      if (bullets.size() > 0) {
        for (int i=0; i<bullets.size();i++) {  
          PVector bullet=(PVector)(bullets.get(i));
          if (bullet.x < 0) {
            bullets.remove(i);
          }
          else {
            bullet.x+=bulletspeed;
            rect(bullet.x, bullet.y, 2, 2);
          }
        }
      }

      noStroke();
      fill(255);
      rect(width - 110, 0, 110, 30);
      textSize(20);
      fill(0);
      text("Bullets: " + ammo.size(), width - 100, 20);
    }//end if hero alive
    else {
      for (int i = 0; i< enemies.size(); i++) {
        enemies.remove(i);
      }
      fill(150);
      rect(0, 0, width, height);
      fill(0);
      text("Bummer! You almost made it", width/2 - 70, height/2 - 30);
      text("Press r to restart", width/2 - 60, height/2);
    }
  }//end else not opening
}//end draw

void keyPressed() {
  if (hero.alive) {
    switch(key) {
    case 'w':
      hero.movingUp = true;
      hero.facingUp = false;
      break;
    case 's':
      hero.movingDown = true;
      hero.facingDown = false;
      break;
    case 'a':
      hero.movingLeft = true;
      hero.facingLeft = false;
      break;
    case 'd':
      hero.movingRight = true;
      hero.facingRight = false;
      break;
    default:
      break;
    }
  }//end if hero alive
}//end keyPressed

void keyReleased() {
  if (hero.alive) {
    switch(key) {
    case 'w':
      hero.movingUp = false;
      hero.facingUp = true;
      break;
    case 's':
      hero.movingDown = false;
      hero.facingDown = true;
      break;
    case 'a':
      hero.movingLeft = false;
      hero.facingLeft = true;
      break;
    case 'd':
      hero.movingRight = false;
      hero.facingRight = true;
    default:
      break;
    }
    if (keyCode==32) {
      if (ammo.size() > 0) {
        PVector bullet=new PVector();
        bullet.x = hero.posX;
        bullet.y = hero.posY+24;
        bullets.add(bullet);
        ammo.remove(ammo.size()-1);
        if (!shot_played && !shot_sound.isPlaying()) {
          shot_sound.play();
          shot_played = true;
        }
      }
    }
  }//end if hero alive
  if (!opening && !hero.alive) {
    switch(key) {
    case 'r':
      opening = true;
      open_st=millis();
    }
  }
}//end keyReleased

void mouseReleased() {
  if (hero.alive) {
    int clickedTileX = ceil(mouseX/16);
    int clickedTileY = ceil(mouseY/16);
    if (clickedTileX == currentTileX || clickedTileX+1 == currentTileX || clickedTileX-1 == currentTileX) {
      if (clickedTileY == currentTileY || clickedTileY+1 == currentTileY || clickedTileY-1 == currentTileY) {
        board.exposedmap[clickedTileX][clickedTileY] = true;
      }
    }
    if (board.minemap[clickedTileX][clickedTileY] == 9) {
      hero.alive = false;
      if (!boom_played && !boom_sound.isPlaying()) {
        boom_sound.play();
        boom_played = true;
      }
    }
  }//end if hero alive
}//end mouseReleased

