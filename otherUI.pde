PImage currentBG; // current background
PImage[] backgrounds = new PImage[3];

// declare sound variables
import ddf.minim.*;
Minim minim;
AudioSample shoot, pop;
AudioPlayer themeMusic, lifeLost, gameOver, click, upgrade, failure;
boolean gameOverSoundPlayed = false;
void loadSounds() {
  
  minim = new Minim(this);
  
  themeMusic = minim.loadFile("themeMusic.wav");
  shoot = minim.loadSample("newShoot.wav", 512);
  pop = minim.loadSample("pop.wav", 512);
  click = minim.loadFile("click.mp3", 512);
  upgrade = minim.loadFile("upgrade.wav", 512);
  failure = minim.loadFile("failure.wav", 512);
  lifeLost = minim.loadFile("lifeLost.wav", 512);
  gameOver = minim.loadFile("gameOver.wav", 512);
  // more sounds here
  
  // play theme music
  themeMusic.loop();
  
}

int wave = 1;
color waveText = color(255);


// WAVE FUNCTION
void displayWave() {
  stroke(waveText);
  fill(waveText);
  textAlign(CENTER, CENTER);
  textSize(64);
  text("wave " + wave, width/2, 50);
}



// SHOP STUFF
boolean shopVisible = false; boolean firstShopDisplay = true;
PImage switcher, switch1, switch2; float extraH = 5;
int selection = 1; int hover = 0;
String shopMode = "upgrades"; // the alternative is backgrounds

PVector switchPos;

// upgrades variables
PImage plus, back;
PVector healthPlusPos, speedPlusPos, backPos;
float plusSize = 75; float plusHoverS = 100;
float backS = 100; float backHoverS = 120;
boolean healthHover = false; boolean speedHover = false; boolean backHover = false;

// background variables
PImage nextBG, prevBG;
PVector nextArrowPos, prevArrowPos;
float arrowS = 100; float arrowHoverS = 120;
boolean nextArrowHover = false; boolean prevArrowHover = false;

