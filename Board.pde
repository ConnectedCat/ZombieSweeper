class Board {
  PImage tilemap[][];
  int minemap[][];
  boolean exposedmap[][];
  int bWidth, bHeight;

  Board(int _width, int _height) {
    minemap = new int[_width/16][_height/16];
    tilemap = new PImage[_width/16][_height/16];
    exposedmap = new boolean[_width/16][_height/16];

    bWidth = _width;
    bHeight = _height;
  }//end constructor

  void init() {
    for (int x = 0; x < bWidth/16; x++) {
      for (int y = 0; y < bHeight/16; y++) {
        int imgRand = (int)random(1, 4);
        tilemap[x][y] = loadImage("tile_" + imgRand + ".jpg");
        exposedmap[x][y] = false;

        int t = int(random(-20, 1));
        if (t==0) {
          minemap[x][y]=9;//mine
        }
        else {
          minemap[x][y]=-1;//non-mine
        }
      }//end inner for loop
    }//end outer foor loop

    for (int x = 0; x < bWidth/16; x++) {
      for (int y = 0; y < bHeight/16; y++) {
        if (minemap[x][y] == -1) {
          int count = 0;
          if (x-1 >= 0 && y-1 >= 0) {
            if (minemap[x-1][y-1] == 9) {
              count++;
            }
          }
          if (x-1 >= 0) {
            if (minemap[x-1][y] == 9) {
              count++;
            }
          }
          if (x-1 >= 0 && y+1 < bHeight/16) {
            if (minemap[x-1][y+1] == 9) {
              count++;
            }
          }
          if (y-1 >= 0) {
            if (minemap[x][y-1] == 9) {
              count++;
            }
          }
          if (y+1 < bHeight/16) {
            if (minemap[x][y+1] == 9) {
              count++;
            }
          }
          if (x+1 < bWidth/16 && y-1 >= 0) {
            if (minemap[x+1][y-1] == 9) {
              count++;
            }
          }
          if (x+1 < bWidth/16) {
            if (minemap[x+1][y] == 9) {
              count++;
            }
          }
          if (x+1 < bWidth/16 && y+1 < bHeight/16) {
            if (minemap[x+1][y+1] == 9) {
              count++;
            }
          }
          minemap[x][y] = count;
        }//end checking for non-mine
      }//end inner for loop
    }//end outer foor loop
  }// end init
  void update() {
    for (int x = 0; x < bWidth/16; x++) {
      for (int y = 0; y < bHeight/16; y++) {
        image(tilemap[x][y], x*16, y*16);
        if(exposedmap[x][y]){
        text(minemap[x][y], x*16 + 8, y*16 + 16);
        }
      }
    }
  }//end update
}//end class

