import java.util.Random;
import java.util.ArrayList;
import java.lang.Math;
import java.text.DecimalFormat;

//Setup values
int DEFX = 1080;     //Screen size
int DEFY = 1080;

float iniResX = 540f;   //Resource position
float iniResY = 200f;

int agentSalary = 10;
int screamerCost = 3;
int bagpackCost = 2;

int bagpackCount = 0;
int screamerCount = 0;
int iniAgentsCount = 500;

int TotalMoney = iniAgentsCount*agentSalary + bagpackCount*bagpackCost + screamerCount*screamerCost;    //Money spent

int ordered = 1000;   //Ordered Value of mushrooms


boolean pause = false;

Aviary AV = new Aviary(iniAgentsCount, iniResX, iniResY);

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
    DecimalFormat format = new DecimalFormat("#.##");
    text("Количество сгенерированных кадров: " + int(AV.getFrameCount()), 30, 50);
    text("Времени прошло: " + format.format(AV.getFrameCount() / 60f), 30, 70);
    text("Текущее расстояние от базы до ресурса: " + Math.round(getDistance()), 30, 110);
    text("Радиус слышимости агентов: " + AV.getAgentScreamDistance(), 30, 130);
    text("ОБЩИЕ ЗАТРАТЫ: " + TotalMoney, 30, 150);
  }
}

void keyPressed(){
  switch(key){
    case 'r':
    case 'R':
      AV = new Aviary(500, iniResX, iniResY);
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
