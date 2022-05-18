import java.util.Random;
import java.util.ArrayList;
import java.lang.Math;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import java.io.BufferedWriter;
import java.io.FileWriter;

//Setup values
int DEFX = 900;     //Screen size
int DEFY = 900;

PrintWriter output;

float iniResX = DEFX/2;   //Resource position
float iniResY = 200f;

int agentSalary = 10;
int screamerCost = 3;
int bagpackCost = 2;

int capacityGrowth = 14;
int audibilityGrowth = 0;
int iniAgentsCount = 1000;

int TotalMoney = iniAgentsCount*agentSalary + capacityGrowth*bagpackCost + audibilityGrowth*screamerCost;    //Money spent

int ordered = 5000;   //Ordered Value of mushrooms


boolean pause = false;

Aviary AV = new Aviary(iniAgentsCount, iniResX, iniResY, ordered);
SimpleDateFormat formatter = new SimpleDateFormat("dd.MM.yyyy hh-mm-ss");
NumberFormat nformat = NumberFormat.getNumberInstance(Locale.UK);
DecimalFormat format = (DecimalFormat) nformat;

void setup(){
   size(900, 900); 
   background(0);
   ellipseMode(CENTER);
   Date now = new Date();
   String formNow = formatter.format(now);
   //output = createWriter("Report " + formNow + ".txt");
 }  
 
 
void draw(){
  if(!pause){
    AV.run(DEFX, DEFY);
    fill(#007dff); 
    text("FPS: " + int(frameRate), DEFX - 250,30);
    text("Количество сгенерированных кадров: " + int(AV.getFrameCount()), DEFX - 250, 50);
    text("Времени прошло: " + format.format(AV.getFrameCount() / 60f), DEFX - 250, 70);
    text("Текущее расстояние от базы до ресурса: " + Math.round(getDistance()), 30, 30);
    text("Количество агентов: " + iniAgentsCount, 30, 50);
    text("Прирост слышимости: " + audibilityGrowth, 30, 70);
    text("Радиус слышимости агентов: " + AV.getAgentScreamDistance(), 30, 90);
    text("Прирост грузоподъемности: " + capacityGrowth, 30, 110);
    text("Грузоподъемность: " + AV.getCapacity(), 30, 130);
    text("ЗАКАЗ: " + ordered, 30, 150);
    text("ОБЩИЕ ЗАТРАТЫ: " + TotalMoney, 30, 170);
    
    if (AV.bases.get(0).res[0] >= ordered) {  //Order complete
        pause = true;
        fill(#ff0000); 
        text("ЗАКАЗ ВЫПОЛНЕН. Затраченное время: " + format.format(AV.getFrameCount() / 60f), 30, 210);
        
        //generateReport();
        appendTextToFile("capacity.csv", capacityGrowth + "," + format.format(AV.getFrameCount() / 60f));
    }
  }
}

void keyPressed(){
  switch(key){
    case 'r':
    case 'R':
      AV = new Aviary(500, iniResX, iniResY, ordered);
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

void generateReport() {
  String report = "ОТЧЕТ ЗА " + formatter.format(new Date()) + "\n \n" +
          "ЗАКАЗ: " + ordered + "\n \n" +
          "Расстояние от базы до ресурса:   " + Math.round(getDistance()) + "\n" +
          "Количество агентов:   " + iniAgentsCount + "\n" +
          "Прирост слышимости: " + audibilityGrowth + "\n" +
          "Радиус слышимости агентов: " + AV.getAgentScreamDistance() + "\n" +
          "Прирост грузоподъемности: " + capacityGrowth + "\n" +
          "Грузоподъемность одного агента: " + AV.getCapacity() + "\n \n" +
          "------------------------------------------------------" + "\n \n" +
          "Заказа выполнен за: " + format.format(AV.getFrameCount() / 60f) + " c \n \n" +
          "Общие затраты: " + TotalMoney + "$"; //general report
          
          
  output.println(report);
  output.flush();
  output.close();
}

void appendTextToFile(String filename, String text){
  File f = new File(dataPath(filename));
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.println(text);
    out.close();
  }catch (IOException e){
      e.printStackTrace();
  }
}
