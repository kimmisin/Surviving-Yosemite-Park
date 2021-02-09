class Attack extends Sprite {
  float [] attackPos;
  float charged, step;
  int size, shootFrames, explodeFrames;
  Boolean killed;
  
  // sprite frames
  PImage[] shoot, explode;
  PImage spritesheet;
  
  // timer variables
  float time, elapsed, interval;
  int shootingFrame, explodingFrame;
  Boolean pressed;
  
  // flags
  Boolean [] flags;
  Boolean [] soundFlags;
  
  Attack(PApplet sketch, float x, float y, int s, int inter, float scale) {
    super(sketch, x, y, s, inter, scale);
    attackPos = new float [] {x, y};
    charged = 4;
    step = 10;
    size = s;
    shootFrames = 45;
    explodeFrames = 60;
    killed = false;
    time = 0;
    elapsed = 0;
    interval = inter;
    shootingFrame = 0;
    explodingFrame = 0;
    pressed = false;
    // for both flag systems  0:shoot    1:explode
    flags = new Boolean [] {false, false};
    soundFlags = new Boolean [] {false, false};
    
    shoot = new PImage[shootFrames];
    spritesheet = loadImage("FireBall_2_64x64.png");
    int w = spritesheet.width/shootFrames;
    int h = spritesheet.height;
    for (int i = 0; i < shoot.length; i++) {
      int _x = i%shootFrames*w;
      int _y = i/shootFrames*h;
      shoot[i] = spritesheet.get(_x, _y, w, h);
    }
    
    explode = new PImage[explodeFrames];
    spritesheet = loadImage("Explosion_3_133x133.png");
    w = spritesheet.width/explodeFrames;
    h = spritesheet.height;
    for (int i = 0; i < explode.length; i++) {
      int _x = i%explodeFrames*w;
      int _y = i/explodeFrames*h;
      explode[i] = spritesheet.get(_x, _y, w, h);
    }
  }
  
  // shooting animation: attack hasn't reached target  flags[0]
  void shoot(ArrayList<Obstacle> obstacles, Boolean faceLeft, float offset) {
      soundFlags[0] = false;
      // only update currentFrame and position if game not paused
      if (!pressed) {
        // update frame and position
        shootingFrame = displayRate(shootingFrame, shootFrames, updateFlags(0));
        if (faceLeft) {attackPos[0] = attackPos[0] - step - offset;}
        else {attackPos[0] = attackPos[0] + step - offset;}
        
        // extract obstacle position and size
        for (int i = obstacles.size()-1; i >= 0; i--) {
          Obstacle obj = obstacles.get(i);
          float enemyX = obj.pos.x;
          float enemyY = obj.pos.y;
          float enemyS = obj.size;
          
          // obstacle is a bear and its size is 120
          if (enemyS == 120) {
            // check if attack overlaps with the bear
            Boolean overlapX = checkOverlap(attackPos[0]-size/2, attackPos[0]+size/2, enemyX-(enemyS/2), enemyX+(enemyS/2));
            Boolean overlapY = checkOverlap(attackPos[1]-size/2, attackPos[1]+size/2, enemyY-(enemyS/2), enemyY+(enemyS/2));
           // target reached: let ObstacleSystem know that bear is killed
            if (overlapX && overlapY) {
              explodingFrame = 0;
              killed = true;
              // have explode animation animate closer to the center of the obstable
              if (faceLeft) {attackPos[0] = attackPos[0] - (enemyS/2) - offset;}
              else {attackPos[0] = attackPos[0] + (enemyS/2) - offset;}
              updateFlags(1);
              // turn hit flag on for explosion
              soundFlags[1] = true;
            }
          }
          // attack is now off screen: stop displaying it
          if ((enemyX >= width) || (enemyX <= 0)) {
              flags[0] = false;
              shootingFrame = 0;
          }
        }
      }
      pushMatrix();
      translate(attackPos[0], attackPos[1]);
      if (faceLeft) {scale(-1, 1);}
      image(shoot[shootingFrame], 0, 0, 50, 50);
      popMatrix();
    }
    
    void resetKilled() {
      if (!pressed) {killed = false;}
    }
    
    // explode animation: attack has reached the target    flags[1]
    void explode(float offset) {
      soundFlags[1] = false;
      // only update currentFrame and position if game not paused
      if (!pressed) {
        explodingFrame = displayRate(explodingFrame, explodeFrames, updateFlags(1));
        attackPos[0] -= offset;
        // last frame of the explosion animation: turn off attack flag 
        if ((explodingFrame == explodeFrames-1)) {
          flags[1] = false;
        }
      }
      pushMatrix();
      translate(attackPos[0], attackPos[1] - 50);
      image(explode[explodingFrame], 0, 0, 200, 200);
      popMatrix();
    }
    
    Boolean checkOverlap(float playerS, float playerL, float enemyS, float enemyL) {
      //playerS is the smallest
      if (playerS < enemyS) {
        //yes overlap if playerL is greater than or equal to enemyS
        if (playerL >= enemyS) {return(true);}
      }
      // enemyS is the smallest
      else if (playerS > enemyS) {
        //yes overlap if enemyL is greater than or equal to playerS
        if (enemyL >= playerS) {return(true);}
      }
      // both lower bounds are equal, they overlap
      else if (playerS == enemyS) {return(true);}
      return(false);
    }
    
    void update(ArrayList<Obstacle> obstacles, Boolean faceLeft, float offset, Boolean muteSoundEffects) {
      // Attack Object Movements
      noTint();
      if (flags[0]) {
        if (!pressed && soundFlags[0] && !muteSoundEffects) {music.playShoot();}
        shoot(obstacles, faceLeft, offset);
      }
      else if (flags[1]) {
        if (!pressed && soundFlags[1] && !muteSoundEffects) {music.playHit();}
        explode(offset);
      }
    }
    
    // use a timer to control the display rate of the sprite frames
    int displayRate(int currentFrame, int frames, Boolean switched) {
      if ((millis() - time) >= interval) {
        currentFrame = (currentFrame + 1) % frames;
        time = millis();
      }
      // account for when we switch between sprite sets
      if (switched) {
        currentFrame = 0;
        time = millis();
      }
      return(currentFrame);
    }
    
    // turn on the associated flag for the pressed key
    Boolean updateFlags(int num) {
      Boolean changed = false;
      for (int f = 0; f < flags.length; f++) {
        // turn flag on
        if (f == num) {
          // check if switching between shooting and explode
          if (flags[f] == false) {
            flags[f] = true;
            changed = true;
          }
        }
        // turn rest of the flags off
        else {flags[f] = false;}
      }
      if (changed) {return(true);}
      else {return(false);}
    }
    
    void updateCharge() {
      if (!pressed) {charged = constrain(charged + 0.0167, 0, 4);}
    }
    
    // player has hit the pause button
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
    
    // reset Attack variables for player to restart the game
    void restart() {
      charged = 4;
      // timer variables
      time = 0;
      elapsed = 0;
      shootingFrame = 0;
      explodingFrame = 0;
      pressed = false;
      killed = false;
      
      // flags
      // 0:shoot 1:explode
      for (int f = 0; f < flags.length; f++) {
        flags[f] = false;
        soundFlags[f] = false;
      }
    }
}
