class Star {
  Sound music;
  Boolean mute;
  float [] position, map;
  float size, wait, mapW;
  int pointValue, max;
  // 0:starFrames    1:pickedFrames
  int [] numFrames;
  Boolean pressedE, grab, collected;
  Boolean[] soundFlags;
  
  ArrayList<Star> objects;
  
  // timer variables for sprite set
  float time, elapsed, interval, starTime, starElapsed;
  int starFrame, grabFrame;
  Boolean pressed;
  
  // sprite frames
  PImage[] point, pluck;
  PImage spritesheet;
  
  Star(float x, float y, int s, PImage[] _point, PImage[] _pluck) {
    position = new float[] {x, y};
    size = s;
    wait = 0;
    // 0:starFrames    1:pickedFrames
    numFrames = new int[] {60, 89};
    grab = false;
    collected = false;
    // 0:play starPicked   1:alreadyPlaying
    soundFlags = new Boolean[] {false, false};
    time = 0;
    elapsed = 0;
    interval = 10;
    starTime = 0.1;
    starElapsed = 0;
    starFrame = 0;
    grabFrame = 0;
    pressed = false;
    point = _point;
    pluck = _pluck;
  }
  
  Star(PApplet sketch, float[] mapY, float mapWidth, int num) {
    music = new Sound(sketch);
    mute = false;
    objects = new ArrayList<Star>();
    pressed = false;
    pressedE = false;
    grab = false;
    pointValue = 100;
    map = mapY;
    mapW = mapWidth;
    max = num;
    // 0:starFrames    1:pickedFrames
    numFrames = new int[] {60, 89};
    
    point = new PImage[numFrames[0]];
    spritesheet = loadImage("SmallStar_64x64.png");
    int w = spritesheet.width/numFrames[0];
    int h = spritesheet.height;
    for (int i = 0; i < point.length; i++) {
      int _x = i%numFrames[0]*w;
      int _y = i/numFrames[0]*h;
      point[i] = spritesheet.get(_x, _y, w, h);
    }
    
    pluck = new PImage[numFrames[1]];
    spritesheet = loadImage("TornadoMoving_96x96.png");
    w = spritesheet.width/numFrames[1];
    h = spritesheet.height;
    for (int i = 0; i < pluck.length; i++) {
      int _x = i%numFrames[1]*w;
      int _y = i/numFrames[1]*h;
      pluck[i] = spritesheet.get(_x, _y, w, h);
    }
  }
  
  int spawn(float[] player, int playerSize, int level, float offset, float tileW) {
    imageMode(CENTER);
    // add star objects to arraylist if game not paused
    if (!pressed){
      // delay the next star appearance
      float waitGoal = (-4*level) + 100;
      wait = constrain(wait + 1, 0, waitGoal); 
      if ((wait == waitGoal) && (objects.size() < max)) {
        Boolean placeable = false;
        while (!placeable) {
          float randX = random(width/10, (9*mapW)/10);
          // check if chosen randX is placeable ground
          float canvasNormalized = randX/mapW*width;
          int num = floor(4 * canvasNormalized / tileW);
          if ((num < map.length) && (num >= 0)) {
            float value = map[num];
            if (value != 0) {
              placeable = true;
              // account for shifted distance in rand
              float playerMapX = player[0]*3;
              objects.add(new Star(randX-playerMapX, value-(playerSize/2), 80, point, pluck));
            }
          }
        }
        wait = 0;
      }
    }
    // Boolean for returning pointValue if it is the last frame of star pick up animation
    Boolean reward = false;
    // iterate through the star objects arraylist
    for (int i = objects.size() - 1; i >= 0; i--) {
      Star obj = objects.get(i);
      // game not paused: update starFrame and grabFrame if applicable
      if (!pressed) {
        obj.starFrame = displayRate(obj.starFrame, obj.numFrames[0]);
        obj.position[0] -= offset;
        // check if player can pick up the star
        if (pressedE) {
          Boolean valid = pickUp(player[0], player[1], playerSize, obj.position[0], obj.position[1], obj.size);
          if (valid) {
            if (obj.collected == false) {
              reward = true;
              obj.collected = true;
            }
            obj.soundFlags[0] = true;
            if (obj.soundFlags[0] && obj.soundFlags[1] == false && mute == false) {music.playStarPick();}
            obj.soundFlags[1] = true;;
            obj.grab = true;
            pressedE = false;
          }
          
        }
        // picking up animation if grab == true: update frames
        if (obj.grab) {obj.grabFrame = displayRate(obj.grabFrame, obj.numFrames[1]);}
      }
      image(obj.point[obj.starFrame], obj.position[0], obj.position[1], obj.size, obj.size);
      if (obj.grab) {
        image(obj.pluck[obj.grabFrame], obj.position[0], obj.position[1], obj.size, obj.size);
        // last frame of pick up animation: stop displaying star and pick up animation
        if (obj.grabFrame >= obj.numFrames[1]-1) {
          objects.remove(i);
        }
      }
    }
    // return number of points gained
    if (reward) {return(pointValue);}
    else {return(0);}
  }
   
  // Verify if player is overlaped with the Star
  Boolean pickUp(float x, float y, int s, float starX, float starY, float starS) {
    Boolean overlapX = checkOverlap(x-(s/4), x+(s/4), starX-(starS/3), starX+(starS/3));
    Boolean overlapY = checkOverlap(y-(s/4), y+(s/4), starY-(starS/3), starY+(starS/3));
    if (overlapX && overlapY) {return(true);}
    return(false);
  }
  
  // Helper method to check player and star overlap
  Boolean checkOverlap(float playerS, float playerL, float starS, float starL) {
    //playerS is the smallest
    if (playerS < starS) {
      //yes overlap if playerL is greater than or equal to starS
      if (playerL >= starS) {return(true);}
    }
    // starS is the smallest
    else if (playerS > starS) {
      //yes overlap if starL is greater than or equal to playerS
      if (starL >= playerS) {return(true);}
    }
    // both lower bounds are equal, they overlap
    else if (playerS == starS) {return(true);}
    return(false);
  }
  
  // use a timer to control the display rate of the sprite frames
  int displayRate(int currentFrame, int frames) {
    if ((millis() - time) >= interval) {
      currentFrame = (currentFrame + 1) % frames;
      time = millis();
    }
    return(currentFrame);
  }
  
  void getMusicChoice(Boolean choice) {
    mute = choice;
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
  
  // reset parameters for a new game
  void restart() {
    objects.clear();
    pressed = false;
    pressedE = false;
    grab = false;
    wait = 0;
  }
}
