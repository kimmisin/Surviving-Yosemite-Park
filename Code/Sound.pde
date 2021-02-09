class Sound {
  SoundFile gameover;
  SoundFile highScore;
  SoundFile starPick;
  SoundFile lifehit;
  SoundFile jump;
  SoundFile hit;
  SoundFile shoot;
  SoundFile general;
  
  Sound(PApplet sketch) {
    //gameover = new SoundFile(sketch, "gameover.mp3");
    gameover = new SoundFile(sketch, "Dreaming.mp3");
    highScore = new SoundFile(sketch, "highScore.mp3");
    starPick = new SoundFile(sketch, "Item2A.wav");
    lifehit = new SoundFile(sketch, "thwack-08.wav");
    jump = new SoundFile(sketch, "jump.mp3");
    hit = new SoundFile(sketch, "hit.mp3");
    shoot = new SoundFile(sketch, "shoot.mp3");
    general = new SoundFile(sketch, "backgroundMusic.mp3");
  }
  
  void playGameover() {
    gameover.play();
  }
  
  void playHighscore() {
    highScore.play();
  }
  
  void playStarPick() {
    starPick.amp(0.1);
    starPick.play();
  }
  
  void playLifeHit() {
    lifehit.play();
  }
  
  void playJump() {
    jump.play();
  }
  
  void playHit() {
    hit.amp(0.2);
    hit.play();
  }
  
  void playShoot() {
    shoot.play();
  }
  
  void playGeneralMusic(Boolean muteMusic, Boolean gamePaused){
    if (!general.isPlaying() && !muteMusic && !gamePaused) {
      general.amp(0.05);
      general.play();
      general.loop();
    }
    else if (general.isPlaying() && muteMusic) {
      general.stop();
    }
  }
  
  // player has hit the pause button
  void pause(Boolean paused, float mx, float my, float x, float y, float size) {
    if (dist(mx, my, x, y) < size) {
      if (paused) {
        if (general.isPlaying()){general.pause();}
        if (gameover.isPlaying()){gameover.pause();}
        if (highScore.isPlaying()){highScore.pause();}
        if (starPick.isPlaying()){starPick.pause();}
        if (lifehit.isPlaying()){lifehit.pause();}
        if (jump.isPlaying()){jump.pause();}
        if (hit.isPlaying()){hit.pause();}
        if (shoot.isPlaying()){shoot.pause();}
      } else {
        if (general.isPlaying()){
          general.amp(0.05);
          general.play();
          general.loop();
        }
        if (gameover.isPlaying()){gameover.play();}
        if (highScore.isPlaying()){highScore.play();}
        if (starPick.isPlaying()){
          starPick.amp(0.1);
          starPick.play();
        }
        if (lifehit.isPlaying()){lifehit.play();}
        if (jump.isPlaying()){jump.play();}
        if (hit.isPlaying()){
          hit.amp(0.2);
          hit.play();
        }
        if (shoot.isPlaying()){shoot.play();}
      }
    }
  }
}
