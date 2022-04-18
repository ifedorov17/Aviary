public class Resource{
  
  float x, y;                                                            //Position
  float size;
  color cl = #ff7518;                                                    //Color
  
  //Constructors
  
  Resource() {
    Random r = new Random();                                             //Randomizer
    x = DEFX/5 + (3 * DEFX / 5) * r.nextFloat();                         //
    y = DEFY/5 + (3 * DEFY / 5) * r.nextFloat();                         //Random position
    size = 40;
  }
  
  Resource (float x, float y) {
    this.x = x;
    this.y = y;
    size = 40;
  }
  
  //Getters
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  float getSize(){
    return size;
  }
  
  //Setters
  
  void setPos(float argX, float argY){
    x = argX;
    y = argY;
  }
  //Methods
  
  //Renderers
    
  void render() {                                                         //Renders resource
    noStroke();
    fill(cl);
    circle(x, y, size);
  }
  
}
