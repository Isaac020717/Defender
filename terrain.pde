Terrain[] terrainPieces = new Terrain[4];


void loadTerrain() {
  
  PVector[] terrainSpots = {
    new PVector(100, 260), // top left
    new PVector(width - 100, 260), // top right
    new PVector(width/2 - 10, height/2 + 100), // middle
    new PVector(width/2, height - 20) // bottom
  };
  PVector[] terrainSizes = {
    new PVector(width/3, 93), // top left
    new PVector(width/3, 93), // top right
    new PVector(width/2, 93), // middle
    new PVector(width*2, 88) // bottom
  };
  
  for (int i = 0; i<terrainPieces.length; i++) {
    terrainPieces[i] = new Terrain(terrainSpots[i].x, terrainSpots[i].y, terrainSizes[i].x, terrainSizes[i].y);
  }
}

void displayTerrain() {
  for (Terrain i : terrainPieces) {
    i.display();
  }
}



// COLLISION DETECTION
PVector checkCollisions(float x, float y, boolean playerCheck, int enemyNum) {
  
  boolean sideCollision = false;
  
  charCheck(x, y, playerCheck, enemyNum, false);
  
  if ( collision && (!clearCollision) ) { // if only 1 corner is colliding
    
    PVector tempCorner = new PVector(corners[collidingCorner].x, corners[collidingCorner].y);
    PVector tempForce = new PVector(0, 0);
    if (playerCheck) {
      tempForce.set(moveDirection.x, moveDirection.y);
    } else {
      tempForce.set(enemies[enemyNum].enemyMoveDirection.x, enemies[enemyNum].enemyMoveDirection.y);
    }
    tempForce.mult(-1);
    tempForce.normalize();
    
    
    while (collision) {
      tempCorner.add(tempForce);
      charCheck(tempCorner.x, tempCorner.y, playerCheck, enemyNum, false);
    }
    
    
    //check for side collision
    if ( tempCorner.y > (collisionPiece.y - collisionPiece.ys) && tempCorner.y < (collisionPiece.y + collisionPiece.ys) ) {
      sideCollision = true;
    } else if ( tempCorner.x > (collisionPiece.x - collisionPiece.xs) && tempCorner.x < (collisionPiece.x + collisionPiece.xs) ) {
      sideCollision = false;
      if (collidingCorner == 0 || collidingCorner == 1) {
        if (playerCheck) {
          player.headHit = true;
          player.grounded = false;
        } else {
          enemies[enemyNum].grounded = true;
        }
      } else {
        if (playerCheck) {
          player.headHit = false;
          player.grounded = true;
        } else {
          enemies[enemyNum].grounded = true;
        }
      }
    } else {
      sideCollision = true;
    }
    collision = true;
    
    charCheck(x, y, playerCheck, enemyNum, false);
    
  }
  
  
  if (clearCollision) {
    if ( (collidingCorners[1] && collidingCorners[3]) || // right side colliding
             (collidingCorners[0] && collidingCorners[2]) ) { // or left side colliding
      sideCollision = true;
    } else { // top or bottom colliding
      sideCollision = false;
    }
  }
  
  
  // this checks if the player is falling, if so then the player is not grounded
  if (playerCheck) {
    if (charPos.y != prevCharPos.y && !collision) {
      player.grounded = false;
    }
  } else {
    if (enemies[enemyNum].y != enemies[enemyNum].prevY && !collision) {
      enemies[enemyNum].grounded = false;
    }
  }
  
  
  while (collision) { // side collision > reverse x, pull down | not a side collision > reverse y, don't touch x
    if (sideCollision) {
      
      PVector tempForce = new PVector(0, 0);
      if (playerCheck) {
        tempForce.set(moveDirection.x, 0);
      } else {
        tempForce.set(enemies[enemyNum].enemyMoveDirection.x, 0);
      }
      PVector tempPos = new PVector(x, y);
      
      tempForce.mult(-1);
      tempForce.normalize();
      tempPos.add(tempForce);
      
      charCheck(tempPos.x, y, playerCheck, enemyNum, false);
      x = tempPos.x;
      if (playerCheck) {
        player.grounded = false;
      } else {
        enemies[enemyNum].grounded = false;
      }
      
    } else {
      
      PVector tempForce = new PVector(0, 0);
      if (playerCheck) {
        tempForce.set(0, moveDirection.y);
      } else {
        tempForce.set(0, enemies[enemyNum].enemyMoveDirection.y);
      }
      PVector tempPos = new PVector(x, y);
      
      tempForce.mult(-1);
      tempForce.normalize();
      tempPos.add(tempForce);
      
      charCheck(x, tempPos.y, playerCheck, enemyNum, false);
      y = tempPos.y;
      
    }
  }
  
  
  return (new PVector(x, y));
  
} // end of collision checking function




class Terrain {
  
  PVector[] terrainCorners = new PVector[4];
  float x, y, xs, ys;
  
  Terrain(float tempX, float tempY, float tempXS, float tempYS) {
    x = tempX; y = tempY; xs = tempXS; ys = tempYS;
    
    terrainCorners[0] = new PVector(x - (xs/2), y - (ys/2)); // top left
    terrainCorners[1] = new PVector(x + (xs/2), y - (ys/2)); // top right
    terrainCorners[2] = new PVector(x - (xs/2), y + (ys/2)); // bottom left
    terrainCorners[3] = new PVector(x + (xs/2), y + (ys/2)); // bottom right
    
  }
  
  void display() {
    fill(255);
    rectMode(CENTER);
    rect(x, y, xs, ys);
  }
  
} // end of terrain class
