class Log extends Obstacle {
  PImage log;
  float speed, dir, angle;
  
  Log(float size, int level, float speed, float dir) {
    super(size, level);
    this.log = loadImage("log.png");
    this.dir = dir;
    this.angle = 0;
    
    if (this.dir == 0) {
      pos = new PVector(0, mapY[tile]);
      vel = new PVector(speed * level, 0);
    }
    else if (this.dir == 1) {
      pos = new PVector(width, mapY[tile]);
      vel = new PVector(speed * level * -1, 0);
    }
  }
  
  void display(float playerX) {
    float player = 4*(playerX)/map.tileW;
    float offset = (pos.x - playerX) / map.tileW;
    tile = floor(player + offset);
    
    if (tile < mapY.length && tile >= 0){
      if (mapY[tile] == 0) {pos.y = mapY[tile-1] - 20;}
      else{pos.y = mapY[tile] - 20;}
    }
    
    
    shapeMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    if (!pressed) {
      if (this.dir == 0) { rotate(radians(angle)); }
      if (this.dir == 1) { rotate(radians(-angle)); }
    }
    image(log, 0, 0, size, size);
    popMatrix();
    angle += 10;
  }
  
  void move(float offsetVal) {
    if (!pressed) {
      if (dir == 0 ) {
        if (pos.x < width) { pos.add(vel); }
        else { dead = true; }
      }
      if (dir == 1) {
        if (pos.x > 0) { pos.add(vel); }
        else { dead = true; }
      }
      pos.x -= offsetVal;
    }
  }  
  
}
