import processing.serial.*;
import cc.arduino.*;
import org.firmata.*;

Arduino arduino;
 int relayPin=12;
 int ledPin=13;
 
 JSONObject json;
  int count=-1, prev=-1, i=0,currenturl=0, maxurls=6,pause=0;
  String[]  url=new String[maxurls];
Serial myPort;

void setup() {
  frameRate(10);
  size(470, 200);
//sothi
url[0]="https://graph.facebook.com/v5.0/172204453573025?fields=fan_count&access_token=EAAEELRMuZC98BAIto6pdfKG1hZBA9HjiwyKnPPPgr4FltqjblZB0ynkuKCDyKKZAT9ngOFHwLSQBAopKjVwNOTpB9ftxdLJR1Q0BNE1MX3sNi6ydKmbe5BnajGNCVNWPteQ9k1R2cK2psb9laGkarui4xFDkBzi5kg57ZAHr0DdjgBqfOO71X";
  //s_t
  url[1]="https://graph.facebook.com/v5.0/172204453573025?fields=fan_count&access_token=EAACLaz491ZC0BANjO6elcamzZC0RetZAaNHENYNsWboS7AMY7N4nmLMzr4ZA9l0OUcLE8ffwkj0aGWZBZB9v66rBFg3viXSY6b8sfAyqMbl54Vqh8iuRi0cE3aUdDUKTfLbh87NKwyL0Fu1lVvDsbEKNblwmWUJAHTB1i3VsLfZCnQGhuicJ5gg";
  //in_eg
  url[2]="https://graph.facebook.com/v5.0/172204453573025?fields=fan_count&access_token=EAAGicPyceB0BAEeSPtdAPQKEUGPkiJN7ifsXONtJ0A5TwhM20R183YP7EZBvjWBkUup2stTOnUSS9KrreGMPdSYQllKmFiaLoQoBeOGfOAWnbH1BrebbZAjGj5yiWOnAbP3xkbMCnWhZA8PG2BIUE8q4vHXLZAU8upXZB4ti2FT7GhZBZCzaPMA";
  //inflated
  url[3]="https://graph.facebook.com/v5.0/172204453573025?fields=fan_count&access_token=EAAGvmvDMxoIBABp7IW8tbGhvODz9ZBoQPYRZA2TBEpA6UG9zIE28oZAeIGAyZA2UZCWKO4qcO4uuA4jAOImq9tNM4btgqKgwp882tkPhoYli5KYBpLxvpBiLg3WXLWFNpAtEXC0Iafx81j1l2BSaTnYg0JbbVd8DLBX6f2bjCBZCUgq1e2HNBH";
  //ego
  url[4]="https://graph.facebook.com/v5.0/172204453573025?fields=fan_count&access_token=EAAHllm0L0lEBAI2KZB5x9svIrdL2aCQ5IkZCcw3djEHspqBWQLAmZBjZAZCdHwyDhIIHOZAfglZCZAS3ZCA13FcA4XuMUo0jmraXPZBTz40fW5z0ftnbj11wuq0bN2mgmQ8xwYZCsDzu5iWD2SAacIpsL958vbZAKjnNzlrl3o0x15XmIt5FVLHgmtLg";
 //i_e
  url[5]="https://graph.facebook.com/v5.0/172204453573025?fields=fan_count&access_token=EAAKXAr89AGgBAG9qsiAxJva0whCllrirdxx2ZBTHrAc2JEaQ18bwUKdYHbKUV1bvZAIGiIRRZBJrk2hZBDmY0j1wM4P4BQOZC3kijLjIusvaWrgtnGrsjbBclK6q0DDkVIQx9NSCCuo41bIxNf6HZAYasOANMnxzuEFFqPNwZAhzuiAIfntabeB";
 
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
    arduino.pinMode(relayPin, Arduino.OUTPUT);
    arduino.pinMode(ledPin, Arduino.OUTPUT);
    arduino.digitalWrite (ledPin, Arduino.LOW);       // turn off the led
  arduino.digitalWrite (relayPin, Arduino.LOW); 
  
 String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
 println(portName);
  myPort = new Serial(this, portName, 9600);
     json = loadJSONObject(url[currenturl]);
}

void draw() {
  //println(frameRate);
  if (pause==0){
   if (frameCount % 50 == 0) {    
      // json = loadJSONObject(url[currenturl]);
       if(currenturl<(maxurls-1))currenturl++; else currenturl=0;  
  }
  }

   prev=count;
   if(json!=null) count = json.getInt("fan_count");
  println(i+" /page fans:"+ count);
  i++;
  if (count>prev){
    arduino.digitalWrite (ledPin, Arduino.HIGH);      // turn on the led
    arduino.digitalWrite (relayPin, Arduino.HIGH);    // relay activation
    delay(4000);
    arduino.digitalWrite (ledPin, Arduino.LOW);       // turn off the led
    arduino.digitalWrite (relayPin, Arduino.LOW);     // relay deactivation
}
 if (count!=prev) myPort.write("SoThi: "+count+" fans!\n");  

}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
       arduino.digitalWrite (ledPin, Arduino.HIGH);       // turn off the led
       arduino.digitalWrite (relayPin, Arduino.HIGH); 
    } else if (keyCode == DOWN) {
        arduino.digitalWrite (ledPin, Arduino.LOW);      // turn on the led
        arduino.digitalWrite (relayPin, Arduino.LOW);
    } 
 
}else {
  if (key=='P'||key=='p'){pause=1;}
  else if(key=='S'||key=='s'){pause=0;}
}
}