void displayShop() {
    
  shopVisible = true;
  
  if (firstShopDisplay) {
    
    // upgrade variables
    switcher = loadImage("shopSwitcher.png");
    switch1 = loadImage("shopSwitch1.png");
    switch2 = loadImage("shopSwitch2.png");
    back = loadImage("backButton.png");
    backPos = new PVector(100, 100);
    switchPos = new PVector(width/2, height - 100);
    plus = loadImage("plus.png");
    healthPlusPos = new PVector(width/2 + 150, 275);
    speedPlusPos = new PVector(width/2 + 150, 400);
    
    // background variables
    nextBG = loadImage("rightArrow.png");
    prevBG = loadImage("leftArrow.png");
    nextArrowPos = new PVector(width - 100, height/2);
    prevArrowPos = new PVector(100, height/2);
    
    firstShopDisplay = false;
  }
  
  
  if (shopMode == "upgrades") {
    rectMode(CENTER); fill(255, 125);
    rect(width/2, height/2, width, height);
  }
  
  
  // get selector up
  imageMode(CENTER); noTint();
  image(switcher, switchPos.x, switchPos.y);
  if (selection == 1) {
    tint(60, 80, 247);
    image(switch1, switchPos.x, switchPos.y - extraH);
    tint(255, 255, 255, 200);
    if (hover == 2) { // mouse hovering over switch2
      image(switch2, switchPos.x, switchPos.y - extraH);
    } else { // not hovering over switch2
      image(switch2, switchPos.x, switchPos.y);
    }
  } else { // selection is 2
    tint(60, 80, 247);
    image(switch2, switchPos.x, switchPos.y - extraH);
    tint(255, 255, 255, 200);
    if (hover == 1) { // mouse hovering over switch1
      image(switch1, switchPos.x, switchPos.y - extraH);
    } else { // not hovering over switch1
      image(switch1, switchPos.x, switchPos.y);
    }
  }
  
  noTint();
  
  // back button
  if (backHover) {
    image(back, backPos.x, backPos.y, backHoverS, backHoverS);
  } else {
    image(back, backPos.x, backPos.y, backS, backS);
  }
  
  // display how many coins the player has
  fill(255); textSize(52); textAlign(CENTER, CENTER);
  text(coins, 200, height - 60);
  image(coinsImg, 280, height - 55, 60, 60);
  
  // get main shop up
  if (shopMode == "upgrades") {
    
    fill(255); noTint();
    
    // display title
    rectMode(CENTER);
    rect(width/2, 150, width/3, 100);
    fill(0); textSize(68); textAlign(CENTER, CENTER);
    text("UPGRADES", width/2, 145);
    
    // display body of UI
    fill(255, 200);
    rect(width/2, 375, width/3, 350);
    
    // display health upgrade
    fill(0); textSize(50); textAlign(LEFT, CENTER); imageMode(CENTER);
    text("Lives: " + totalLives, healthPlusPos.x - 370, healthPlusPos.y);
    if (totalLives >= livesCap) { tint(255, 100); } else { noTint(); }
    if (healthHover) {
      image(plus, healthPlusPos.x, healthPlusPos.y, plusHoverS, plusHoverS);
    } else {
      image(plus, healthPlusPos.x, healthPlusPos.y, plusSize, plusSize);
    }
    // display speed upgrade
    text("Speed: " + int(speed), speedPlusPos.x - 370, speedPlusPos.y);
    if (speed >= speedCap) { tint(255, 100); } else { noTint(); }
    if (speedHover) {
      image(plus, speedPlusPos.x, speedPlusPos.y, plusHoverS, plusHoverS);
    } else {
      image(plus, speedPlusPos.x, speedPlusPos.y, plusSize, plusSize);
    }
    
    // display upgrade UI
    if ( upgradeUIVisible && ((cSelectedUpgrade == "health" && totalLives < livesCap) || (cSelectedUpgrade == "speed" && speed < speedCap)) ) {
      displayUpgrade(cSelectedUpgrade);
    } else {
      upgradeUIVisible = false;
    }
    
  } else if (shopMode == "backgrounds") {
    
    // title text
    fill(#15151C); textSize(64); textAlign(CENTER, TOP);
    text("Pick A Background", width/2, 75);
    
    // back button
    if (backHover) {
      image(back, backPos.x, backPos.y, backHoverS, backHoverS);
    } else {
      image(back, backPos.x, backPos.y, backS, backS);
    }
    
    // display arrow buttons
    if (nextArrowHover) {
      image(nextBG, nextArrowPos.x, nextArrowPos.y, arrowHoverS, arrowHoverS);
    } else {
      image(nextBG, nextArrowPos.x, nextArrowPos.y, arrowS, arrowS);
    }
    if (prevArrowHover) {
      image(prevBG, prevArrowPos.x, prevArrowPos.y, arrowHoverS, arrowHoverS);
    } else {
      image(prevBG, prevArrowPos.x, prevArrowPos.y, arrowS, arrowS);
    }
    
  }
    
}


// for showing the upgrade UI
boolean upgradeUIVisible = false; String cSelectedUpgrade;
PVector upgradeFramePos, upgradeExitPos, upgradeButtonPos;
float upgradeFrameXS = 500; float upgradeFrameYS = 250; float upgradeButtonXS = upgradeFrameXS/5; float upgradeButtonYS = 50;
boolean upgradeButtonHover = false; float upgradeButtonHoverXS = upgradeFrameXS/5 + 10; float upgradeButtonHoverYS = 55;
String healthDesc = "Upgrade this item to increase the amount of times that you can be hit by an enemy.";
int healthCost = 25;
String speedDesc = "Upgrade this item to increase the natural speed of you character.";
int speedCost = 2;
boolean upgradeVarsSet = false;
void displayUpgrade(String upgradeItem) {
  
  // set vars
  if (!upgradeVarsSet) {
    upgradeFramePos = new PVector(width/2, height/2 - 50);
    upgradeButtonPos = new PVector(upgradeFramePos.x + (upgradeFrameXS/2) - (upgradeFrameXS/5/2), upgradeFramePos.y + (upgradeFrameYS/2 - 25));
    upgradeExitPos = new PVector(upgradeFramePos.x + (upgradeFrameXS/2 - 25), upgradeFramePos.y - (upgradeFrameYS/2 - 25));
    upgradeVarsSet = true;
  }
  
  // display generic UI
  rectMode(CENTER); fill(#E8E3B9);
  rect(upgradeFramePos.x, upgradeFramePos.y, upgradeFrameXS, upgradeFrameYS); // main background frame
  fill(#D3CFAD);
  rect(upgradeFramePos.x, upgradeFramePos.y + (upgradeFrameYS/2 - 25), upgradeFrameXS, 50); // grey bar for upgrade button and price
  fill(#32792C);
  if (upgradeButtonHover) {
    rect(upgradeButtonPos.x, upgradeButtonPos.y, upgradeButtonHoverXS, upgradeButtonHoverYS); // green frame for upgrade text
  } else {
    rect(upgradeButtonPos.x, upgradeButtonPos.y, upgradeButtonXS, upgradeButtonYS); // green frame for upgrade text
  }
  textAlign(CENTER, CENTER); fill(255); if (upgradeButtonHover) { textSize(24); } else { textSize(20); }
  text("UPGRADE", upgradeButtonPos.x, upgradeButtonPos.y); // upgrade text
  fill(#D6332D); textSize(44);
  text("X", upgradeExitPos.x, upgradeExitPos.y); // exit text
  image(coinsImg, upgradeFramePos.x - (upgradeFrameXS/2) + (upgradeFrameXS/5/2), upgradeFramePos.y + (upgradeFrameYS/2 - 25)); // coins image
  
  // display item specific UI
  if (upgradeItem == "health") {
    
    textAlign(CENTER, TOP); fill(#15151C); textSize(24);
    text(healthDesc, upgradeFramePos.x, upgradeFramePos.y + 50, upgradeFrameXS - 100, upgradeFrameYS - 500);
    textAlign(LEFT, CENTER); textSize(52);
    text(healthCost*totalLives, upgradeFramePos.x - (upgradeFrameXS/2) + (upgradeFrameXS/4 - 20), upgradeFramePos.y + (upgradeFrameYS/2 - 30));
    
  } else if (upgradeItem == "speed") {
    
    textAlign(CENTER, TOP); fill(#15151C); textSize(24);
    text(speedDesc, upgradeFramePos.x, upgradeFramePos.y + 50, upgradeFrameXS - 100, upgradeFrameYS - 50);
    textAlign(LEFT, CENTER); textSize(52);
    text(int(speedCost*speed), upgradeFramePos.x - (upgradeFrameXS/2) + (upgradeFrameXS/4 - 20), upgradeFramePos.y + (upgradeFrameYS/2 - 30));
    
  }
  
  cSelectedUpgrade = upgradeItem;
  upgradeUIVisible = true;
  
}


// function for all shop clicks
void shopClick() {
  
  // check for clicks on the switcher
  if (mouseX > (switchPos.x - 100) && mouseX < (switchPos.x) && mouseY > (switchPos.y - 37) && mouseY < (switchPos.y + 37)) { //clicking switch1
    selection = 1; shopMode = "upgrades";
    click.rewind(); click.play();
  } else if (mouseX < (switchPos.x + 100) && mouseX > (switchPos.x) && mouseY > (switchPos.y - 37) && mouseY < (switchPos.y + 37)) { //clicking switch2
    selection = 2; shopMode = "backgrounds";
    click.rewind(); click.play();
  }
  
  // check for clicks on the back button
  if (mouseX > (backPos.x - backS/2) && mouseX < (backPos.x + backS/2) && mouseY > (backPos.y - backS/2) && mouseY < (backPos.y + backS/2)) { //clicking back button
    shopVisible = false; upgradeUIVisible = false;
    click.rewind(); click.play();
  }
  
  if (totalLives < livesCap) {
    // check for clicks on the health plus
    if (mouseX > (healthPlusPos.x - plusSize/2) && mouseX < (healthPlusPos.x + plusSize/2) && mouseY > (healthPlusPos.y - plusSize/2) && mouseY < (healthPlusPos.y + plusSize/2)) {
      if (!upgradeUIVisible) {
        displayUpgrade("health");
        click.rewind(); click.play();
      }
    }
  }
  
  if (speed < speedCap) {
    // check for clicks on the speed plus
    if (mouseX > (speedPlusPos.x - plusSize/2) && mouseX < (speedPlusPos.x + plusSize/2) && mouseY > (speedPlusPos.y - plusSize/2) && mouseY < (speedPlusPos.y + plusSize/2)) {
      if (!upgradeUIVisible) {
        displayUpgrade("speed");
        click.rewind(); click.play();
      }
    }
  }
  
  // check for clicks on the upgrade button
  if (upgradeVarsSet) {
    if (mouseX > (upgradeButtonPos.x - upgradeButtonXS/2) && mouseX < (upgradeButtonPos.x + upgradeButtonXS/2)
        && mouseY > (upgradeButtonPos.y - upgradeButtonYS/2) && mouseY < (upgradeButtonPos.y + upgradeButtonYS/2)) {
      if (cSelectedUpgrade == "health") {
        if (coins >= healthCost*totalLives) {
          coins = int(coins - healthCost*totalLives);
          totalLives++; lives = totalLives;
          upgrade.rewind();
          upgrade.play();
        } else {
          // player doesn't have enough
          failure.rewind();
          failure.play();
        }
      } else if (cSelectedUpgrade == "speed") {
        if (coins >= speedCost*speed) {
          coins = int(coins - speedCost*speed);
          speed++;
          upgrade.rewind();
          upgrade.play();
        } else {
          // player doesn't have enough
          failure.rewind();
          failure.play();
        }
      }
    }
  }
  
  // check for clicks on the X button
  if (upgradeVarsSet && upgradeUIVisible) {
    if (mouseX > (upgradeExitPos.x - 25) && mouseX < (upgradeExitPos.x + 25)
        && mouseY > (upgradeExitPos.y - 25) && mouseY < (upgradeExitPos.y + 25)) {
       upgradeUIVisible = false;
       click.rewind(); click.play();
    }
  }
  
  // check for clicks on next arrow
  if (mouseX > (nextArrowPos.x - arrowS/2) && mouseX < (nextArrowPos.x + arrowS/2) && mouseY > (nextArrowPos.y - arrowS/2) && mouseY < (nextArrowPos.y + arrowS/2)) {
    
    int tempSelection = 0; int cBGSelection = 0;
    for (int i = 0; i<backgrounds.length; i++) {
      if (backgrounds[i] == currentBG) { cBGSelection = i; }
    }
    
    tempSelection = cBGSelection + 1;
    if (tempSelection >= backgrounds.length) {
      tempSelection = 0;
    }
    
    currentBG = backgrounds[tempSelection];
    
    click.rewind(); click.play();
    
  }
  // check for clicks on prev arrow
  if (mouseX > (prevArrowPos.x - arrowS/2) && mouseX < (prevArrowPos.x + arrowS/2) && mouseY > (prevArrowPos.y - arrowS/2) && mouseY < (prevArrowPos.y + arrowS/2)) {
    
    int tempSelection = 0; int cBGSelection = 0;
    for (int i = 0; i<backgrounds.length; i++) {
      if (backgrounds[i] == currentBG) { cBGSelection = i; }
    }
    
    tempSelection = cBGSelection - 1;
    if (tempSelection < 0) {
      tempSelection = backgrounds.length - 1;
    }
    
    currentBG = backgrounds[tempSelection];
    
    click.rewind(); click.play();
    
  }
  
}

// function for when the mouse moves -> checks for hovering over buttons
void shopMove() {
  
  // check for hovering over the switcher
  if (mouseX > (switchPos.x - 100) && mouseX < (switchPos.x) && mouseY > (switchPos.y - 37) && mouseY < (switchPos.y + 37)) { //hovering over switch1
    hover = 1;
  } else if (mouseX < (switchPos.x + 100) && mouseX > (switchPos.x) && mouseY > (switchPos.y - 37) && mouseY < (switchPos.y + 37)) { //hovering over switch2
    hover = 2;
  } else { // not hovering over either switch button
    hover = 0;
  }
  
  // check for hovering over the back button
  if (mouseX > (backPos.x - backS/2) && mouseX < (backPos.x + backS/2) && mouseY > (backPos.y - backS/2) && mouseY < (backPos.y + backS/2)) { //hovering over back button
    backHover = true;
  } else { // not hovering over back button
    backHover = false;
  }
  
  if (totalLives < livesCap) {
    // check for hovering over the health plus
    if (mouseX > (healthPlusPos.x - plusSize/2) && mouseX < (healthPlusPos.x + plusSize/2) && mouseY > (healthPlusPos.y - plusSize/2) && mouseY < (healthPlusPos.y + plusSize/2)) {
      healthHover = true;
    } else {
      healthHover = false;
    }
  }
  
  if (speed < speedCap) {
    // check for hovering over the speed plus
    if (mouseX > (speedPlusPos.x - plusSize/2) && mouseX < (speedPlusPos.x + plusSize/2) && mouseY > (speedPlusPos.y - plusSize/2) && mouseY < (speedPlusPos.y + plusSize/2)) {
      speedHover = true;
    } else {
      speedHover = false;
    }
  }
  
  // check for hovering over the upgrade button
  if (upgradeVarsSet && upgradeUIVisible) {
    if (mouseX > (upgradeButtonPos.x - upgradeButtonXS/2) && mouseX < (upgradeButtonPos.x + upgradeButtonXS/2)
        && mouseY > (upgradeButtonPos.y - upgradeButtonYS/2) && mouseY < (upgradeButtonPos.y + upgradeButtonYS/2)) {
      upgradeButtonHover = true;
    } else {
      upgradeButtonHover = false;
    }
  }
  
  // check for hovering over next arrow
  if (mouseX > (nextArrowPos.x - arrowS/2) && mouseX < (nextArrowPos.x + arrowS/2) && mouseY > (nextArrowPos.y - arrowS/2) && mouseY < (nextArrowPos.y + arrowS/2)) {
    nextArrowHover = true;
  } else {
    nextArrowHover = false;
  }
  // check for hovering over prev arrow
  if (mouseX > (prevArrowPos.x - arrowS/2) && mouseX < (prevArrowPos.x + arrowS/2) && mouseY > (prevArrowPos.y - arrowS/2) && mouseY < (prevArrowPos.y + arrowS/2)) {
    prevArrowHover = true;
  } else {
    prevArrowHover = false;
  }
  
}
