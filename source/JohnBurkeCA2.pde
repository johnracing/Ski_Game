//  John Burke
//  BSc Information Technology Year 1
//  20079132


import javax.swing.*; // import swing classes.
PFont gameFont;  // declaring a font
PImage startScreen;  // declaring 

int speed;
// arrays for tree locations
int [] treeY = new int [11]; // ycoordinates for rows of trees in use in program
int [] tree1X = new int [11];  // xcoordinates for left fow of trees in use in program
int [] tree2X = new int [11];  //  xcoordinates for right row of trees in use in program
int [] treeYOrigional = {650,720,790,860,960,1060,1130,1200,1280,1350,1450};  //values used in program y coordinates for trees
int [] tree1XOrigional = {220,160,90,60,60,60,90,160,230,290,300};   //values used in program x coordinates for left trees
int [] tree2XOrigional = {570,500,460,400,370,400,450,530,570,610,660};   //values used in program x coordinates for right trees

int stage =1;  // stage restricts program to parts
int skiX = 365;  // x coord for skier
int skiY = 400;  // y coord of skier
int directionX = 0;  // set direction movement of skier
int directionY = 0;  // set direction movement of skier
int currentTime = millis()+1000;  // timer
int sec, min;  // monitor time in game
String message;  // used in JOption
String title;  //   used in JOption

void setup()
{
  gameFont = loadFont("Bauhaus93-48.vlw");
  textFont(gameFont);
  background(255);
  size(730,800);
  smooth();
  frameRate(100);
  for (int i =0; i<treeYOrigional.length ; i++)  // set values for game
      {
      treeY[i] = treeYOrigional[i];
      tree1X[i] = tree1XOrigional[i];
      tree2X[i] = tree2XOrigional[i];
      }
}


void draw() 
{
  if (stage ==1)  // on startup
  {
    welcome();
  }
  else if (stage ==2)  // start main program
  {  
    background(255);
    strokeWeight(1);
    stroke(0); 
    difficulty();  // call methods
    skiDirection(); 
    createTrees(); 
    boundryCheck();
    timer();   
  }
}   // end draw method



void difficulty()  // gradually move trees towards centre
{
  if ((tree1X[1]) <250)
  {
    if ((millis()/50 % 100) == 0)
    {
      int i = 0;
      while (i<treeY.length)
      {
        tree1X[i] ++ ;
        tree2X[i] -- ; 
        i++;
  //      println(tree1X[1]);  // added to check values
      }
     
    }
  }
}


