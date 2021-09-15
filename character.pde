Player player;


// MOVEMENT/SIZE STUFF
PVector charStartPos;
PVector prevCharPos = new PVector(0, 0);
PVector charPos = new PVector(0,0);
float startXS = 130; float startYS = 130;
PVector moveDirection = new PVector(0, 0);
float speed = 12; float jumpPower = 20; float gravity = 20;
float jumpIncrement = 0.4; float gravityIncrement = 0.4;
float tempJumpPower = jumpPower; float tempGravity = 0;

// CHARACTER SPRITES
PImage stand1, stand2;
PImage rightStep, rightMidStep;
PImage leftStep, leftMidStep;

// CHARACTER POWERS VARIABLES
String prevLookDirection = "right"; //the character shoots fireballs in this direction


//HEALTH
int lives = 1; int totalLives = 1; int livesCap = 3; int speedCap = 15;
boolean tempShield = false; int shieldTime; int duration = 2000;
//VARIABLES FOR WHEN THE PLAYER DIES
int desiredFlashes = 15; int flashes = 0; int frameFlash = 3; /*flash every 3rd frame*/ int cFrame; boolean flash = true;
//HEALTH IMAGES
PImage heart, heartBackDrop;
boolean healthImagesCreated = false;



class Player {
  
  
  
  float x, y, s;
  
  boolean right, left, jumping;
  boolean grounded = true; boolean headHit = false;
  
  boolean standType = true; int standCounter = 0;
  boolean walkType = true; int walkCounter = 0;
  
  
  
  Player(float tempX, float tempY, float tempS) {
    
    x = tempX; y = tempY; s = tempS;
    charPos.set(x, y);
    
    stand1 = loadImage("stand1.png");
    stand2 = loadImage("stand2.png");
    rightStep = loadImage("rightStep.png");
    rightMidStep = loadImage("rightMidStep.png");
    leftStep = loadImage("leftStep.png");
    leftMidStep = loadImage("leftMidStep.png");
    
  }
  
  
  // ALL PLAYER FUNCTIONS BELOW
  void standStill() {
    
    //reset variables
    walkType = true; walkCounter = 0;
    
    // display character
    if (tempShield) { tint(255, 0, 0, 150); } else { noTint(); }
    imageMode(CENTER);
    if (standType || !grounded) {
      image(stand1, x, y, startXS*s, startYS*s);
    } else {
      image(stand2, x, y, startXS*s, startYS*s);
    }
    
    // this changes the sprites to make the character animated.. sorta
    standCounter++;
    if (standCounter >= 8) {
      standCounter = 0;
      standType = !standType;
    }
    
    finalizeMovement("standStill");
    
  } // END OF STAND STILL FUNCTION
  
  void jump() {
    
    // could add animations here if I wanted
    
    finalizeMovement("jump");
    
  } // END OF JUMP FUNCTION
  
  void right() {
    
    finalizeMovement("right");
    
    if (tempShield) { tint(255, 0, 0, 150); } else { noTint(); }
    imageMode(CENTER);
    if (walkType || !grounded) {
      image(rightStep, x, y, startXS*s, startYS*s);
    } else {
      image(rightMidStep, x, y, startXS*s, startYS*s);
    }
    
    // this changes the sprites to make the character animated.. sorta
    walkCounter++;
    if (walkCounter >= 5) {
      walkCounter = 0;
      walkType = !walkType;
    }
    
  } // END OF RIGHT FUNCTION
  
