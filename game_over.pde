PImage replay; PImage home;
PVector replayPos; PVector homePos; PVector pointsPos;
float gameOverS = 100; float gameOverHoverS = 130;
boolean replayHover = false; boolean homeHover = false;
boolean gameOverImgsCreated = false;

boolean gameOverVisible = false;
boolean displayGameOver = true;

int playerPoints = 0;
int best = 0;

int coins = 15; boolean coinsPayed = false;
PImage coinsImg;


// GAME OVER FUNCTION
void gameOver() {
  
  gameOverVisible = true;
  
  if (!gameOverImgsCreated) {
    replay = loadImage("playAgain.png");
    replayPos = new PVector(width/2 - 75, height/2 + 50);
    home = loadImage("home.png");
    homePos = new PVector(width/2 + 75, height/2 + 50);
    pointsPos = new PVector(width/2, height/2 - 90);
    gameOverImgsCreated = true;
  }
  
  if (displayGameOver) {
    
    // display background
    fill(menuBGC);
    noStroke();
    rectMode(CENTER);
    rect(width/2, height/2, width, height);
    
    // display buttons
    imageMode(CENTER);
    if (!replayHover) {
      image(replay, replayPos.x, replayPos.y, gameOverS, gameOverS);
    } else {
      image(replay, replayPos.x, replayPos.y, gameOverHoverS, gameOverHoverS);
    }
    if (!homeHover) {
      image(home, homePos.x, homePos.y, gameOverS, gameOverS);
    } else {
      image(home, homePos.x, homePos.y, gameOverHoverS, gameOverHoverS);
    }
    
    // display points
    fill(255); noStroke(); noTint();
    textSize(94); textAlign(CENTER, CENTER);
    text(playerPoints, pointsPos.x, pointsPos.y);
    // check to display 'new record' text, or high score text
    textSize(18);
    if (playerPoints > best) {
      text("NEW BEST", pointsPos.x, pointsPos.y + 60);
    } else {
      text("BEST: " + best, pointsPos.x, pointsPos.y + 60);
    }
    
    // display coins
    int coinsEarned = int(playerPoints/50);
    textSize(64); textAlign(CENTER, CENTER);
    text("+" + coinsEarned, pointsPos.x - 40, pointsPos.y + 230);
    imageMode(CENTER);
    image(coinsImg, pointsPos.x + 67, pointsPos.y + 236, 70, 70);
    
    if (!coinsPayed) {
      coins = coins + coinsEarned;
      coinsPayed = true;
    }
    
  }
  
}
// CLICKING/HOVERING FOR HOME AND REPLAY BUTTONS
void checkForButtonClick(boolean clicked) {
  if (gameOverImgsCreated) { // make sure the images have been created
    if (clicked) { // check for click
      
      // check to see if player clicks replay button
      if ( mouseX > ( replayPos.x - (gameOverS/2) ) && mouseX < ( replayPos.x + (gameOverS/2) ) && 
       mouseY > ( replayPos.y - (gameOverS/2) ) && mouseY < ( replayPos.y + (gameOverS/2) ) ) {
        
        resetAllVariables();
        click.rewind(); click.play();
        
      }
      
      // check to see if player clicks home button
      if ( mouseX > ( homePos.x - (gameOverS/2) ) && mouseX < ( homePos.x + (gameOverS/2) ) && 
       mouseY > ( homePos.y - (gameOverS/2) ) && mouseY < ( homePos.y + (gameOverS/2) ) ) {
        
        gameRunning = false;
        resetAllVariables();
        click.rewind(); click.play();
        
        
      }
      
    } else { // check for hover
      
      // check to see if player hovers over replay button
      if ( mouseX > ( replayPos.x - (gameOverS/2) ) && mouseX < ( replayPos.x + (gameOverS/2) ) && 
       mouseY > ( replayPos.y - (gameOverS/2) ) && mouseY < ( replayPos.y + (gameOverS/2) ) ) {
        
        replayHover = true;
        
      } else { replayHover = false; }
      
      // check to see if player hovers over home button
      if ( mouseX > ( homePos.x - (gameOverS/2) ) && mouseX < ( homePos.x + (gameOverS/2) ) && 
       mouseY > ( homePos.y - (gameOverS/2) ) && mouseY < ( homePos.y + (gameOverS/2) ) ) {
        
        homeHover = true;
        
      } else { homeHover = false; }
      
    }
  }
}

////////////////////////////////

void resetAllVariables() { // SELF EXPLANATORY
  
  // CHARACTER VARIABLES
  player.x = charStartPos.x; player.y = charStartPos.y;
  charPos.set(player.x, player.y);
  prevCharPos.set(charPos);
  moveDirection.set(0, 0);
  tempJumpPower = jumpPower; tempGravity = 0;
  lives = totalLives;
  tempShield = false;
  flashes = 0; cFrame = 0; flash = true;
  player.right = false; player.left = false; player.jumping = false;
  player.grounded = true; player.headHit = false;
  player.standType = true; player.walkType = true; player.standCounter = 0; player.walkCounter = 0;
  prevLookDirection = "right";
  
  // ENEMY VARIABLES
  enemiesEliminated = 0;
  enemiesOnScreen = 0;
  turtlesOnScreen = 0;
  turtlesDeployed = false;
  turtlesDeployedNum = 0;
  gameOverSoundPlayed = false;
  for (Enemy i : enemies) {
    i.enemyMoveDirection.set(0, 0);
    i.enemyTempGrav = 0;
    i.visible = false;
    i.pathSet = false;
    i.grounded = false;
    i.directionFlipped = false;
    i.walkCounter = 0; i.enemyStep = true;
    i.enemyHit = false;
    if (i.type == "turtle") {
      i.enemyHealth = turtleHealth;
    }
  }
  
  // POWER/ABILITY VARIABLES
  prevLookDirection = "right";
  if (powersLoaded) {
    // reseting fireballs
    holdingFBKey = false;
    for (FireBall i : fireBalls) {
      i.fireBallPos.set(0, 0);
      i.framesPassed = 0;
      i.visible = false;
      i.flipImg = false;
      i.imgSwitch = true;
    }
  }
  
  // WAVE VARIABLES
  wave = 1;
  
  // GAME OVER VARIABLES
  replayHover = false; homeHover = false;
  gameOverVisible = false; displayGameOver = true;
  coinsPayed = false;
  if (playerPoints > best) {
    best = playerPoints;
  }
  playerPoints = 0;
  
  // START MENU VARIABLES
    // ..nothing yet
  
  // TERRAIN VARIABLES
    // ..nothing yet
  
}