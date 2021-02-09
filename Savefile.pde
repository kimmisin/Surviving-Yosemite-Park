class Savefile{
  PImage grass, dirt, background, highscoretext;
  
  int scoresSave;
  int idsSave;

  ArrayList<Integer> scoresLoad = new ArrayList<Integer>();
  ArrayList<Integer> idsLoad = new ArrayList<Integer>();

  ArrayList<Integer> placement = new ArrayList<Integer>();

  JSONArray toSave;
  JSONArray valuesToLoad;
  
  Savefile(){ 
    valuesToLoad = loadJSONArray("scores.json");
    if(idsLoad.size() == 0){
      scoresLoad.add(0);
      idsLoad.add(0);

    }
    //********************************
    for (int i = 0; i < valuesToLoad.size(); i++) {
      
      JSONObject records = valuesToLoad.getJSONObject(i); 
      //sorter for the scores
      int scores = records.getInt("scores");
      int loopLength = scoresLoad.size();
      for(int j = 0; j < loopLength; j++){
        if(scoresLoad.get(j) <= scores){
          scoresLoad.add(j, scores);
          idsLoad.add(j, records.getInt("ids"));
          break;
        }
      }
    }
    //***********************************
  }
  
  void saveScore(int scores_){
    int loopLength = scoresLoad.size();
    int ids_ = idsLoad.size();
    for(int j = 0; j < loopLength; j++){
      if(scoresLoad.get(j) <= scores_){
        scoresLoad.add(j, scores_);
        idsLoad.add(j, ids_);
        break;
      }
    }
  }
  
  void highScoreMenu(){
    grass = loadImage("g1.png");
    dirt = loadImage("g2.png");
    background = loadImage("BG.png");
    highscoretext = loadImage("highscorePic.PNG");
  
    image(background, 0, 0);
    for(int i = 0; i < 7; i++){
      image(grass, 0 + (i*128), 88);
      for(int j = 0; j< 4; j++){
        image(dirt, 0 + (i*128) , 216 + (j*128));
      }
    }
    image(highscoretext, 255, 100);
    int counter = 0;
    fill(255);
    for(int i = 0; i < scoresLoad.size(); i++){
      textSize(40);
      if(idsLoad.get(i) != 0){
        if(counter < 5){
          text( (counter +1) + ".       " + scoresLoad.get(i) + "", 130, 250 + (counter*70));
          counter++;
        }
        else{
          text( (counter +1) + ".       " + scoresLoad.get(i) + "", 430, 250 + ((counter-5)*70));
          counter++;
        }
      }
      if(counter > 9){break;}
    }
    fill(250, 200, 200);
    rectMode(CENTER);
    rect(5*width/6, height/2, 150, 60);
    fill(0, 50, 100);
    text("MENU", 5*width/6, height/2 + 10);
    
    textSize(15);
    fill(250, 120, 0);
    rectMode(CENTER);
    rect(5*width/6, 150 + height/2, 200, 40);
    fill(0, 50, 100);
    text("Press \"x\" to exit the game", 5*width/6, 150 + height/2 + 10);
  }
  
  void backToFile(){
    toSave = new JSONArray();
    int counter = 0;
    for(int i = 0; i < scoresLoad.size(); i++){
      if(idsLoad.get(i) == 0){
        continue;
      }
      JSONObject playerScores = new JSONObject();
      
      playerScores.setInt("ids", idsLoad.get(i));
      playerScores.setInt("scores", scoresLoad.get(i));
      
      toSave.setJSONObject(i, playerScores);
      counter++;
      if(counter > 9){
        break;
      }
    }
    saveJSONArray(toSave, "data/scores.json");
  }
}
