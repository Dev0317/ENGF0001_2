#include <math.h>


int heatingPin = 12;
boolean heatingState = LOW;
float R1 = 10000;
float logR2, R2, T;
float c1 = 1.009249522e-03, c2 = 2.378405444e-04, c3 = 2.019202697e-07;

void getTemp() {
  float Vo = analogRead(A0);
  R2 = R1 * (1023.0 / Vo - 1.0);
  logR2 = log(R2);
  T = (1.0 / (c1 + c2*logR2 + c3*logR2*logR2*logR2));
  T = T - 273.15;
  Serial.println(T);
}

void controlHeating(char heatingSwitch) {
  if (heatingSwitch == '1') {
    heatingState = HIGH;
  } else if (heatingSwitch == '0') {
    heatingState = LOW;
  }
  digitalWrite(heatingPin, heatingState);
}

void setup() {
  pinMode(heatingPin, OUTPUT); 
  Serial.begin(9600);
}

void loop() {
  getTemp();
  
  if (Serial.available() > 0) {
    char input = Serial.read();
    controlHeating(input);
  }

  delay(1000);
} 