  void left() {
    
    finalizeMovement("left");
    
    if (tempShield) { tint(255, 0, 0, 150); } else { noTint(); }
    imageMode(CENTER);
    if (walkType || !grounded) {
      image(leftStep, x, y, startXS*s, startYS*s);
    } else {
      image(leftMidStep, x, y, startXS*s, startYS*s);
    }
    
    // this changes the sprites to make the character animated.. sorta
    walkCounter++;
    if (walkCounter >= 5) {
      walkCounter = 0;
      walkType = !walkType;
    }
    
  } // END OF LEFT FUNCTION
  
  
  void performAction() {
    
    if (lives >= 1) {
      
      continuePower(); // finish using power if still alive
      
      if (jumping && grounded) {
        jump();
      }
      if (right && !left) {
        right();
      } else if (left && !right) {
        left();
      } else if ( (!right && !left) || (right && left) ) {
        standStill();
      }
      
    } else { // player is dead
      
      // display character
      if (flashes < desiredFlashes) {
        if (flash) {
          tint(255, 0, 0, 140);
        } else {
          noTint();
        }
        imageMode(CENTER);
        image(stand1, x, y, startXS*s, startYS*s);
        cFrame++; if (cFrame >= frameFlash) { cFrame = 0; flash = !flash; flashes++; }
      } else {
        gameOver();
      }
      
    }
    
  } // END OF PERFORM ACTION FUNCTION
  
  
  void finalizeMovement(String action) {
    
    // all movement happens here
    
    if (action == "jump" || grounded == false) {
      if (grounded) { // begin jump
                
        grounded = false;
        headHit = false;
        tempJumpPower = jumpPower;
        tempGravity = 0;
        
        moveDirection.set( moveDirection.x, (tempJumpPower*(-1)) );
        
      } else { // continue jump
        
        if (headHit) { tempJumpPower = 0; } // stop upwards momentum if head is hit
        
        tempJumpPower = tempJumpPower - jumpIncrement;
        if (tempJumpPower > 0) {
          moveDirection.set( moveDirection.x, (tempJumpPower*(-1)) );
        } else { // start applying gravity
          tempGravity = tempGravity + gravityIncrement;
          if (tempGravity > gravity) {
            tempGravity = gravity;
          }
          moveDirection.set( moveDirection.x, tempGravity );
        }
        
      }
    }
    
    // left / right
    if (action == "right") {
      moveDirection.set(speed, moveDirection.y);
    } else if (action == "left") {
      moveDirection.set(-speed, moveDirection.y);
    } else { // stop moving left and right
      moveDirection.set(0, moveDirection.y);
    }
    
    // set previous position
    prevCharPos.set(charPos);
    
    // set initial positions
    charPos.add(moveDirection);
    x = charPos.x; y = charPos.y;
    
    // check collisions and correct positioning
    charPos.set(checkCollisions(x, y, true, 0));
    x = charPos.x; y = charPos.y;
    
    // move player to other side of screen if necessary
    if (charPos.x < (0 - (s/2) - 5)) {
      charPos.set(width + s/2, charPos.y);
    } else if (charPos.x > (width + (s/2) + 5)) {
      charPos.set(0 - s/2, charPos.y);
    }
    
    
    // check to see if player is shielded
    if (tempShield) {
      int cTime = millis();
      if ( (cTime - shieldTime) >= duration) { //shield time over
        tempShield = false;
      }
    }
    
  } // END OF FINALIZE MOVEMENT
  
  
  
} // END OF PLAYER CLASS



// CONTROLS BEING CHECKED BELOW
void keyPressed() {
  
  if (key == CODED) {
    if (keyCode == RIGHT) {
      player.right = true;
      prevLookDirection = "right";
    } else if (keyCode == LEFT) {
      player.left = true;
      prevLookDirection = "left";
    }
    if (keyCode == UP && player.grounded == true) {
      player.jumping = true;
    }
  } else if (key == ' ' && player.grounded == true) {
    player.jumping = true;
  }
  
  // check for powers/abilities
  if (!(key == CODED)) {
    usePower(key, true);
  }
  
  
} // END OF KEY PRESSED FUNCTION


void keyReleased() {
  
  if (key == CODED) {
    if (keyCode == RIGHT) {
      player.right = false;
    } else if (keyCode == LEFT) {
      player.left = false;
    }
    if (keyCode == UP) {
      player.jumping = false;
    }
  } else if (key == ' ') {
    player.jumping = false;
  }
  
  // check for powers/abilities
  if (!(key == CODED)) {
    usePower(key, false);
  }
  
} // END OF KEY RELEASED FUNCTION



// FUNCTION FOR DISPLAYING IN GAME INTERFACE
void showGameInterface() {
  
  if (!healthImagesCreated) {
    heart = loadImage("heart.png");
    heartBackDrop = loadImage("heartBackDrop.png");
    healthImagesCreated = true;
  }
  
  //DISPLAY HEALTH
  noTint(); imageMode(CENTER);
  for (int i = 0; i<totalLives; i++) {
    image(heartBackDrop, 85 + (i*70), height - 30);
  }
  for (int i = 0; i<lives; i++) {
    image(heart, 85 + (i*70), height - 30);
  }
  
  displayKeyImages();
  
}
