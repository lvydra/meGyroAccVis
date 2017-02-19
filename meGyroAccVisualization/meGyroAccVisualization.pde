import processing.serial.*;

Serial port;
String stream;
int[][] intValues;
int minValue = -35000;
int maxValue = 35000;
int scale = 100;
int dif;
float ratio;

void setup() {
  size (640, 360);
  stroke(10);
  
  //String portName = Serial.list()[1];
  
  String portName = "COM5"; //change the 0 to a 1 or 2 etc. to match your port
  port = new Serial(this, portName, 115200);
  
  intValues = new int[10][3];
  dif = maxValue - minValue;
  ratio = scale / dif;
}

void draw() {
  background(255);
  
  if ( port.available() > 0) {
    stream = port.readStringUntil('\n');
    
    if (stream != null) {
      intValues = updateData(stream);
      drawData(intValues);  
    }
  } 
}

int[][] updateData(String stream) {
  println(stream);
  String[] values = stream.split(","); 
  println(values);
  int[][] iValues = intValues;//new int[10][values.length];
    
  for (int i = 8; i >= 0; i--) {
    for (int j = 0; j < values.length; j++) {
      iValues[i+1][j] = iValues[i][j];
    }  
  }
    
  for (int k = 0; k < values.length; k++) {
    iValues[0][k] = int(values[k]);
  }  
  
  for (int i = 0; i < iValues.length; i++) {
    println(iValues[i]);
  }
  
  return iValues;
}

void drawData (int[][] iValues) {
  
  for (int i = 0; i < iValues.length-1; i++) {
    for (int j = 0; j < iValues[0].length; j++) {
      float x1 = (j+1)*scale+(iValues[i][j]/100);     
      float y1 = i*scale;
      float x2 = (j+1)*scale+(iValues[i+1][j]/100);
      float y2 = (i+1)*scale;
      
      println("i: " + i + " j: " + j);
      println("x1: " + x1 + " y1: " + y1 + " x2: " + x2 + " y2: " + y2);
      line(x1,y1,x2,y2);
    }  
  }
}
