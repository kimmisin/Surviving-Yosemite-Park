class Rock extends Obstacle {
  PImage rock;
  float speed;
  float deadTimer;
  int tile;
  
  Rock(float size, int level, float speed) {
    super(size, level);
    int x = int(random(width));
    pos = new PVector(x, 0);
    vel = new PVector(0, speed * level);
    this.rock = loadImage("Rock.png");
    this.deadTimer = 0;
  }
  
  void display(float playerX) {
    int player = floor((4*(playerX)/map.tileW));
    int offset = floor((pos.x - playerX) / map.tileW);
    tile = player + offset;
    
    if (tile < mapY.length && tile >= 0){
      if (mapY[tile] == 0) {
        if (pos.y >= mapY[tile-1]-40) { hit = true; }
      }
      else{
        if (pos.y >= mapY[tile]-40) { hit = true; }
      }
    }
    
    shapeMode(CENTER);
    if (!dead) {
      image(rock, pos.x, pos.y, size, size);
    }
    if (hit && !pressed) {
      if (deadTimer < 50) {
        deadTimer++;
      }
    }
  }
  
  void move(float offsetVal) {
    
    if (!hit && !pressed) { 
      pos.add(vel); 
    }
    if (deadTimer >= 50) { dead = true; }
    pos.x -= offsetVal;
  }
}
