class Bear extends Obstacle { //<>// //<>//
  PImage[] charge_l, charge_r, die_l, die_r;
  int[] numFrames;
  float speed;
  
  // timer variables
  float time;
  int interval, currentFrame;
  
  Bear(float size, int level, float speed) {
    super(size, level);
    
    pos = new PVector(width, mapY[tile]);
    vel = new PVector(speed * level * -1, 0);
    
    numFrames = new int[] {4, 5};
    
    //load bear charging left sprite
    imageMode(CENTER);
    charge_l = new PImage[numFrames[0]];
    for (int i = 0; i < charge_l.length; i++) {
      String name = "bear_run_l (" + nf(i+1, 0) + ").png";
      charge_l[i] = loadImage(name);
    }
    
    //load bear dying left sprite
    die_l = new PImage[numFrames[1]];
    for (int i = 0; i < die_l.length; i++) {
      String name = "bear_die_l (" + nf(i+1, 0) + ").png";
      die_l[i] = loadImage(name);
    }
    
    // timer variables
    time = 0;
    interval = 75;
    currentFrame = 0;
  }
  
  void display(float playerX) {
    float player = (4*playerX)/map.tileW;
    float offset = (pos.x - playerX) / map.tileW;
    tile = int(player + offset);
    
    // added this if statement due to index out of bounds
    if (tile < mapY.length && tile >= 0){
      if (mapY[tile] == 0) {pos.y = mapY[tile-1] - 50;}
      else{pos.y = mapY[tile] - 50;}
    }
    
    if (!dead) {
      if (hit) {
        if (!pressed) {displayRate(numFrames[1], interval+370);}
        pushMatrix();
        translate(pos.x, pos.y);
        image(die_l[currentFrame], 0, 0, 0.95*size, 0.95*size);
        popMatrix();
        if ((currentFrame >= numFrames[1]-1) && ((millis() - time) >= interval)) {
          dead = true;
        }
      }
      else {
        if (!pressed) {displayRate(numFrames[0], interval);}
        pushMatrix();
        translate(pos.x, pos.y);
        image(charge_l[currentFrame], 0, 0, size, size);
        popMatrix();
      }
    }
  }
  
  void move(float offsetVal) {
    if (!hit && !pressed) { pos.add(vel); }
    pos.x -= offsetVal;
  }
  
  // use a timer to control the display rate of the sprite frames
  void displayRate(int frames, int interval) {
    if ((millis() - time) >= interval) {
      currentFrame = (currentFrame + 1) % frames;
      time = millis();
    }
  }
}
