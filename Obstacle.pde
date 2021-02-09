class Obstacle {
  PVector pos, vel;
  float size;
  float level;
  float offset;
  int currentFrame;
  int tile;
  Boolean dead;
  Boolean hit;
  Boolean pressed;
  float[] mapY = map.getBounds();
  
  Obstacle(float size, int level) {
    this.size = size;
    this.level = level;
    this.offset = 0;
    this.currentFrame = 0;
    this.dead = false;
    this.hit = false;
    this.pressed = false;
  }

  void run(float offsetVal, float playerX) {
    move(offsetVal);
    display(playerX);
  }

  PVector returnPos() {
    return pos;
  }
  
  float returnSize() {
    return size;
  }
  
  Boolean isDead() {
    return dead;
  }
  
  void checkHit() {}
  void move(float offsetVal) {}
  void display(float playerX) {}
}
