class Controller {
  
  private Model model;
  private View view;
  private Serial port;
  private boolean textBoxState;
  private boolean firstContact;
  private int timer;
  
  Controller(Serial port) {
    this.view = new View();  
    this.model = new Model(this);
    this.port = port;
    this.textBoxState = false;
    this.firstContact = false;
    this.timer = 0;
  }
 
  public void getTemp() {
    if (this.port.available() > 0) {
      String input = this.port.readStringUntil('\n');
      if (input != null) {
        if (firstContact) {
          float temp = float(input);
          this.model.setTemp(temp);
          this.model.addToTemps(temp);
          this.model.addToSetPoints(this.model.setPoint);
          if (this.timer > 16 && this.timer % 2 == 0) {
            this.model.addToTimes(new Date());
          }
          this.timer += 1;
        } else {
          firstContact = true;
        }
      }
    }
  }
  
  public boolean getTextBoxState() {
    return this.textBoxState;
  }

  void run() {
    this.view.initBackground();
    this.getTemp();
    this.model.update();
  }
  
  public void registerTemp(float temp) {
    this.view.registerTemp(Float.toString(temp));
  }
  
  public void registerSetPoint(float setPoint) {
    this.view.registerSetPoint(Float.toString(setPoint));
  }
  
  public void registerStatus(boolean status) {
    this.view.registerStatus(status);
  }
  
  public void registerTextBox(TextBox textBox) {
    this.view.registerTextBox(textBox);
  }
  
  public void registerTemps(LinkedList<Float> temps) {
    this.view.registerTemps(temps);
  }
  
  public void registerSetPoints(LinkedList<Float> setPoints) {
    this.view.registerSetPoints(setPoints);
  }
  
  public void registerTimes(LinkedList<Date> times) {
    this.view.registerTimes(times);
  }
  
  public void turnOnHeatingElement() {
    myPort.write('1');
  }
  
  public void turnOffHeatingElement() {
    myPort.write('0');
  }
  
}
