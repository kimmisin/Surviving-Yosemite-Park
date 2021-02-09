class ObstacleSystem {
  ArrayList<Obstacle> obstacles;
  int level;
  Boolean bearFlag;
  float offsetVal = 0;
  
  //pause variables
  Boolean pressed = false;
  float time = 0;
  float elapsed = 0;
  
  ObstacleSystem() {
    obstacles = new ArrayList<Obstacle>();
    this.level = 1;
    bearFlag = false;
  }
  
  void addObstacle() {
    if (!pressed) {
      int rand = int(random(3));
      if (rand == 0) {obstacles.add(new Rock(100, level, 5));}
      else if (rand == 1) {
        int dir = int(random(2));
        obstacles.add(new Log(50, level, 5, dir));
      }
      else if (rand == 2) {
        obstacles.add(new Bear(120, level , 3));
      }
    }
  }
  
  void run(float playerX) {
    for (int i = obstacles.size()-1; i >= 0; i--) {
      Obstacle o = obstacles.get(i);
      if (o.size == 120 && bearFlag) {
        o.hit = true;
        o.currentFrame = 0;
        bearFlag = false;
      }
      if (pressed) {
        o.pressed = true;
      }
      else { 
        o.pressed = false;
      }
      o.run(offsetVal, playerX);
      if (o.isDead()) {
        obstacles.remove(i);
      }
    }
  }
  
  ArrayList<Obstacle> getObstacles() {
    return(obstacles);
  }
  
  PVector[] getPositions() {
    PVector[] positions = new PVector[obstacles.size()];
    for (int i = 0; i < obstacles.size(); i++) {
      positions[i] = obstacles.get(i).returnPos();
    }
    return positions;
  }
  
  float[] getSizes() {
    float[] sizes = new float[obstacles.size()];
    for (int i = 0; i < obstacles.size(); i++) {
      sizes[i] = obstacles.get(i).returnSize();
    }
    return sizes;
  }
  
  void getLevel(int lvl) {
    level = lvl;
  }
  
  void reset() {
    level = 1;
    obstacles.clear();
  }
  
  void checkDead(Boolean killed) {
    if (killed) { bearFlag = true; }
  }
  
  void getOffset(float offset) {
    offsetVal = offset;
  }

  
  Boolean pause(float mx, float my, float x, float y, float size) {
    if (dist(mx, my, x, y) < size) {
      pressed = !pressed;
      // pause button has been pressed to stop the animation [true]
      if (pressed) {
        // current elapsed time within the timer interval
        elapsed = millis() - time;
        return(true);
      }
      // resume timer accounting for the previously elapsed time within 
      // the stopped interval (must be subtraction) [false]
      else if (!pressed) {
        time = millis() - elapsed;
      }
    }
    return(false);
  }
}
