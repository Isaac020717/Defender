// DEFINE THE ENEMY TYPES AND HOW MANY OF EACH TO INSTANTIATE
String[] enemyTypes = {"turtle"};
int[] enemyAmounts = {20};

// MAKE AN ARRAY FOR ALL OF THE ENEMIES
int enemiesNum = 0; // number of enemies to instantiate
Enemy[] enemies; // enemies array
int enemiesLeft = 0; // enemies left in each round
int enemiesEliminated = 0; // reset this each round
int enemiesOnScreen = 0; // reset this each round
int lastEnemyDeployed = millis(); // time that the last enemy was deployed at
int timeBetweenDeploying1 = 1500; int timeBetweenDeploying2 = 400; // time between deploying each enemy, we switch between these to add variety
int cTimeBetweenDeploying = timeBetweenDeploying1;

// ENEMY VARIABLES - to be toggled
float enemySize = 95;
float enemyGrav = 20; float enemyGravIncr = 0.4;

// TURTLE VARIABLES
float turtleSpeed = 4;
float turtleHealth = 10;
int turtleMultiplier = 2;
int turtlesOnScreen = 0; // reset this each round
int turtlesDeployedNum = 0; // how many have been deployed
boolean turtlesDeployed = false; // reset this each round

// ENEMY SPRITES
PImage turtleStand1, turtleStand2;
PImage turtleRightStep, turtleRightMidStep;
PImage turtleLeftStep, turtleLeftMidStep;

void instantiateEnemies() {
  
  turtleStand1 = loadImage("turtleStand1.png");
  turtleStand2 = loadImage("turtleStand2.png");
  turtleRightStep = loadImage("turtleRightStep.png");
  turtleRightMidStep = loadImage("turtleRightMidStep.png");
  turtleLeftStep = loadImage("turtleLeftStep.png");
  turtleLeftMidStep = loadImage("turtleLeftMidStep.png");
  
  // GET NUMBER OF ENEMIES AND DEFINE ARRAY
  for (int i = 0; i<enemyAmounts.length; i++) { enemiesNum = enemiesNum + enemyAmounts[i]; }
  enemies = new Enemy[enemiesNum];
  
  // INSTANTIATE ALL ENEMIES
  int enemyCounter = 0;
  for (int i = 0; i<enemyTypes.length; i++) {
    for (int a = 0; a<enemyAmounts[i]; a++) {
      enemies[enemyCounter] = new Enemy(enemyTypes[i], width/2, 0 - enemySize, enemySize, enemyCounter);
      enemyCounter++;
    }
  }
  
}

boolean sideSwap = true;
void deployEnemies() {
  
  enemiesLeft = (turtleMultiplier*wave) - enemiesEliminated;
  
  if ( ( enemiesOnScreen < (3 + int(wave/4)) ) && ((millis() - lastEnemyDeployed) >= cTimeBetweenDeploying) ) {
    
    lastEnemyDeployed = millis();
    
    if (!turtlesDeployed) {
      // DEPLOYING TURTLES
      for (Enemy i : enemies) {
        if (i.type == "turtle") {
          
          if (!i.visible && !i.pathSet) {
            // add 1 to enemies on screen
            enemiesOnScreen++;
            i.display();
          }
          if (i.visible && !i.pathSet) {
            if (sideSwap) {
              i.setPath("right");
            } else {
              i.setPath("left");
            }
            turtlesOnScreen++;
            turtlesDeployedNum++;
            if (turtlesDeployedNum >= turtleMultiplier*wave) {
              turtlesDeployed = true;
            }
            sideSwap = !sideSwap;
            if (sideSwap) { cTimeBetweenDeploying = timeBetweenDeploying1; } else { cTimeBetweenDeploying = timeBetweenDeploying2; }
            if (i.visible) { break; }
          }
          
        }
      }
    }
    
  }
  
  
  // CONTINUING WALKING PROCESS FOR ALL VISIBLE, LIVING ENEMIES
  for (Enemy i : enemies) {
    if (i.visible) {
      i.walk();
    }
  }
  
  
  // check to see if it's time for the next wave
  if (enemiesLeft <= 0) {
    wave++;
    enemiesEliminated = 0; enemiesOnScreen = 0;
    turtlesOnScreen = 0; turtlesDeployed = false; turtlesDeployedNum = 0;
    for (Enemy i : enemies) {
      i.pathSet = false; i.visible = false;
      if (i.type == "turtle") {
        i.enemyHealth = turtleHealth;
      }
    }
  }
  
}


class Enemy {
  
  
  String type;
  PVector enemyMoveDirection = new PVector(0, 0);
  float enemyTempGrav = 0;
  float x, y, s, enemySpeed, enemyHealth;
  float prevY;
  int enemyNum;
  
  String walkDirection; // can be set to left or right
  String startingSide; // can also be set to left or right
  int directionMultiplier;
  boolean visible = false;
  boolean pathSet = false;
  boolean grounded = false;
  boolean directionFlipped = false;
  
  boolean enemyHit = false;
  int enemyHitTime = 200;
  int lastHitTime = millis();
  
  PVector[] enemyCorners = { // locations for corners of the enemy
    new PVector(0, 0), // top left [0]
    new PVector(0, 0), // top right [1]
    new PVector(0, 0), // bottom left [2]
    new PVector(0, 0) // bottom right [3]
  };
 
