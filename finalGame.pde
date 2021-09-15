/* :::::PLEASE READ:::::

   you need to import the minim library for the program to run
   the minim library was used so that sounds will play properly

   :::::PLEASE READ::::: */

PImage gameTitle;


void setup() {
  
  fullScreen();
  frameRate(60);
  
  //initialising images
  gameTitle = loadImage("titleImage.png");
  backgrounds[0] = loadImage("background1.png");
  backgrounds[0].resize(width,height);
  backgrounds[1] = loadImage("background2.png");
  backgrounds[1].resize(width,height);
  backgrounds[2] = loadImage("background3.png");
  backgrounds[2].resize(width,height);
  currentBG = backgrounds[0];
  
  //instantiating the player
  charStartPos = new PVector(width/2, height - 135);
  player = new Player(charStartPos.x, charStartPos.y, 1);
  
  //loading terrain for boundaries
  loadTerrain();
  //loading the ennemies
  instantiateEnemies();
  // loading sounds
  loadSounds();
  
}

void draw() {
  
  // DISPLAYING BACKGROUND IMAGE
  background(currentBG);
  
  //load the start menu
  if (!gameRunning && !shopVisible) {
    displayMenu();
  } else if (shopVisible) {
    displayShop();
  }
  
  // general game functions
  if (gameRunning) {
    displayWave();
    player.performAction();
    if (!gameOverVisible) {
      deployEnemies();
    }
    showGameInterface();
  }
  
}
