//ALL POWER VARIABLES LISTED BELOW
boolean powersLoaded = false;

// KEY IMAGES
PImage keyBG;
PImage QKey;

// FIRE BALL
int fireBallsAmount = 10;
FireBall[] fireBalls = new FireBall[fireBallsAmount];

char fireBallKey1 = 'q'; char fireBallKey2 = 'Q';
boolean holdingFBKey = false; // true if player holds down fireball key
int lastFBT = millis();
int tBetweenFBs = 300; // time between fire balls

PImage fireBall1, fireBall2;
int fireBallFrame = 5; // switch between flame sprites every 4th frame
float fireBallSpeed = 20;
float FBDamage = 5;



void usePower(char letter, boolean press) {
  
  if (!powersLoaded) { // load power images
    
    // fireballs
    fireBall1 = loadImage("fireBall1.png");
    fireBall2 = loadImage("fireBall2.png");
    
    for (int i = 0; i<fireBalls.length; i++) {
      fireBalls[i] = new FireBall(new PVector(player.x, player.y), new PVector(fireBallSpeed, 0));
    }
    
    powersLoaded = true;
    
  }
  
  
  if (letter == fireBallKey1 || letter == fireBallKey2) {
    if (press) { // player is pressing the key
      
      holdingFBKey = true;
      
      if ((millis() - lastFBT) >= tBetweenFBs) {
        
        lastFBT = millis();
        for (FireBall i : fireBalls) {
          if (!i.visible) {
            i.display(player.x, player.y);
            shoot.trigger();
            break;
          }
        }
        
      }
      
    } else { // player is releasing the key
      
      holdingFBKey = false;
      
    }
  }
  
}


void continuePower() { // FINISHES THE PROCESS OF ANY POWERS THAT ARE STILL GOING
  
  if (powersLoaded) {
    
    // FIREBALLS
    for (FireBall i : fireBalls) {
      if (i.visible) {
        i.display(player.x, player.y);
      }
    }
    
  }
  
}


PVector startKeyPos; float keySize = 60; boolean keyVarsSet = false;
void displayKeyImages() {
  
  if (powersLoaded && keyVarsSet) {
    
    imageMode(CENTER);
    
    if ( !((millis() - lastFBT) >= tBetweenFBs) ) { // fireball still reloading
      
      float timeEllapsed = (millis() - lastFBT);
      float tempS = (timeEllapsed/tBetweenFBs) * keySize;
      
      image(keyBG, startKeyPos.x, startKeyPos.y, tempS, tempS);
      
    } else { image(keyBG, startKeyPos.x, startKeyPos.y, keySize, keySize); }
    
    image(QKey, startKeyPos.x, startKeyPos.y, keySize, keySize);
    
  } else {
    
    if (!keyVarsSet) {
      
      // key images
      keyBG = loadImage("keyBackground.png");
      QKey = loadImage("QKey.png");
      
      // setting start pos for the key images
      startKeyPos = new PVector(width - 275, height - 40);
      keyVarsSet = true;
      
    }
    
    image(keyBG, startKeyPos.x, startKeyPos.y, keySize, keySize);
    image(QKey, startKeyPos.x, startKeyPos.y, keySize, keySize);
    
  }
  
}


// POWER/ABILITY CLASSES
class FireBall {
  
  PVector fireBallPos = new PVector(0, 0);
  PVector fireBallVel = new PVector(0, 0);
  // fire ball dimensions are 100 x 50
  // do collisions as 80 x 40
  
  boolean visible = false;
  boolean flipImg = false;
  
  int framesPassed = 0;
  boolean imgSwitch = true;
  
  FireBall(PVector tempBallPos, PVector tempBallVel) {
    
    fireBallPos.set(tempBallPos);
    fireBallVel.set(tempBallVel);
    
  }
  
  void display(float x, float y) {
    
    if (!visible) {
      
      visible = true;
      fireBallPos.set(x, y);
      
      if (prevLookDirection == "right" && fireBallVel.x < 0) {
        fireBallVel.mult(-1);
      } else if (prevLookDirection == "left" && fireBallVel.x > 0) {
        fireBallVel.mult(-1);
      }
      
      if (prevLookDirection == "right") { flipImg = false; } else { flipImg = true; }
      
    }
    
    fireBallPos.add(fireBallVel);
    
    // set the matrix
    pushMatrix();
    translate(fireBallPos.x, fireBallPos.y);
    if (flipImg) {
      rotate(radians(180));
    }
    
    imageMode(CENTER); noTint();
    if (imgSwitch) {
      image(fireBall1, 0, 0);
    } else {
      image(fireBall2, 0, 0);
    }
    
    // reset matrix
    popMatrix();
    
    // animate fireball
    framesPassed++;
    if (framesPassed >= fireBallFrame) {
      imgSwitch = !imgSwitch;
      framesPassed = 0;
    }
    
    // check collisions with enemies
    if (visible) {
      for (Enemy i : enemies) {
        
        boolean result = squareCheck( new PVector(fireBallPos.x - 40, fireBallPos.y - 20), new PVector(fireBallPos.x + 40, fireBallPos.y - 20),
                     new PVector(fireBallPos.x - 40, fireBallPos.y + 20), new PVector(fireBallPos.x + 40, fireBallPos.y + 20),
                     new PVector(i.x - (i.s/2), i.y - (i.s/2)), new PVector(i.x + (i.s/2), i.y - (i.s/2)),
                     new PVector(i.x - (i.s/2), i.y + (i.s/2)), new PVector(i.x + (i.s/2), i.y + (i.s/2)) );
        
        if (result) {
          visible = false;
          i.takeDamage(FBDamage);
        }
        
      }
    }
    
    // check collisions with terrain
    if (visible) {
      for (Terrain i : terrainPieces) {
        boolean result = squareCheck( new PVector(fireBallPos.x - 40, fireBallPos.y - 20), new PVector(fireBallPos.x + 40, fireBallPos.y - 20),
                     new PVector(fireBallPos.x - 40, fireBallPos.y + 20), new PVector(fireBallPos.x + 40, fireBallPos.y + 20),
                     new PVector(i.x - (i.xs/2), i.y - (i.ys/2)), new PVector(i.x + (i.xs/2), i.y - (i.ys/2)),
                     new PVector(i.x - (i.xs/2), i.y + (i.ys/2)), new PVector(i.x + (i.xs/2), i.y + (i.ys/2)) );
        
        if (result) {
          visible = false;
        }
        
      }
    }
    
    // check to see if fireball is off the screen
    if ( visible && ( (fireBallPos.x + 50) < 0 || (fireBallPos.x - 50) > width ) ) { visible = false; }
    
  } // END OF DISPLAY FUNCTION
  
} // END OF FIREBALL CLASS