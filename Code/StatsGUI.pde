class StatsGUI {
  float x = 0;
  float y = 0;
  PImage life;
  Boolean displayBanner;
  Boolean instruct;
  Boolean select;
  int map_select;


  StatsGUI() {
    life = loadImage("gameheart.png");
    displayBanner = true;
    instruct = false;
    select = false;
  }

  void displayLevel(int lvl) { 
    // maybe change text font later
    rectMode(CENTER);
    textSize(50);
    fill(200,200,100);
    textAlign(CENTER);
    text(str(lvl), 370, 60);
    textSize(20);
    text("level", 370, 20);
    noFill();
    rect(400, 10, 100, 100);
  }

  void displayLives(int lives) {
    //place hearts at the point of the screen equally spaced
    x = 80;
    y = 30;
    for (int i = 1; i <= lives; i += 1) {
      image(life, x+90, y, 22, 22);
      x += 24;
    }
  }

  void displayWonBanner() { 
    rectMode(CORNER);
    fill(50, 250, 50);
    rect(0,0, width, height/2);
    fill(250, 155, 100);
    rect(0, height/2, width, height/2);
    fill(100, 250, 250);
    rect(0, height/5, width, 2*height/3);
    fill(250, 150, 50);
    rectMode(CENTER);
    rect(width/3, 400, 165, 80);
    rect(2*width/3, 400, 165, 80);
    rect(width/2, 550, 165, 80);
    fill(0, 75, 150);
    textAlign(CENTER);
    textSize(60);
    text("GAME OVER", width/2, 200);
    textSize(25);
    text("HIGH SCORES", width/3, 400);
    text("MAIN MENU", 2*width/3, 400);
    text("RESTART", width/2, 550);
    
  }

  void displayScore(int score) {
    //change font later
    textSize(30);
    text("SCORE", 530, 35);
    text(str(score), 530, 60);
  }

  void displayChargebar(float scorepoint) {
    //rectMode(CORNER);
    // chargebar holder: white outline
    //noFill();
    fill(#ffc0cb);
    arc(75, 75, 55, 55, -HALF_PI, (scorepoint*TWO_PI)/4 - HALF_PI);
    fill(255, 150, 150);
    text("CHARGE", 70, 40);
    
  }

  void displayMenu() { 
    if (!instruct & !select){
      rectMode(CORNER);
      fill(156,229,244);
      rect(0,0, width, height/2);
      fill(67,171,67);
      rect(0, height/2, width, height/2);
      textAlign(CENTER);
      fill(255, 0, 255);
      textSize(50);
      text("SURVIVING YOSEMITE PARK!", width/2, 100);
      textSize(30);
      text("How long will you survive?", width/2, 250);
      fill(228,230,232);
      rectMode(CENTER);
      rect(width/2, 400, 125, 80);
      fill(250, 200, 200);
      rect(width/5, 520, 140, 50);
      rect(4*width/5, 520, 140, 50);
      rect(4*width/5, 330, 140, 50);
      fill(0, 40, 110);
      text("PLAY!", width/2, 410);
      fill(0, 40, 110);
      textSize(20);
      text("Instructions", width/5, 530);
      text("Mute", 4*width/5, 530);
      text("High Scores", 4*width/5, 340);
      if (muteMusic){text("MUTED", width/2, 530);}
    }
    else if(instruct){displayInstruct();}
    //else if(select){map_select = levelSelect();}
    else if(gamePaused){pauseScreen();}
     
  }
  
  void displayInstruct(){
    rectMode(CORNER);
    fill(156,229,244);
    rect(0,0, width, height/2);
    fill(67,171,67);
    rect(0, height/2, width, height/2);
    fill(251,248,239);
    rect(0, height/6, width, 2*height/3);
    textAlign(CENTER);
    textSize(20);
    fill(0, 75, 150);
    text("DIRECTIONS", width/2, height/4);
    text("Use A and D to move left and right", width/2, height/4 + 50);
    text("Use W to jump and S to stop", width/2, height/4 + 90);
    text("Use E to pick up stars to gain points", width/2, height/4 + 130);
    text("Use Spacebar to shoot bears. Watch your charge meter!", width/2, height/4 + 170);
    text("Don't touch the water!  It's instant death", width/2, height/4 + 210);
    text("Survive as long as possible.", width/2, height/4 + 250);
    text("GOOD LUCK!", width/2, height/4 + 320);
    fill(250, 200, 200);
    rect(width/2-70, 520, 140, 50);
    fill(0, 0, 0);
    text("EXIT", width/2, 550);

  }
   
  /*int levelSelect(){
    int value;
    value = 4;
    rectMode(CORNER);
    fill(50, 250, 250);
    rect(0,0, width, height/2);
    fill(50, 255, 50);
    rect(0, height/2, width, height/2);
    textAlign(CENTER);
    fill(255, 0, 255);
    textSize(40);
    text("Select Level Difficulty", width/2, 125);
    text("For easy, medium, or hard", width/2, 200);
    text("Please press 1, 2, or 3", width/2, 250);
    if(keyPressed){
      if(key == '1'){
        value = 0;
        displayBanner = false;
        select = false;
      }
      else if(key == '2'){
        value = 1;
        displayBanner = false;
        select = false;
      }
      else if(key == '3'){
        value = 2;
        displayBanner = false;
        select = false;
      }
    }
    return value;
  }*/
  
  
  void pauseScreen(){
   
    rectMode(CORNER);
    fill(158,215,245);
    rect(0,0, width, height/2);
    fill(67,171,67);
    rect(0, height/2, width, height/2);
    fill(200, 150, 90);
    rect(0, height/6, width, 2*height/3);
    fill(250, 200, 200);
    rectMode(CENTER);
    rect(4*width/5, 520, 140, 50);
    pauseButton();
    textAlign(CENTER);
    textSize(50);
    fill(0, 75, 150);
    text("PAUSED", width/2, 200);
    fill(0, 40, 110);
    textSize(24);
    text("Mute", 4*width/5, 530);
    if (muteMusic){text("MUTED", width/2, 530);}
      
  }

  void pauseButton() {
    noStroke();
    fill(255);
    ellipseMode(CENTER);
    rectMode(CENTER);
    ellipse((15*width)/16, 50, 70, 70);
    fill(0);
    rect(((15*width)/16) - 10, 50, 10, 40);
    rect(((15*width)/16) + 10, 50, 10, 40);
  }
  
}
