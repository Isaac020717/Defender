PVector[] corners = { // locations for corners of the player
  new PVector(0, 0), // top left [0]
  new PVector(0, 0), // top right [1]
  new PVector(0, 0), // bottom left [2]
  new PVector(0, 0) // bottom right [3]
};
Boolean[] collidingCorners = {false, false, false, false}; // corners that are colliding (top left, top right, bottom left, bottom right)
int cornerCounter = 0;

PVector[] sides = {
  new PVector(0, 0), // right(middle) [0]
  new PVector(0, 0) // left(middle) [1]
};


Terrain collisionPiece;
int collidingCorner = 0; // only used if only 1 corner is colliding
boolean collision = false;
boolean clearCollision = false;


void charCheck(float x, float y, boolean playerCheck, int enemyNum, boolean enemySpecific) {
  
  // setting corners
  if (playerCheck || enemySpecific) { // it's a player
    corners[0].set( (x - (startXS*player.s/2)), (y - (startYS*player.s/2)) );
    corners[1].set( (x + (startXS*player.s/2)), (y - (startYS*player.s/2)) );
    corners[2].set( (x - (startXS*player.s/2)), (y + (startYS*player.s/2)) );
    corners[3].set( (x + (startXS*player.s/2)), (y + (startYS*player.s/2)) );
  } else { // it's an enemy
    corners[0].set( (x - (enemies[enemyNum].s/2)), (y - (enemies[enemyNum].s/2)) );
    corners[1].set( (x + (enemies[enemyNum].s/2)), (y - (enemies[enemyNum].s/2)) );
    corners[2].set( (x - (enemies[enemyNum].s/2)), (y + (enemies[enemyNum].s/2)) );
    corners[3].set( (x + (enemies[enemyNum].s/2)), (y + (enemies[enemyNum].s/2)) );
  }
  // setting sides
  sides[0].set(corners[1].x, y);
  sides[1].set(corners[2].x, y);
  
  if (!enemySpecific) { // if we're checking collisions for the player
    
    // reset variables
    collidingCorners[0] = false; collidingCorners[1] = false;
    collidingCorners[2] = false; collidingCorners[3] = false;
    cornerCounter = 0;
    clearCollision = false;
    
    //set collision to false, then check for collisions
    collision = false;
    
    
    //check corner collisions
    for (Terrain i : terrainPieces) {
      for (PVector v : corners) {
        if ( v.x > (i.x - (i.xs/2)) && v.x < (i.x + (i.xs/2)) ) {
          if ( v.y > (i.y - (i.ys/2)) && v.y < (i.y + (i.ys/2)) ) {
            collisionPiece = i;
            collidingCorners[cornerCounter] = true;
            collision = true;
            collidingCorner = cornerCounter;
          }
        }
        cornerCounter++;
      }
      if (collision) { break; } // if we've found a collision then stop looping
      cornerCounter = 0;
    }
    
    //check side collisions
    for (Terrain i : terrainPieces) {
      if ( sides[0].x > (i.x - (i.xs/2)) && sides[0].x < (i.x + (i.xs/2)) ) {
        if ( sides[0].y > (i.y - (i.ys/2)) && sides[0].y < (i.y + (i.ys/2)) ) {
          // colliding with right side
          collisionPiece = i;
          collidingCorners[1] = true;
          collidingCorners[3] = true;
          collision = true;
          clearCollision = true;
        }
      }
      if ( sides[1].x > (i.x - (i.xs/2)) && sides[1].x < (i.x + (i.xs/2)) ) {
        if ( sides[1].y > (i.y - (i.ys/2)) && sides[1].y < (i.y + (i.ys/2)) ) {
          // colliding with left side
          collisionPiece = i;
          collidingCorners[0] = true;
          collidingCorners[2] = true;
          collision = true;
          clearCollision = true;
        }
      }
    }
    
    if (collidingCorners[2] && collidingCorners[3]) { // bottom corners are touching a surface
      if (playerCheck) {
        player.grounded = true;
      } else {
        enemies[enemyNum].grounded = true;
      }
      clearCollision = true;
    } else if ( (collidingCorners[0] && collidingCorners[1]) || (collidingCorners[0] && collidingCorners[2]) || (collidingCorners[1] && collidingCorners[3]) ) {
      clearCollision = true;
      if (playerCheck) {
        player.grounded = false;
      } else {
        enemies[enemyNum].grounded = false;
      }
      if (collidingCorners[0] && collidingCorners[1] && playerCheck) {
        player.headHit = true;
      }
    }
  
  } else { // this is an enemy specific call --> checking to see if enemy collided with the player
    
    collision = false;
    
    for (PVector v : corners) {
      if ( v.x > (enemies[enemyNum].x - (enemies[enemyNum].s/2)) && v.x < (enemies[enemyNum].x + (enemies[enemyNum].s/2)) ) {
        if ( v.y > (enemies[enemyNum].y - (enemies[enemyNum].s/2)) && v.y < (enemies[enemyNum].y + (enemies[enemyNum].s/2)) ) {
          collision = true;
        }
      }
    }
    
  }
  
}


boolean squareCheck(PVector c1, PVector c2, PVector c3, PVector c4, PVector c5, PVector c6, PVector c7, PVector c8) {
  
  // this function checks to see if 2 squares/rectangles are colliding or not
  
  boolean localCollision = false;
  
  PVector[] o1 = {c1, c2, c3, c4};
  PVector[] o2 = {c5, c6, c7, c8};
  
  for (PVector v : o1) {
    if ( v.x > (o2[0].x) && v.x < (o2[1].x) ) {
      if ( v.y > (o2[0].y) && v.y < (o2[2].y) ) {
        localCollision = true;
      }
    }
  }
  
  return localCollision;
  
}