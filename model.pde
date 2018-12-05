// Contains state of application

public class TextBox {
  
  private int x;
  private int y;
  private int w;
  private int h;
  private String txt;
  
  TextBox(int x, int y, int w, int h, String txt) {
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
    this.txt = txt;
  }
  
  public String getTxt() {
    return this.txt;
  }
  
  public int getWidth() {
    return this.w;
  }
  
  public int getHeight() {
    return this.h;
  }
  
  public int getX() {
    return this.x;
  }
  
  public int getY() {
    return this.y;
  }
  
  public void keyPress(char k, Controller controller) {
     if (k == ENTER || k == RETURN) {
       if (this.isValid(this.txt)) {
         controller.model.setSetPoint(Float.parseFloat(this.txt));
         controller.textBoxState = false;
       } else {
         controller.textBoxState = false;
       }
     } else if (k == BACKSPACE) {
       if (txt.length() > 0) {
         txt = txt.substring(0,txt.length() - 1);
       }
     } else {
       if (txt.length() < 5) {
         txt += str(k);
       }
     }
  }
  
  private boolean isValid(String s) {
    return s.matches("\\d+(\\.\\d+)?");
  }
  
}


public class Model {
  
  private Controller controller;
  private float setPoint;
  private float temp;
  private boolean isHeatingOn;
  private TextBox textBox;
  private LinkedList<Float> temps;
  private int modCount;
  private LinkedList<Float> setPoints;
  private int modCount2;
  private LinkedList<Date> times;
  
  Model(Controller controller) {
    this.controller = controller;
    this.setPoint = 25;
    this.isHeatingOn = false;
    this.temps = new LinkedList<Float>();
    this.modCount = 0;
    this.setPoints = new LinkedList<Float>();
    this.modCount2 = 0;
    this.times = new LinkedList<Date>();
    this.initialiseTimes();
  }
  
  public void initialiseTimes() {
    Calendar time = Calendar.getInstance();
    this.times.add(time.getTime());
    for (int i = 0; i < 8; i++) {
      time.add(Calendar.SECOND, 10);
      this.times.add(time.getTime());
    }
  }
  
 public void setTemp(float temp) {
   this.temp = temp;
 }
 
 public float getTemp() {
   return this.temp;
 }
 
 public void setSetPoint(float setPoint) {
   if (setPoint < 25) {
     this.setPoint = 25;
   } else if (setPoint > 35) {
     this.setPoint = 35;
   } else {
     this.setPoint = setPoint;
   }
 }
 
 public float getSetPoint() {
   return this.setPoint;
 }
 
 public boolean getHeatingStatus() {
   return this.isHeatingOn;
 }
 
 public void addToTemps(float temp) {
   if (this.modCount < 800) {
     this.temps.add(temp);
     this.modCount += 1;
   } else {
     this.temps.remove();
     this.temps.add(temp);
   }
 }
 
 public void addToSetPoints(float setPoint) {
   if (this.modCount2 < 800) {
     this.setPoints.add(setPoint);
     this.modCount2 += 1;
   } else {
     this.setPoints.remove();
     this.setPoints.add(setPoint);
   }
 }
 
 public void addToTimes(Date time) {
   this.times.remove();
   this.times.add(time);
 }
 
 public void checkTemp() {
   if (this.temp < this.setPoint && this.isHeatingOn == false) {
     this.controller.turnOnHeatingElement();
     this.isHeatingOn = true;
   } else if (this.temp > this.setPoint && this.isHeatingOn == true) {
     this.controller.turnOffHeatingElement();
     this.isHeatingOn = false;
   }
 }
 
 public void createTextBox() {
   this.textBox = new TextBox(530, 260, 155, 50, Float.toString(this.setPoint));
 }
 
 public void update() {
   this.checkTemp();
   this.controller.registerTemp(this.temp);
   this.controller.registerStatus(this.isHeatingOn);
   this.controller.registerTemps(this.temps);
   this.controller.registerSetPoints(this.setPoints);
   this.controller.registerTimes(this.times);
   
   if (this.controller.getTextBoxState()) {
     this.controller.registerTextBox(this.textBox);
   } else {
     this.controller.registerSetPoint(this.setPoint);
   }
 }
  
}
