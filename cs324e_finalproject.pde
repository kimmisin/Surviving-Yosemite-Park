import processing.sound.*;
Savefile savedRecords;
boolean oneSave;
JSONArray valuesToSave;
JSONArray valuesToLoad;

Sprite player;
Attack fire;
ObstacleSystem os;
StatsGUI gui;
Star nova;
Sound chime; 
Map map;

int level = 1;
int time = 0;
int score = 0;
Boolean gamePaused;
Boolean endGame;
Boolean faceLeft;
Boolean deadMusic;
Boolean muteSoundEffects;
Boolean muteMusic;
Boolean highscore;
PImage background;
float prevMapX;
float [] mapY;
PFont gameFont;

void setup() {
  size(800, 600);
  gamePaused = false;
  endGame = false;
  faceLeft = false;
  highscore = false;
  oneSave = true;
  
   // Initialize Map
  map = new Map(10, 10);
  map.create();
  mapY = map.getBounds();
  background = loadImage("BG.png");
  prevMapX = 0;
  
  // Initialize Sound
  deadMusic = true;
  muteSoundEffects = false;
  muteMusic = false;
  chime = new Sound(this);
  
  // Initialize Savefile
  savedRecords = new Savefile();
  
  // Initalize GUI
  gui = new StatsGUI();
  
  // Intialize Star object
  nova = new Star(this, mapY, map.map.width, 3);
  
  // Intialize Sprite and Attack object to the same x and y position
  // second parameter must be mapY[0]-(size/2.2)
  player = new Sprite(this, 0, mapY[0]-(100/2.2), 100, 30, 2.2);
  fire = new Attack(this, 0, 460, 50, 30, 2.2);
  
  // Initialize ObstacleSystem object
  os = new ObstacleSystem();
  time = millis();
  
  //Fonts
  gameFont = createFont("Forte", 32);
  textFont(gameFont);
}

void draw() {
   if (gui.displayBanner){
    gui.displayMenu();
  }
  else if (gamePaused){
    gui.pauseScreen();
  } 
  else if (highscore) {
    savedRecords.highScoreMenu();
  }
  else {
    /*
    // Michael: lvl_select is either 0, 1 or 2 to correspond to your desired map. the rest is up to you~
    int lvl_select;
    lvl_select = gui.map_select; 
    */
    
    // Map display and variable updates
    image(background, width/2, height/2);
    float mapX = map.scroll(player.position[0]);
    image(map.map, -mapX+(map.map.width/2), height-((map.data.length+1)*map.tileH));
    float offset = mapX - prevMapX;
    prevMapX = mapX;
    os.getOffset(offset);
    
    // GUI start 
    gui.pauseButton();
    if (gui.displayBanner) {gui.displayMenu();}
    
    // Sprite Object Dead: no user interactivity via keyboard
    if (player.lifespan <= 0) {
      if (deadMusic && !muteSoundEffects) {chime.playGameover();}
      deadMusic = false;
      Boolean option = player.deadPlayer();
      if (option) {
        // endgame menu
       if(oneSave){savedRecords.saveScore(score);}
        savedRecords.highScoreMenu();
        if(oneSave){savedRecords.backToFile();}
        oneSave = false;
        endGame = true;
      } 
    } 
    // Sprite Object Alive: allow user interactivity via keyboard
    else {
      // Don't generate obstacles until menu is gone
      if (!gui.displayBanner) {
        // Constantly create new obstacles
        if (millis() - time > (10000 / level)) { 
          os.addObstacle();
          time = millis();
        }
        os.run(player.position[0]);
      }
      
      // Update Sprite & Attack
      player.update(os.getObstacles(), mapY, map.tileW, muteSoundEffects);
      fire.updateCharge();
      fire.update(os.getObstacles(), faceLeft, offset, muteSoundEffects);
      
      // Check if bear has been killed
      os.checkDead(fire.killed);
      fire.resetKilled();
      
      // Don't generate Star objects until menu is gone
      if (!gui.displayBanner) {
        score += nova.spawn(player.position, player.size, level, offset, map.tileW);
        nova.getMusicChoice(muteSoundEffects);
      }
    }
    
    // StatsGUI display objects
    if (!endGame){
      gui.displayChargebar(fire.charged);
      gui.displayLives(player.lifespan);
      if ((score + 1000)/1000 >= 1) {
        level = floor((score + 1000)/1000);
        gui.displayLevel(level); 
      gui.displayScore(score);
      os.getLevel(level);
      }
    
    }
  }
  // Music
  chime.playGeneralMusic(muteMusic, gamePaused); 
}

void keyPressed() {
  if (gamePaused == false) {
    if (player.lifespan > 0) {
      if (key == ' ') {
        // attack must be fully charged
        if (fire.charged >= 4 ) {
          fire.charged = 0;
          fire.attackPos[0] = player.position[0];
          fire.attackPos[1] = player.position[1];
          if (player.faceLeft) {faceLeft = true;}
          else {faceLeft = false;}
          fire.updateFlags(0);
          fire.soundFlags[0] = true;
        }
      }
      // jumping, don't let key press change movement
      else if (player.flags[2] == true){}
      else if (key == 'e' || key == 'E') {nova.pressedE = true;}
      else {player.move(key, mapY, map.tileW);}
    }
  }
  if (gui.displayBanner || endGame) {
    if (key == 'x' || key == 'X') {exit();}
  }
}

void mousePressed() {
  if (gui.displayBanner){
    if (gui.instruct && dist(mouseX, mouseY, width/2, 550) < 140) {gui.instruct = !gui.instruct;}
    else if(dist(mouseX, mouseY, width/2, 400) < 125){
      gui.displayBanner = false;
      highscore = false;
    }
    else if(dist(mouseX, mouseY, width/5, 520) < 130){gui.instruct = !gui.instruct;}
    else if(dist(mouseX, mouseY, 4*width/5, 520) < 130){
      muteMusic = !muteMusic;
      muteSoundEffects = !muteSoundEffects;
    }
    else if(dist(mouseX, mouseY, 4*width/5, 330) < 130){
      gui.displayBanner = false;
      highscore = true;
      endGame = true;
    }
  }
  else if (endGame){
      if (dist(mouseX, mouseY, 5*width/6, height/2) < 80){
        player.restart();
        savedRecords = new Savefile();
        oneSave = true;
        fire.restart();
        os.reset();
        nova.restart();
        score = 0;
        endGame = false;
        gui.displayBanner = true;
        deadMusic = true;
      }
  }
  else{
    if (dist(mouseX, mouseY, (15*width)/16, 50) < 70){
      gamePaused = player.pause(mouseX, mouseY, (15*width)/16, 50, 70);
      fire.pause(mouseX, mouseY, (15*width)/16, 50, 70);
      os.pause(mouseX, mouseY, (15*width)/16, 50, 70);
      nova.pause(mouseX, mouseY, (15*width)/16, 50, 70);
      chime.pause(gamePaused, mouseX, mouseY, (15*width)/16, 50, 70);
    }
    if (gamePaused){
      if(dist(mouseX, mouseY, 4*width/5, 520) < 130){
        muteMusic = !muteMusic;
        muteSoundEffects = !muteSoundEffects;
      }
    }
    
    
  } 
}
