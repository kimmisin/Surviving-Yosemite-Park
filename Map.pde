class Map {
  PImage grass, dirt, wave, water, background;
  PGraphics map;
  float x, y, tileW, tileH;
  int[][] data;
  
  Map(int numX, int numY) {
    tileW = width/numX;
    tileH = height/numY;
    imageMode(CORNER);
    grass = loadImage("g1.png");
    dirt = loadImage("g2.png");
    wave = loadImage("w1.png");
    water= loadImage("w2.png");
    background = loadImage("BG.png");
    map = createGraphics(width*4, height);
  }
  
  void create() {
    x = 0;
    y = map.height-tileH;
    int num = int(random(3));
    
    //map1
    if (num == 0) {
      data = new int[][] {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1},
                          {0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,2,2,2,2},
                          {1,1,1,1,1,1,3,1,1,3,1,2,2,2,2,2,1,3,1,3,1,1,1,1,1,1,1,1,1,3,1,2,2,2,2,2,2,2,2,2},
                          {2,2,2,2,2,2,4,2,2,4,2,2,2,2,2,2,2,4,2,4,2,2,2,2,2,2,2,2,2,4,2,2,2,2,2,2,2,2,2,2}};
    }
    
    //map2
    else if (num == 1) {
      data = new int[][] {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0},
                          {1,1,1,0,0,0,1,1,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,0,1,2,2,1,1,0,0,0,0},
                          {2,2,2,1,3,1,2,2,2,1,1,3,1,2,2,1,1,3,1,2,2,1,3,1,2,2,1,3,1,3,1,2,2,2,2,2,1,3,1,1},
                          {2,2,2,2,4,2,2,2,2,2,2,4,2,2,2,2,2,4,2,2,2,2,4,2,2,2,2,4,2,4,2,2,2,2,2,2,2,4,2,2}};
    }
    
    //map3
    else if (num == 2) {
      data = new int[][] {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0},
                          {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,2,2,1,1,0,0,0,1},
                          {1,1,3,1,3,1,2,1,3,1,1,3,1,1,3,1,1,3,1,3,1,3,1,1,2,2,1,3,1,3,1,2,2,2,2,2,1,3,1,2},
                          {2,2,4,2,4,2,2,2,4,2,2,4,2,2,4,2,2,4,2,4,2,4,2,2,2,2,2,4,2,4,2,2,2,2,2,2,2,4,2,2}};
    }
                     
    // build the map
    map.beginDraw();
    // draw from the bottom up
    for (int i = data.length - 1; i >= 0; i--) {
      for (int j = 0; j < data[i].length; j++){
        int value = data[i][j];
        if (value == 0) {}
        else if (value == 1) {
          map.image(grass, x, y, tileW, tileH);
        }
        else if (value == 2) {map.image(dirt, x, y, tileW, tileH);}
        else if (value == 3) {map.image(wave, x, y, tileW, tileH);}
        else if (value == 4) {map.image(water, x, y, tileW, tileH);}
        x += tileW;
      }
      x = 0;
      y -= tileH;
    }
    map.endDraw();
  }
  
  float scroll(float playerX) {
    return((map.width-width)*(playerX/width));
  }
  
  float[] getBounds() {
    float[] ypos = new float[data[0].length];
    
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data[i].length; j++) {
        if (data[i][j] == 1) {
          ypos[j] = height - (tileH * (data.length - i));
        }
      }
    }
    return ypos;
  }
}
