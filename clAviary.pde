color WALLCOLOR = #116062;                                                            //Color of aviary boundaries
int WALLTHICKNESS = 20;                                                               //Thickness of aviary boundaries (!!!KEEP MORE THAN MAXIMUM AGENT SPEED!!!)


public class Aviary {
  
  int resourceTypeAmount;                                                                      //Amount of resource types
  
  int baseAmount;                                                                       //Amount of bases
  int resourceAmount;                                                                        //Amount of resources TODO: MAKE IT AN ARRAY SIZED resourceTypeAmount TO KEEP AMOUNTS OF RESOURCES OF EACH TYPE
  
  int agentCounter;                                                                       //Agent counter
  
  color baseCl = #50c878;                                                             //Base color (single)
  color resCl = #ff7518;                                                              //Resource color TODO: MAKE IT AN ARRAY SIZED resourceTypeAmount TO KEEP COLORS OF EACH RESOURCE TYPE
  
  ArrayList<Base> bases;
  ArrayList<Resource> resourcesList;
  ArrayList<Agent> agents;
  
  int frameCounter;
  int order;

  //Constructors
  
  Aviary(int argBaseAmnt,                                                             //Amount of bases
         int argResAmnt,                                                              //Amount of resources
         int argInitAgentAmnt                                                         //Initial amount of agents
         ){
    
    resourceTypeAmount = 1;                                                                    //Single resource type by default
    frameCounter = 0;
    
    baseAmount = argBaseAmnt;
    resourceAmount = argResAmnt;
    agentCounter = argInitAgentAmnt;                                                      //Set amounts
    
    bases = new ArrayList<Base>(argBaseAmnt);
    resourcesList = new ArrayList<Resource>(argResAmnt);
    agents = new ArrayList<Agent>(argInitAgentAmnt);                                //Making ArrayLists
    
    for(int i = 0; i < baseAmount; i++){
      bases.add(new Base());
    }
    
    for(int i = 0; i < resourceAmount; i++){
      resourcesList.add(new Resource());
    }
    
    for(int i = 0; i < agentCounter; i++){
      agents.add(new Agent());
    }
  }
  
  
  Aviary(
         int argInitAgentAmnt,                                                         //Initial amount of agents
         float resX,
         float resY,
         int order
         ) {
           
    resourceTypeAmount = 1;                                                                    //Single resource type by default
    frameCounter = 0;
    
    baseAmount = 1;
    resourceAmount = 1;
    agentCounter = argInitAgentAmnt;                                                      //Set amounts
    
    bases = new ArrayList<Base>(1);
    resourcesList = new ArrayList<Resource>(1);
    agents = new ArrayList<Agent>(argInitAgentAmnt);                                //Making ArrayLists
    
    for(int i = 0; i < baseAmount; i++){
      bases.add(new Base(DEFX/2, DEFY/2 + 300));  // makes base in the center of the screen
    }
    
    for(int i = 0; i < resourceAmount; i++){
      resourcesList.add(new Resource(resX, resY));
    }
    
    for(int i = 0; i < agentCounter; i++){
      agents.add(new Agent(DEFX/2, DEFY/2 + 300, capacityGrowth, audibilityGrowth));
    }
    
    this.order = order;
  }
  
  //Getters
  
  int getFrameCount() {
    return this.frameCounter;
  }
  
  int getAgentScreamDistance() {
    return this.agents.get(0).getScrHearDist();
  }
  
  int getCapacity() {
    return this.agents.get(0).getMaxLoad();
  }
  
  //Setters
  
  //Methods
  
