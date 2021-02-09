class Sprite {
  // music component
  Sound music;
  Boolean [] soundFlags;
  
  // sprite character
  float [] position;
  float hitBuffer, step, factor, jumpStop, jumpHalfX;
  int size, lifespan;
  int [] numFrames;
  
  // sprite frames
  PImage[] idle, run, jump, dead;
  
  // pet
  int petFrames, currentPet, hitFrames;
  float petSize, petY, angle;
  PImage[] flying, hit;
  
  // timer variables
  float time, elapsed, petTime, petElapsed;
  int currentFrame, interval;
  Boolean pressed;
  
  // flags
  //Boolean runRFlag, runLFlag, jumpFlag, idleFlag, deathFlag, deathNoLoop
  Boolean[] flags;
  Boolean faceLeft;
  
  Sprite(PApplet sketch, float x, float y, int s, int inter, float scale) {
    music = new Sound(sketch);
    // 0:jump    1:jumpAlreadyPlaying    2:gotHit
    soundFlags = new Boolean [] {false, false, false};
    // updating x, updating y, original x, original y, jump deltaX, jump deltaY, jump's start y-position 
    position = new float [] {x, y, x, y, 0.0, 0.0, 0.0};
    hitBuffer = 0;
    step = 1.5;
    factor = scale;
    jumpStop = -1;
    jumpHalfX = -1;
    size = s;
    lifespan = 5;
    
    //idleFrames = 16; runFrames = 20; jumpFrames = 30; deadFrames = 30;
    numFrames = new int[] {16, 20, 30, 30};
    
    // load in all the sprites for each array
    imageMode(CENTER);
    idle = new PImage[numFrames[0]];
    for (int i = 0; i < idle.length; i++) {
      String name = "Idle (" + nf(i+1, 0) + ").png";
      idle[i] = loadImage(name);
    }
   
    run = new PImage[numFrames[1]];
    for (int i = 0; i < run.length; i++) {
      String name = "Run (" + nf(i+1, 0) + ").png";
      run[i] = loadImage(name);
    }
    
    jump = new PImage[numFrames[2]];
    for (int i = 0; i < jump.length; i++) {
      String name = "Jump (" + nf(i+1, 0) + ").png";
      jump[i] = loadImage(name);
    }
    
    dead = new PImage[numFrames[3]];
    for (int i = 0; i < dead.length; i++) {
      String name = "Dead (" + nf(i+1, 0) + ").png";
      dead[i] = loadImage(name);
    }
    
    // pet
    petFrames = 4;
    hitFrames = 2;
    currentPet = 0;
    petSize= size/4;
    petY = 0;
    angle = 0;
    flying = new PImage[petFrames];
    for (int i = 0; i < flying.length; i++) {
      String name = "frame-" + nf(i+1, 0) + ".png";
      flying[i] = loadImage(name);
    }
   
    hit = new PImage[hitFrames];
    for (int i = 0; i < hit.length; i++) {
      String name = "gotHit-" + nf(i+1, 0) + ".png";
      hit[i] = loadImage(name);
    }
    
    // timer variables
    time = 0;
    elapsed = 0;
    petTime = 0;
    petElapsed = 0;
    currentFrame = 0;
    interval = inter;
    pressed = false;
    
    // flags
    flags = new Boolean[6];
    // 0:runR  1:runL  2:jump  3:idle  4:death  5:deathNoLoop
    for (int f = 0; f < flags.length; f++) {
      flags[f] = false;
      // idle must start off being true
      if (f == 3) {flags[f] = true;}
    }
    faceLeft = false;
  }
 
  void safe(float[] map, float tileW, Boolean faceLeft) {
    // tile number that the player is on
    int num = floor(4*position[0] / tileW);
    if ((num < map.length) && (num >= 0)) {
      float value = map[num];
      // value 0 = water, player loses game immediately
      if (value == 0) {
        if (faceLeft) {position[0] -= size/9;}
        else {position[0] += size/9;}
        position[1] += size/8;
        lifespan = 0;
      }
      // the next step is even ground: do nothing to x and y
      else if (position[1]+(size/factor) == value) {}
      // elevated ground is blocking the road: stay at the old xy position
      else if (position[1]+(size/factor) > value) {
        if (faceLeft) {position[0] += step;}
        else {position[0] -= step;}
      }
      // falling off the cliff: change y to value
      else if (position[1]+(size/factor) < value) {
        position[1] = value-(size/factor);}
    }
    
  }
  
  // key was pressed so move the sprite accordingly
  void move(char k, float[] map, float tileW) {
    //println(position[0]);
    imageMode(CENTER);
    if (!pressed) {hitBuffer -= 0.0167;}
    angle += 0.1;
    // d: run right flags[0]  numFrames[1]
    if (k == 'd' || k == 'D') {
      // only update currentFrame and position if game not paused
      if (!pressed) {
        faceLeft = false;
        currentFrame = displayRate(currentFrame, numFrames[1], updateFlags(0), interval);
        position[0] = constrain(position[0]+step, 0, width);
        safe(map, tileW, faceLeft);
        petY = (petSize/2)*sin(angle);
        if (hitBuffer > 0) {
          if (currentPet >= hitFrames) {currentPet = 0;}
          currentPet = displayRate(currentPet, hitFrames, false, 18);
        }
        else if (hitBuffer <= 0) {currentPet = displayRate(currentPet, petFrames, false, 18);}
        faceLeft = false;
      }
      pushMatrix();
      translate(position[0], position[1]);
      if (hitBuffer > 0) {tint(209, 28, 19, 230);}
      image(run[currentFrame], 0, 0, size, size);
      noTint();
      translate(-50, 15 + petY);
      if (hitBuffer > 0) {image(hit[currentPet], 0, 0, petSize, petSize);}
      else {image(flying[currentPet], 0, 0, petSize, petSize);}
      popMatrix();
    }
    // a: run left flags[1]  numFrames[1]
    else if (k == 'a' || k == 'A') {
      // only update currentFrame and position if game not paused
      if (!pressed) {
        faceLeft = true;
        currentFrame = displayRate(currentFrame, numFrames[1], updateFlags(1), interval);
        position[0] = constrain(position[0]-step, 0, width);
        safe(map, tileW, faceLeft);
        petY = (petSize/2)*sin(angle);
        if (hitBuffer > 0) {
          if (currentPet >= hitFrames) {currentPet = 0;}
          currentPet = displayRate(currentPet, hitFrames, false, 18);
        }
        else if (hitBuffer <=0) {currentPet = displayRate(currentPet, petFrames, false, 18);}
        
      }
      pushMatrix();
      translate(position[0], position[1]);
      scale(-1, 1);
      if (hitBuffer > 0) {tint(209, 28, 19, 230);}
      else if (hitBuffer <=0) {noTint();}
      image(run[currentFrame], 0, 0, size, size);
      noTint();
      translate(-50, 15+petY);
      if (hitBuffer > 0) {image(hit[currentPet], 0, 0, petSize, petSize);}
      else {image(flying[currentPet], 0, 0,petSize, petSize);}
      popMatrix();
    }
    // w: jump flags[2] numFrames[2]
    else if (k == 'w' || k == 'W') {
      // only update currentFrame and position if game not paused
      if (!pressed) {
        petY = (petSize/2)*sin(angle);
        if (hitBuffer > 0) {
          if (currentPet >= hitFrames) {currentPet = 0;}
          currentPet = displayRate(currentPet, hitFrames, false, 18);
        }
        else if (hitBuffer <= 0) {currentPet = displayRate(currentPet, petFrames, false, 18);}
        Boolean predictTile = updateFlags(2);
        if (predictTile) {
          position[6] = position[1];
          int num;
          // jump spans a x length of 35.1
          if (faceLeft) {
            jumpHalfX = position[0] - (35.1/2);
            if (position[0]-35.1 <= 0) {num = 0;}
            else {num = floor(4 * (position[0]-35.1) / tileW);}
          }
          else {
            jumpHalfX = position[0] + (35.1/2);
            if (position[0]+35.1 >= width) {num = map.length-1;}
            else {num = floor(4 * (position[0]+35.1) / tileW);}
          }
          if ((num < map.length) && (num >= 0)) {
            float value = map[num];
            // water is always at ground level
            if (value == 0)  {jumpStop = max(map)-(size/factor);}
            else {jumpStop = value-(size/factor);}
          }
        }
        currentFrame = displayRate(currentFrame, numFrames[2], predictTile, interval);
        position[4] = position[4] + (step/15);
        // arc height: size
        // arc length: step*3.33
        position[5] = (size*sin(((2*PI)/(step*3.33))*position[4])) + 2;

        if (faceLeft) {position[0] = constrain(position[0] - position[4], 0, width);}
        else {position[0] = constrain(position[0] + position[4], 0, width);}
        position[1] = position[6] - position[5];
        
        
        // continue with jump animation until full arc is finished
        if ((position[1] >= jumpStop) && (jumpStop > 0) && ((((!faceLeft && (position[0] > jumpHalfX)) || (faceLeft && (position[0] < jumpHalfX)))) || ((position[0] <= 1) || position[0] >= width-1))){
          // return to idle state and reset position arguments
          soundFlags[1] = false;
          updateFlags(3);
          currentFrame = 0;
          position[4] = 0;
          int num = floor(4*(position[0]) / tileW);
          if ((num < map.length) && (num >= 0)) {
            float value = map[num];
            if (value == 0) {
              position[1] += size/8;
              lifespan = 0;
            }
            else {position[1] = value-(size/factor);}
          }
          else {position[1] = jumpStop;}
        }
      }
      pushMatrix();
      translate(position[0], position[1]);
      if (hitBuffer > 0) {tint(209, 28, 19, 230);}
      if (faceLeft) {scale(-1, 1);}
      image(jump[currentFrame], 0, 0, size, size);
      noTint();
      translate(-50, 15+petY);
      if (hitBuffer > 0) {image(hit[currentPet], 0, 0, petSize, petSize);}
      else {image(flying[currentPet], 0, 0, petSize, petSize);}
      popMatrix();
    }
    // nothing pressed: idle flags[3]  numFrames[0]
    else if (k == 's') {
      // only update currentFrame if game not paused
      if (!pressed) {
        currentFrame = displayRate(currentFrame, numFrames[0], updateFlags(3), interval);
        petY = (petSize/2)*sin(angle);
        if (hitBuffer > 0) {
          if (currentPet >= hitFrames) {currentPet = 0;}
          currentPet = displayRate(currentPet, hitFrames, false, 18);
        }
        else if (hitBuffer <= 0) {currentPet = displayRate(currentPet, petFrames, false, 18);}
      }
      pushMatrix();
      translate(position[0], position[1]);
      if (hitBuffer > 0) {tint(209, 28, 19, 230);}
      if (currentFrame >= numFrames[0]) {currentFrame = 0;}
      if (faceLeft) {scale(-1, 1);}
      image(idle[currentFrame], 0, 0, size, size);
      noTint();
      translate(-50, 15+petY);
      if (hitBuffer > 0) {image(hit[currentPet], 0, 0, petSize, petSize);}
      else {image(flying[currentPet], 0, 0, petSize, petSize);}
      popMatrix();
    }
  }
  
  // all lives lost: death flags[4] numFrames[3]  
  Boolean deadPlayer() {
    noTint();
    // game not paused: update frames
    if (!pressed) {
      // don't loop death animation flags[5]
      if (flags[5]) {
        currentFrame = numFrames[3] - 1;
        pushMatrix();
        translate(position[0], position[1]);
        if (faceLeft) {scale(-1, 1);}
        image(dead[currentFrame], 0, 0, size+10, size+10);
        translate(-50, 15);
        image(hit[currentPet], 0, 0, size/4, size/4);
        popMatrix();
        return(true);
      }
      // not the death animation's last frame yet
      else {
        currentFrame = displayRate(currentFrame, numFrames[3], updateFlags(4), interval-5);
        if (currentPet >= hitFrames) {currentPet = 0;}
        currentPet = displayRate(currentPet, hitFrames, false, 18);
      }
      // last frame of the death animation: turn on flag for noLoopDeath
      if ((currentFrame == (numFrames[3] - 1))) {
        updateFlags(5);
        return(true);
      }
    }
    pushMatrix();
    translate(position[0], position[1]);
    if (faceLeft) {scale(-1, 1);}
    image(dead[currentFrame], 0, 0, size+10, size+10);
    translate(-50, 15);
    image(hit[currentPet], 0, 0, size/4, size/4);
    popMatrix();
    return(false);
  }
  
  // check if the player collides with the obstacle (assuming enemys is the diameter)
  void collided(ArrayList<Obstacle> obstacles) {
    // only take away lives if game is not paused
    if (!pressed) {
      // 0:smallX  1:largeX  2:smallY  3:largeY
      float[] playerXYRange = new float[] {position[0]-(size/4), position[0]+(size/4), position[1]-(size/2.5), position[1]+(size/2)};
      
      // check for collision between every on screen obstacle
      for (int i = obstacles.size()-1; i >= 0; i--) {
        Obstacle obj = obstacles.get(i);
        float enemyX = obj.pos.x;
        float enemyY = obj.pos.y;
        float enemyS = obj.size;
        // 0:smallX  1:largeX  2:smallY  3:largeY
        float[] enemyXYRange = new float[] {enemyX-(enemyS/2), enemyX+(enemyS/2), enemyY-(enemyS/2), enemyY+(enemyS/2)};
        
        // check for XY range overlap
        Boolean xOverlap = checkOverlap(playerXYRange[0], playerXYRange[1], enemyXYRange[0], enemyXYRange[1]);
        Boolean yOverlap = checkOverlap(playerXYRange[2], playerXYRange[3], enemyXYRange[2], enemyXYRange[3]);
        if (xOverlap && yOverlap) {
          if ((obj.hit == false) && (hitBuffer <= 0)) {
              if (lifespan > 0) {
                // turn on gotHit flag so music can play
                soundFlags[2] = true;
                lifespan -= 1;
              }
              hitBuffer = 1;
          }
        }
      }
    }
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
  
  // use a timer to control the display rate of the sprite frames
  int displayRate(int current, int frames, Boolean switched, int inter) {
    // account for when we switch between run, jump, idle, death (switched is always false for the pet)
    if (switched) {
      current = 0;
      time = millis();
    }
    else {
      if (frames != petFrames) {
        if ((millis() - time) >= inter) {
          current = (current + 1) % frames;
          time = millis();
        }
      }
      else {
        if ((millis() - petTime) >= inter) {
          current = (current + 1) % frames;
          petTime = millis();
        }
      }
    }
    return(current);
  }
  
  // turn on the associated flag for the pressed key
  Boolean updateFlags(int num) {
    Boolean changed = false;
    for (int f = 0; f < flags.length; f++) {
      // turn flag on
      if (f == num) {
        // check if switching between run, jump, idle, and death
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
  
  void update(ArrayList<Obstacle> obstacles, float[] map, float tileW, Boolean muteSoundEffects) {
    // Sprite Movement & Display
    if (flags[0]) {move('d', map, tileW);}
    else if (flags[1]) {move('a', map, tileW);}
    else if (flags[2]) {
      move('w', map, tileW);
      // check if jump.mp3 is already playing
      if (soundFlags[1] == false && !muteSoundEffects) {
          soundFlags[0] = true;
          soundFlags[1] = true;
        }
      // play jump.mp3 if not playing already
      if (soundFlags[0] && !muteSoundEffects) {
        music.playJump();
        soundFlags[0] = false;
      }
    }
    else if (flags[3]) {move('s', map, tileW);}
    
    // Only check for collision if there is an obstacle
    if (obstacles.size() != 0) {
      // Check if player collides with obstacle: remove lives if yes
      collided(obstacles);
      if (soundFlags[2] && !muteSoundEffects) {
        music.playLifeHit();
        soundFlags[2] = false;
      }
    }
    
  }
  
  // player has hit the pause button
  Boolean pause(float mx, float my, float x, float y, float size) {
    if (dist(mx, my, x, y) < size) {
      pressed = !pressed;
      // pause button has been pressed to stop the animation [true]
      if (pressed) {
        // current elapsed time within the timer interval
        elapsed = millis() - time;
        petElapsed = millis() - petTime;
        return(true);
      }
      // resume timer accounting for the previously elapsed time within 
      // the stopped interval (must be subtraction) [false]
      else if (!pressed) {
        time = millis() - elapsed;
        petTime = millis() - petElapsed;
        // reset back to idle unless paused during jump or death animation
        if (flags[2] != true && flags[4] != true && flags[5] != true) {updateFlags(3);}
      }
    }
   return(false);
  }
  
  // reset Sprite variables for player to restart the game
  void restart() {
    position[0] = position[2];
    position[1] = position[3];
    hitBuffer = 0;
    lifespan = 5;
    
    // pet
    currentPet = 0;
    angle = 0;
    
    // timer variables
    time = 0;
    elapsed = 0;
    petTime = 0;
    petElapsed = 0;
    currentFrame = 0;
    pressed = false;
    
    // flags
    // 0:runR  1:runL  2:jumpR   3:idle  4:death  5:deathNoLoop
    for (int f = 0; f < flags.length; f++) {
      flags[f] = false;
      // idle must be true to start off
      if (f == 3) {flags[f] = true;}
    }
    
    for (int f = 0; f < this.soundFlags.length; f++) {
      this.soundFlags[f] = false;
    }
    faceLeft = false;
  }
}