  Enemy(String tempType, float tempX, float tempY, float tempS, int tempEnemyNum) {
    
    type = tempType;
    x = tempX; y = tempY; s = tempS;
    prevY = y;
    enemyNum = tempEnemyNum;
    if (type == "turtle") {
      enemySpeed = turtleSpeed;
      enemyHealth = turtleHealth;
    }
    
  }
  
  //ENEMY FUNCTIONS BELOW
  void display() {
    visible = true;
  }
  
  void takeDamage(float damage) {
    enemyHealth = enemyHealth - damage;
    playerPoints = playerPoints + int(damage)*5;
    enemyHit = true;
    lastHitTime = millis();
    // play sound
    pop.trigger();
    if (enemyHealth <= 0) {
      // update variables
      enemiesOnScreen--;
      enemiesEliminated++;
      // reset variables
      visible = false;
      x = 0; y = 0;
      enemyTempGrav = 0;
      pathSet = false;
      grounded = false;
      directionFlipped = false;
      walkCounter = 0; enemyStep = true;
      if (type == "turtle") {
        enemyHealth = turtleHealth;
      }
    }
  }
  
  void setPath(String side) {
    
    // For setting the path for the enemy to follow.
    // Setting a path overrides any previously set paths.
    
    if (side == "right") { //coming from right side of screen - walking left
      
      startingSide = side;
      walkDirection = "left";
      x = width; //width + 200;
      y = 0;
      
    } else { // coming from left side of screen - walking right
      
      startingSide = side;
      walkDirection = "right";
      x = 0; //-200;
      y = 0;
      
    }
    
    directionFlipped = false;
    pathSet = true;
    
  }
  
  
  
  // PLAYER COLLISION CHECKING FUNCTION
  void checkPlayerCollision() {
    
    if (!tempShield) {
      enemyCorners[0].set( (x - (s/2)), (y - (s/2)) );
      enemyCorners[1].set( (x + (s/2)), (y - (s/2)) );
      enemyCorners[2].set( (x - (s/2)), (y + (s/2)) );
      enemyCorners[3].set( (x + (s/2)), (y + (s/2)) );
      
      charCheck(player.x, player.y, false, enemyNum, true);
      if (collision && lives > 1) {
        shieldTime = millis();
        tempShield = true;
        lives--;
        lifeLost.rewind(); lifeLost.play();
      } else if (collision) {
        lives = 0;
        // play game over sound
        if (!gameOverSoundPlayed) {
          gameOver.rewind();
          gameOver.play();
          gameOverSoundPlayed = true;
        }
      }
    }
    
  }
  
  
  
  // WALKING FUNCTION
  int walkCounter = 0; boolean enemyStep = true;
  void walk() {
    
    if (visible) {
      
      // figure out the step the enemy should be taking
      if (walkCounter >= 5) {
        walkCounter = 0;
        enemyStep = !enemyStep;
      } else {
        walkCounter++;
      }
      
      // display enemy image based on walk direction
      noTint(); imageMode(CENTER);
      if (walkDirection == "right") {
        
        directionMultiplier = 1;
        if (enemyStep) {
          image(turtleRightStep, x, y);
        } else {
          image(turtleRightMidStep, x, y);
        }
        
      } else { // walk direction is left
      
        directionMultiplier = -1;
        if (enemyStep) {
          image(turtleLeftStep, x, y);
        } else {
          image(turtleLeftMidStep, x, y);
        }
        
      }
      
      
      
      // move enemy
      enemyMoveDirection.set(enemySpeed*directionMultiplier, enemyMoveDirection.y);
      if (enemyHit) {
        if (walkDirection == "right") {
          enemyMoveDirection.set(enemyMoveDirection.x - 2, enemyMoveDirection.y);
          if ((millis() - lastHitTime) >= enemyHitTime) {
            enemyHit = false;
          }
        } else { // walk direction is left
          enemyMoveDirection.set(enemyMoveDirection.x + 2, enemyMoveDirection.y);
          if ((millis() - lastHitTime) >= enemyHitTime) {
            enemyHit = false;
          }
        }
      }
      if (!grounded) {
        enemyMoveDirection.set(enemyMoveDirection.x, enemyTempGrav);
        enemyTempGrav = enemyTempGrav + enemyGravIncr;
        if (enemyTempGrav > enemyGrav) {
          enemyTempGrav = enemyGrav;
        }
      } else {
        enemyTempGrav = 0;
      }
      prevY = y;
      x = x + enemyMoveDirection.x; y = y + enemyMoveDirection.y;
      
      // check collisions
      PVector tempVec = checkCollisions(x, y, false, enemyNum);
      
      x = tempVec.x; y = tempVec.y;
      
      // see if the enemy has hit the player or not
      checkPlayerCollision();
      
      
      
      // flip direction at a certain point
      if ( startingSide == "left" && (x >= (width - s/2)) ) {
        walkDirection = "left";
        directionFlipped = true;
      } else if ( startingSide == "right" && (x <= (0 + s/2)) ) {
        walkDirection = "right";
        directionFlipped = true;
      }
      
      
      // check to see if player has finished their route
      if ( startingSide == "left" && (x < (0 - s/2)) && directionFlipped) {
        setPath(startingSide);
      } else if ( startingSide == "right" && (x > (width + s/2)) && directionFlipped) {
        setPath(startingSide);
      }
      
    }
    
  }
  
}