void timer()
{
 if(millis()>=currentTime)
 {
   currentTime = millis()+1000;
   sec ++;
   if (sec == 60)
   {
     sec=0;
     min ++;    
   }
 }
 fill(#db150a);
 textAlign(CENTER);
 if (min >0)
 {
   text(min +":mins  " +sec+ ":secs",width/2,50);
 }
 else
 {
   text(sec+ ":secs",width/2+80,50);
 } 
}


int chooseLevel()  // method to select difficulty by speed, called and returned value inside welcome method 
{
 message = "Select difficulty level\n\n" + "1: Easy\n" + "2: Medium\n" + "3: Difficult\n" + "4: Extreme\n";
 int level=  Integer.parseInt(JOptionPane.showInputDialog(null, message,"2"));
 return level; 
}

 
void welcome()  // text on welcome screen
{
  background(255);
  smooth();
  startScreen = loadImage("ski.jpg");
  image(startScreen,0,0,width,height);
  fill(0);
  textSize(40);
  textAlign(CENTER);
  text("Welcome to Downhill Skiing", width/2, 50);
  text("Press any key to continue....", width/2, 770);
  textSize(32);
  text("Use Arrow keys to move and \n'ctrl' to stop moving.", width/2, 650);
  if (keyPressed)
  {
     stage=2;
     speed = chooseLevel();  // returning value from method to set value for variable speed
  }
}
 
 
void skiDirection()  // show different ski method display depending on direction travelling
{
  if (directionX == 1)
  {
    skiRight();
  }
  else if (directionX == -1)
  {
    skiLeft();
  }
  else
  {
    skiStraight();  // displayed if traveling in vertical direction as x=0
  }
}  


void boundryCheck() // check boundaries, stop at boundries
{
  if  (skiX<14)
  {   
    directionX=1;
  }
   if  (skiX>width-14)
  {   
    directionX=-1; 
  }
  if (skiY>height-42)
  {   
    directionY=-1;
  } 
  if (skiY<42)
  {   
    directionY=1;
  } 
} // end stop at boundries


void createTrees()  //  create method for lines of trees
{
  for(int i=0;i<treeY.length;i++)
  {
    if(treeY[i] > -60)
    {
       tree(tree1X[i],treeY[i]);
       tree(tree2X[i],treeY[i]);
       treeY[i] = treeY[i]-speed; 
       
       collision( tree1X[i], tree2X[i], treeY[i]);  // call method to check for collision with trees
     }
     else
     {
       treeY[i] = 800;   // add to each value of tree to place at bottom of screen again
     }
   }
}


// method for checking collision between trees and skier
void collision( int tree1XIn, int tree2XIn, int treeYIn)
{
  int distLeft = int(sqrt(sq(skiX-tree1XIn)+sq(skiY-treeYIn)));
  int distRight = int(sqrt(sq(skiX-tree2XIn)+sq(skiY-treeYIn)));
  if ( distLeft < 50 || distRight < 50)
  {
    crash();  // call crash method
  }
}


void crash()  // checks about replay and sets tree y-values to start close to bottom of screen
{
  if (min>0)
 {
   message = "Congratulations !!!! \n You stayed on your skees for " +min+ " mins and " +sec+ " seconds";
 }
 else
 {
    message = "Congratulations !!!! \n You stayed on your skees for " +sec+ " seconds"; 
 }  
  title = "Ski Resort";
  JOptionPane.showMessageDialog(null, message , title, JOptionPane.PLAIN_MESSAGE); 
  message = "Would you like to play again? ";
  title = "Continue with game";
  int reply = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
  if ( reply == JOptionPane.NO_OPTION)
  {
    System.exit(0);
  }
    if ( reply == JOptionPane.YES_OPTION)  // reset game values
    {
    for (int i =0; i<treeYOrigional.length ; i++)  // reset tree locations
      {
      treeY[i] = treeYOrigional[i];
      tree1X[i] = tree1XOrigional[i];
      tree2X[i] = tree2XOrigional[i];
      }
  // reset game variables
      min=0;
      sec=0;
      skiX = 365;
      skiY = 400;
      directionX = 0; 
      directionY = 0;
    }
}


void keyPressed()  // controls for the ski
{
  if (key == CODED)
  {
    if (keyCode == LEFT)
    {
      directionX=-1;
      directionY=0;
    }
    else if (keyCode == RIGHT)
    {
      directionX=1;
      directionY=0;
    }
    else if (keyCode == UP)
    {
      directionY=-1;
      directionX=0;
    }
    else if (keyCode == DOWN)
    {
      directionY=1;
      directionX=0;
    }
    else if (keyCode == CONTROL)
    {
      directionY=0;
      directionX=0;
    }
  }
}


void skiStraight()  //  ski straight character.
{
  skiX = skiX+(directionX*speed);
  skiY = skiY+(directionY*speed);  
  fill(0);
  ellipse(skiX, skiY, 13,13);    // head
  stroke(0);
  strokeWeight(4);
  line(skiX, skiY+7, skiX, skiY+18);    //  body
  line(skiX-3, skiY+18, skiX-3, skiY+29);  // leg
  line(skiX+3, skiY+18, skiX+3, skiY+29);  // leg
  line(skiX-11, skiY+9, skiX-7, skiY+13);  // forearm
  line(skiX+11, skiY+9, skiX+7, skiY+13); // forearm 
  strokeWeight(2);
  line(skiX-6, skiY+9,skiX+6, skiY+9);    // arms
  stroke(#CB2727);
  line(skiX-10, skiY+16, skiX-2, skiY+35);  // skees
  line(skiX+10, skiY+16, skiX+2, skiY+35);  // skees  
  line(skiX-11, skiY, skiX-7, skiY+13);  // poles
  line(skiX+11, skiY, skiX+7, skiY+13);  //poles 
  noStroke();
  fill(255);
  ellipse(skiX-3, skiY, 3,3);  // eyes
  ellipse(skiX+3, skiY, 3,3);  //eyes
}


void skiLeft()  //  ski left character.
{
  skiX = skiX+(directionX*speed);
  skiY = skiY+(directionY*speed);  
  fill(0);
  ellipse(skiX-5, skiY, 13,13);    // head
  stroke(0);
  strokeWeight(4);
  line(skiX-1, skiY+7, skiX+8, skiY+12);    //  body
  line(skiX+8, skiY+12, skiX+2, skiY+21);  // leg
  line(skiX+2, skiY+21, skiX+8, skiY+25);  // leg
  line(skiX+8, skiY+25, skiX+3, skiY+28);  // leg
  line(skiX-1, skiY+7, skiX+5, skiY+9);  // forearm
  line(skiX+5, skiY+9, skiX, skiY+15); // forearm
  strokeWeight(2);
  stroke(#CB2727);  // give a red colour
  line(skiX, skiY+16, skiX+12, skiY);  // poles
  line(skiX, skiY+16, skiX+14, skiY);  // poles
  line(skiX-4, skiY+32, skiX-7, skiY+29);  // ski front
  line(skiX-4, skiY+32, skiX+16, skiY+22);  //ski back
  noStroke();
  fill(255);
  ellipse(skiX-7, skiY+1, 3,3);  //eyes
}


void skiRight()  //  ski right character.
{
  skiX = skiX+(directionX*speed);
  skiY = skiY+(directionY*speed);  
  fill(0);
  ellipse(skiX+5, skiY, 13,13);    // head
  stroke(0);
  strokeWeight(4);
  line(skiX+1, skiY+7, skiX-8, skiY+12);    //  body
  line(skiX-8, skiY+12, skiX-2, skiY+21);  // leg
  line(skiX-2, skiY+21, skiX-8, skiY+25);  // leg
  line(skiX-8, skiY+25, skiX-3, skiY+28);  // leg
  line(skiX+1, skiY+7, skiX-5, skiY+9);  // forearm
  line(skiX-5, skiY+9, skiX, skiY+15); // forearm
  strokeWeight(2);
  stroke(#CB2727);  // give a red colour
  line(skiX, skiY+16, skiX-12, skiY);  // poles
  line(skiX, skiY+16, skiX-14, skiY);  // poles
  line(skiX+4, skiY+32, skiX+7, skiY+29);  // ski front
  line(skiX+4, skiY+32, skiX-16, skiY+22);  //ski back
  noStroke();
  fill(255);
  ellipse(skiX+7, skiY+1, 3,3);  //eyes
}


//  create a tree
void tree(int treeX,int treeY)  //  tree design
{
  noStroke();
  fill(#1DCE27);
  beginShape();  // overall measurements 80 wide, 80 high
  vertex(treeX, -40+treeY);
  vertex(20+treeX, -15+treeY);
  vertex(10+treeX, -15+treeY);
  vertex(30+treeX, 5+treeY);
  vertex(20+treeX, 5+treeY);
  vertex(40+treeX, 25+treeY);
  vertex(-40+treeX, 25+treeY);
  vertex(-20+treeX, 5+treeY);
  vertex(-30+treeX, 5+treeY);
  vertex(-10+treeX, -15+treeY);
  vertex(-20+treeX, -15+treeY);
  endShape(CLOSE);
  fill(#6A4804);
  rect(-5+treeX, 25+treeY,10,15);
}