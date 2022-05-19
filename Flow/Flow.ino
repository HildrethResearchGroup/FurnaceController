#include <SoftwareSerial.h>

#define HAS_DATA "1 "
#define NO_DATA "0 "
#define rxPin 0 
#define txPin 1 // red is Tx
#define BUFFER_SIZE 1024


// Set up a new SoftwareSerial object
SoftwareSerial flowSerial =  SoftwareSerial(rxPin, txPin, true);
// data from fluid flow sensor
char flow_data[BUFFER_SIZE];
// data from mac application
char input_data[BUFFER_SIZE];

void setup()  {
    // Define pin modes for TX and RX
    pinMode(rxPin, INPUT);
    pinMode(txPin, OUTPUT);
    
    // Set the baud rate for the SoftwareSerial object
    flowSerial.begin(19200);

    // Baud rate for USB connection to computer
    Serial.begin(9600);

    // tell the alicat to begin streaming data
    flowSerial.write("@@=@\r");
    // set stream interval
    flowSerial.write("@W91=50\r");
}

void getDataFromFlowSensor(){
    // zero out memory char buffer
    memset(flow_data, '\0', sizeof(char)*BUFFER_SIZE);
    
    // poll for data
    flowSerial.listen();
    if (flowSerial.available() > 0) {
        char c;
        int i = 0;
        while ( (c = flowSerial.read()) != -1 && i < BUFFER_SIZE - 1){
          flow_data[i] = c;
          ++i;
        } 
        Serial.print(HAS_DATA);
        Serial.println(flow_data);
        // print the results to USB
    }else{
      Serial.print(NO_DATA);
      Serial.println(flow_data);
    }
}

// Fills buf with buf_size - 2 data. Last character is null terminating char
void fill_buffer_from_stream(Stream &data, char buf[], int buf_size){
    memset(buf, '\0', sizeof(char)*BUFFER_SIZE);
    if (data.available() > 0) {
        char c;
        int i = 0;
        while ( (c = data.read()) != -1 && i < BUFFER_SIZE - 1){
          buf[i] = c;
          ++i;
        } 
    }
}

void loop() {
    //getDataFromFlowSensor();
//    char in = ' ';
//    if (Serial.available() > 0){
//      in = Serial.read();
//      Serial.println(in);
//      delay(1000);
//    }
  delay(500);
  fill_buffer_from_stream(Serial, input_data, BUFFER_SIZE);
  input_data[0] = "k";
  Serial.println(input_data);
}