  void scream(Agent agent){                                                           //Performs scream of agent
  
    agents.forEach((ag) -> {                                                       //For each agent
      
      float distance = ag.getDistTo(agent.getX(), agent.getY());                     //Calculate distance to screamer
      int scrHearDist = ag.getScrHearDist();                                         //Get hearing distance
      
      if(ag.ifHearFrom(distance)){                                                   //If agent can hear
        int bsDist = agent.getBaseDist();                                             //Get screamers supposed base distance
        
        if(bsDist + scrHearDist < ag.getBaseDist()){                                 //If screamer is supposedly closer to base, !!!considering hearing distance!!!
          ag.setBaseDist(bsDist + scrHearDist);                                      //Set new supposed base distance for hearer
          ag.setBaseDir(ag.directionToFace(agent.getX(), agent.getY(), distance));  //Set new supposed base direction for hearer !!!as a direction to the screamer, not screamers supposed direction to the base!!!
          ag.peakScreamCounter();
          if(ag.getFlag() == 0) ag.updateDir();                                     //If hearer is currently seeking base                                                          //Update his current direction
        }
        
        for(int i = 0; i < resourceTypeAmount; i++){           
          int resDist = agent.getResDist(i);                            
          if(resDist + scrHearDist < ag.getResDist(i)){            
            ag.setResDist(i, resDist + ag.getScrHearDist());
            ag.setResDir(i, ag.directionToFace(agent.getX(), agent.getY(), distance));
            ag.peakScreamCounter();
            if(ag.getFlag() == i + 1)  ag.updateDir();                                                        //Do the same for all resource types
          }
        } 
      }
    });
  }
  
  void screams(){                                                                     //Perform screams if ready
    agents.forEach((agent) -> {
      if(agent.ifReadyToScream())
        scream(agent);
    });
  }
  
  void run(int defX, int defY){                                                       //Main method
    render(defX, defY);                                                               //Render boundaries, bases and resources
    tick();                                                                           //Perform animation tick
    renderAgent();                                                                    //Render agants
  }
    
  
  void tick() {                                                                        //Performes animation tick
    agents.forEach((agent) -> {                                                       //For each agent
      color curCl = agent.step();                                                       //Perform step, get color from new location
      if(curCl == baseCl){                                                            //If found base
        agent.setFlag(1);                                                               //Set action flag to seek resource
        agent.setBaseDist(0);                                                           //!!!Set supposed distance to base to 0!!!
        agent.updateDir();                                                              //!!!Update direction accordingly to new action flag!!!
        agent.peakScreamCounter();                                                    //Get ready to scream
        bases.get(0).addRes(0, agent.getLoad());
        agent.dropResources();
      }
      if(curCl == resCl){                                                             //If found resource
      int at = 0;
      int idx = -1;
        for (Resource res: resourcesList){
          if(agent.getDistTo(res.getX(), res.getY()) <= res.getSize()){
            idx = at;
          }
          at++;            
        }
        agent.setFlag(0);                                                               //Set action flag to seek base
        agent.setResDist(0, 0);                                                         //!!!Set supposed distance to resource to 0!!!
        agent.updateDir();                                                              //!!!Update direction accordingly to new action flag!!!
        agent.peakScreamCounter();                                                    //Get ready to scream
        if(idx != -1){
          if (agent.getLoad() < agent.getMaxLoad()){
            agent.load = agent.getMaxLoad();
          }
        }
      }
    });    
    screams();                                                                        //Perform screams
    frameCounter++;
    
  }
  
  void moveBase(int baseId, float argX, float argY){
    bases.get(baseId).setPos(argX, argY);
  }
  
  //Renderers
  
  void renderBounds(int defX, int defY){                                              //Renders boundaries of aviary

  strokeWeight(WALLTHICKNESS);  
  stroke(WALLCOLOR);
  line(WALLTHICKNESS / 2, WALLTHICKNESS / 2, WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2);
  line(WALLTHICKNESS / 2, WALLTHICKNESS / 2, defX - WALLTHICKNESS / 2, WALLTHICKNESS / 2);
  line(defX - WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2, defX - WALLTHICKNESS / 2, WALLTHICKNESS / 2);
  line(defX - WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2, WALLTHICKNESS / 2, defY - WALLTHICKNESS / 2);
  
}

  void renderBase(){                                                                  //Renders bases
    bases.forEach((base) -> base.render());
  }
  
  void renderRes(){                                                                   //Renders resources
    resourcesList.forEach((res) -> res.render());
  }
  
  void renderAgent(){                                                                 //Renders agents
    agents.forEach((agent) -> agent.render());
  }
  
  void render(int defX, int defY){                                                    //Renders aviary
    background(0);
    renderBounds(defX, defY);
    renderBase();
    renderRes();
    fill(255);  // инструкция
    text("R - перезапуск, P - пауза", defX / 2 - 100, defY - 6);
    fill(#007dff); 
    text("Количество ресурсов на базе: " + bases.get(0).res[0], defX - 250, 90);
  }
  
}
