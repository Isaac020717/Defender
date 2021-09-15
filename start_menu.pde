MenuButton playButton; MenuButton optionsButton;
float buttonSizeX = 325; float buttonSizeY = 80; int normText = 64;
float hoverSizeX = 350; float hoverSizeY = 90; int hoverText = 70;

boolean gameRunning = false; //boolean variable for if the game is going
boolean firstDisplay = true; // boolean for if this is the first time the menu is displayed

color menuBGC = color(255, 255, 255, 150);

PImage shopIcon; boolean mouseOver = false;

void displayMenu() {
  
  if (firstDisplay) {
    playButton = new MenuButton(width/2, height/2 + 20, buttonSizeX, buttonSizeY, "PLAY", color(#19BF11), color(255));
    optionsButton = new MenuButton(width/2, height/2 + 125, buttonSizeX, buttonSizeY, "OPTIONS", color(#343131), color(#938A8A));
    shopIcon = loadImage("shopIcon.png");
    coinsImg = loadImage("coin.png");
    firstDisplay = false;
  }
  
  noTint();
  
  // display buttons
  playButton.displayButton();
  optionsButton.displayButton();
  
  gameRunning = false;
  
  // DRAWING THE MENU
  fill(menuBGC);
  noStroke();
  rectMode(CENTER);
  rect(width/2, height/3, width, 155);
  
  // drawing title
  imageMode(CENTER);
  image(gameTitle, width/2 - 20, height/3);
  
  // drawing shop stuff
  if (!mouseOver) {
    image(shopIcon, 75, height - 60, 100, 100);
  } else {
    image(shopIcon, 75, height - 70, 100, 100);
  }
  fill(255); textSize(52);
  text(coins, 200, height - 60);
  image(coinsImg, 280, height - 55, 60, 60);
  
}


class MenuButton {
  
  String buttonName;
  float x, y, xs, ys;
  color c; color textC;
  
  boolean hovering = false;
  
  MenuButton(float tempX, float tempY, float tempXS, float tempYS, String tempName, color tempC, color tempTC) {
    
    // setting all values
    x = tempX; y = tempY; xs = tempXS; ys = tempYS; buttonName = tempName; c = tempC; textC = tempTC;
    
  }
  
  void displayButton() {
    
    //draw rectangle
    fill(c);
    strokeWeight(4);
    stroke(textC);
    rectMode(CENTER);
    rect(x, y, xs, ys);
    
    //draw text
    fill(textC);
    textAlign(CENTER, CENTER);
    if (!hovering) {
      textSize(normText);
    } else {
      textSize(hoverText);
    }
    text(buttonName, x, y - 7);
    
  }
  
}


//  vv for clicking buttons vv
void mousePressed() {
    
  // fire functions that go with the buttons
  
  if (!shopVisible) {
    // check for play button
    if ( mouseX > ( playButton.x - (playButton.xs/2) ) && mouseX < ( playButton.x + (playButton.xs/2) ) && 
         mouseY > ( playButton.y - (playButton.ys/2) ) && mouseY < ( playButton.y + (playButton.ys/2) ) ) {
      
      gameRunning = true;
      click.rewind(); click.play();
      
    }
    
    // check for options button
    if ( mouseX > ( optionsButton.x - (optionsButton.xs/2) ) && mouseX < ( optionsButton.x + (optionsButton.xs/2) ) && 
         mouseY > ( optionsButton.y - (optionsButton.ys/2) ) && mouseY < ( optionsButton.y + (optionsButton.ys/2) ) ) {
      
      // add code later
      click.rewind(); click.play();
      
    }
  }
  
  // check for shop button
  if (!shopVisible) {
    if ( mouseX > ( 75 - (50) ) && mouseX < ( 75 + (50) ) && 
         mouseY > ( (height - 60) - (50) ) && mouseY < ( (height - 60) + (50) ) ) {
      
      displayShop();
      click.rewind(); click.play();
      
    }
  } else { // shop is visible
    shopClick();
  }
  
  // check for game over buttons
  if (lives <= 0) { checkForButtonClick(true); }
    
}

//  vv for hovering over buttons vv
void mouseMoved() {
  
  if (!gameRunning) {
    // check for play button
    if ( mouseX > ( playButton.x - (playButton.xs/2) ) && mouseX < ( playButton.x + (playButton.xs/2) ) && 
         mouseY > ( playButton.y - (playButton.ys/2) ) && mouseY < ( playButton.y + (playButton.ys/2) ) ) {
      
      playButton.xs = hoverSizeX;
      playButton.ys = hoverSizeY;
      playButton.hovering = true;
      
    } else {
      
      playButton.xs = buttonSizeX;
      playButton.ys = buttonSizeY;
      playButton.hovering = false;
      
    }
    
    // check for options button
    if ( mouseX > ( optionsButton.x - (optionsButton.xs/2) ) && mouseX < ( optionsButton.x + (optionsButton.xs/2) ) && 
         mouseY > ( optionsButton.y - (optionsButton.ys/2) ) && mouseY < ( optionsButton.y + (optionsButton.ys/2) ) ) {
      
      optionsButton.xs = hoverSizeX;
      optionsButton.ys = hoverSizeY;
      optionsButton.hovering = true;
      
    } else {
      
      optionsButton.xs = buttonSizeX;
      optionsButton.ys = buttonSizeY;
      optionsButton.hovering = false;
      
    }
    
    // check for shop button
    if (!shopVisible) {
      if ( mouseX > ( 75 - (50) ) && mouseX < ( 75 + (50) ) && 
           mouseY > ( (height - 60) - (50) ) && mouseY < ( (height - 60) + (50) ) ) {
        
        mouseOver = true;
        
      } else {
        
        mouseOver = false;
        
      }
    } else { // shop is visible
      shopMove();
    }
  }
  
  // check for game over buttons
  if (lives <= 0) { checkForButtonClick(false); }
    
}