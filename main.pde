import java.util.Random;
import java.util.ArrayList;
import java.lang.Math;

//Setup values
int DEFX = 1080;     //Screen size
int DEFY = 1080;

int iniResX = 257;   //Resource position
int iniResY = 257;

int iniChangeFrame = 120;   // Changes resource position (symmetrically) if frameCounter % iniChangeFrame

boolean pause = false;


Aviary AV = new Aviary(500, iniResX, iniResY, iniChangeFrame);


void setup(){
   size(1080, 1080); 
   background(0);
   ellipseMode(CENTER);
 }  
 
 
void draw(){
  if(!pause){
    AV.run(DEFX, DEFY);
    fill(#007dff); 
    text("FPS:" + int(frameRate),30,30);
    text("Количество сгенерированных кадров: " + int(AV.getFrameCount()), 30, 50);
    text("Текущее расстояние от базы до ресурса: " + Math.round(getDistance()), 30, 70);
    text("Текущая частота смены позиции ресурса: " + iniChangeFrame, 30, 90);
  }
}

/*void mouseClicked(){
  AV.moveBase(0, mouseX, mouseY);
}*/

void keyPressed(){
  switch(key){
    case 'r':
    case 'R':
      AV = new Aviary(500, iniResX, iniResY, iniChangeFrame);
      break;
    case 'p':
    case 'P':
      if(pause)
        pause = false;
      else
        pause = true;
      break;
  }
}

float getDistance() {
  return sqrt((DEFX/2 - iniResX)*(DEFX/2 - iniResX) + (DEFY/2 - iniResY)*(DEFY/2 - iniResY));
}
