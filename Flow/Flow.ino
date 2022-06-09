// Written by Colton Meyers 2022 Computer Science Field Session
// Contact 303-551-5603 if you'd like some help.
#include <SoftwareSerial.h>
#include <Adafruit_MAX31855.h>
#include <SPI.h>

// variable pre-processor declarations
// TTL Serial pins
#define rxPin 10 // recieve pin
#define txPin 11 // transmit pin

//https://www.adafruit.com/products/269
// MAX31855K
// Adafruit Thermocouple Sensor SPI pins 
#define DO 3  // output data from the thermocouple amplifier
#define CS 4  // chip select
#define CLK 5 // clock signal

#define BUFFER_SIZE 256
#define S_BUFFER_SIZE 128
#define TIMEOUT_DURATION 3000 // 3 seconds in miliseconds
#define EOT ';' // End of transmission symbol
#define BOT '$' // Beginning of transmission symbol
// The MAX31855K has very limited with error checking readError / NAN check doesn't really work so reciving a value of 0.00000  
// which is likely improbable for the lab env. is the best error checking
#define THERMOCOUPLE_UNINIT 0.0000000000
#define FLOW_SENSOR_UNKNOWN_CMD '?'

// function pre-processor declarations
// Number of elements in a statically allocated array
// Only use on an array d-type a[] not an a* which points to the first elm of the array
#define LEN(x) (sizeof(x) / sizeof((x)[0]))

enum STATE {READ_CMD = 0, WRITE_CMD = 1, WAIT_FOR_DATA = 2, WAITING = 3};
enum STATE current_state;

// Apex flow sensors are talked to over Software emulated TTL Serial
SoftwareSerial flowSerial =  SoftwareSerial(rxPin, txPin, false);

Adafruit_MAX31855 thermocouple(CLK, CS, DO);

// Serial commands need to be able to record when they first sent out a command
// Or first recived some data
// This is used to timeout from waiting from a cmd response
struct time_delta {
  long int flow_sensor_start_t; // start time of command sent to flow sensor
  long int swift_start_t;       // start time of data recived from swift application
} time_d;

// buffers for serial data in from the Swift application
struct recived_cmd {
  // A buffer to hold input data from a Swift Application
  // Data is in the form:  BOT <UID> <COMMAND> EOT
  char input_data[BUFFER_SIZE];
  // A buffer to hold data that has been split() on the space delimiter
  // Data is in the form: [BOT, <UID>, <COMMAND>, EOT]
  char* input_tokens[BUFFER_SIZE];
  int tokens_length; // length of input_tokens array (atleast the parts length of parts with data)
  int input_pos;     // current_pos in input_data buffer
  int UID;           // Unique ID of data transmission
} cmd;

bool time_waiting;
bool writing_flow_data;
bool transmission_ongoing;

const char space_delim[2] = " ";

// Writes a message to the serial Stream
void write_message(int uid, const char* msg) {
  Serial.write(BOT);
  Serial.write(" ");
  Serial.print(uid, DEC);
  Serial.write(" ");
  Serial.write(msg);
  Serial.write(" ");
  Serial.write(EOT);
}

// parses input_data and fills input_tokens and sets tokens_length
void parse_cmd() {
  char input_data_cpy[BUFFER_SIZE];
  // strtok changes the passed in array and place '\0' where the delim chars are
  memcpy(input_data_cpy, cmd.input_data, BUFFER_SIZE);

  int i = 0;
  char *token = strtok(input_data_cpy, space_delim);
  while (token != NULL) {
    cmd.input_tokens[i++] = token;
    token = strtok(NULL, space_delim);
  }
  cmd.tokens_length = i + 1;
}

// returns true on End of Transmission Signal encountered
// returns false if data still needs to be read
bool read_serial_in() {
  if (Serial.available() > 0) {
    char c;
    while ((c = Serial.read()) != -1 && cmd.input_pos < BUFFER_SIZE - 1) {
      if (c == BOT) {
        time_d.swift_start_t = millis();
        // transmission_ongoing = true;
      }
      else if (c == EOT) {
        cmd.input_data[cmd.input_pos] = '\0';
        cmd.input_pos = 0;
        // transmission_ongoing = false;
        return true;
      }
      cmd.input_data[cmd.input_pos++] = c;
    }
    if (cmd.input_pos == BUFFER_SIZE - 1) {
      write_message(-1, "ERROR input buffer stream overflow");
      // clear the stream so the next message can procceed from a defined input_data state
      cmd.input_pos = 0;
      memset(cmd.input_data, '\0', BUFFER_SIZE);
      current_state = WAITING;
    }
  }
  return false;
}

// reaches out to each connected sensor and waits for data to see if any issues exist
void check_all_sensors(){
  char error_msg[S_BUFFER_SIZE];
  memset(error_msg, '\0', S_BUFFER_SIZE);
  
  flowSerial.write("a\r");
  delay(100);
  // Something like this should be returned
  // A +011.96 +033.75 +0.0000 +0.0000 +0.3000
  if (flowSerial.read() != 'A'){
    strcat(error_msg, "Apex Flow sensor A did not respond when polled");
  }

  // clear softewareSerial buffer
  while (flowSerial.read() != -1);

  flowSerial.write("b\r");
  delay(100);
  // Something like this should be returned
  // B +011.96 +033.75 +0.0000 +0.0000 +0.3000
  if (flowSerial.read() != 'B'){
    if (strlen(error_msg) != 0){
      strcat(error_msg, " ");
    }
    strcat(error_msg, "Apex Flow sensor B did not respond when polled");
  }

  // clear softewareSerial buffer
  while (flowSerial.read() != -1);

  // some error has occured
  if (strlen(error_msg) > 0){
    Serial.write(BOT);
    Serial.write(" BAD ");
    Serial.write(error_msg);
    Serial.write(" ");
    Serial.write(EOT);
  }else{
    Serial.write(BOT);
    Serial.write(" OK ");
    Serial.write(EOT);
  }
}


void setup()  {
  // Define pin modes for TX and RX
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);

  // Set the baud rate for the SoftwareSerial object
  flowSerial.begin(9600);

  // Baud rate for USB connection to computer
  Serial.begin(9600);
  while (!Serial);

  // Initalize Thermocouple
  while(!thermocouple.begin()){
    write_message(-1, "ERROR thermocouple initialization error");
    delay(1);
  }

  // initalize state
  // initally we're just waiting for some sort of command to come in over serial
  current_state = WAITING;
  cmd.input_pos = 0;
  cmd.UID = -1;

  time_d.flow_sensor_start_t = 0;
  time_d.swift_start_t = 0;

  writing_flow_data = false;
  time_waiting = false;
  transmission_ongoing = false;
}


void loop() {
  switch (current_state)
  {
    case READ_CMD:
      {
        if (read_serial_in()) {
          current_state = WRITE_CMD;
        }
      }
      break;
    case WRITE_CMD:
      {
        // Parse command in input_data and put into input_tokens
        parse_cmd();

        if (cmd.tokens_length < 2) {
          write_message(-1, "ERROR malformed input");
          current_state = WAITING;
        } else {
          cmd.UID = atoi(cmd.input_tokens[0]);
        }
        // $ <UID> <COMMAND> ;
        // input_tokens[1] is the actual command
        // COMMAND has no delimiters
        // Send the flow sensor the command
        char* COMMAND = cmd.input_tokens[1];
        if (strncmp(COMMAND, "TEMP", 4) == 0) {
          // read sensor and send value over
          double temp_reading = THERMOCOUPLE_UNINIT;
          temp_reading = thermocouple.readCelsius();
          if (isnan(temp_reading) || thermocouple.readError() > 0 || temp_reading == THERMOCOUPLE_UNINIT){
            write_message(cmd.UID, "ERROR critical thermocouple readError the chip may not be connected.");
          }else{
            Serial.write(BOT);
            Serial.write(" ");
            Serial.print(cmd.UID, DEC);
            Serial.write(" ");
            Serial.print(temp_reading, DEC); 
            Serial.write(" ");
            Serial.write(EOT);
          }
          current_state = WAITING;
        }
        else if (strncmp(COMMAND, "STATUS", 5) == 0) {
          check_all_sensors();
          current_state = WAITING;
        } else {
          // every command sent to a flow sensor device needs to be followed by a carriage return
          flowSerial.write(COMMAND);
          flowSerial.write("\r");
          // start the timeout timer
          time_d.flow_sensor_start_t = millis();
          current_state = WAIT_FOR_DATA;
        }
      }
      break;
    case WAIT_FOR_DATA:
      {
        // wait for data
        // when data arrives send it and go back to waiting
        if (flowSerial.available() > 0) {
          if (writing_flow_data == false) {
            // first time beginning of transmission
            writing_flow_data = true;
            Serial.write(BOT);
            Serial.write(" ");
            Serial.print(cmd.UID, DEC);
            Serial.write(" ");
          }
          char c;
          while ((c = flowSerial.read()) != -1) {
            if (c != '\r') {
              Serial.write(c);
            } else {
              Serial.write(" ");
              Serial.write(EOT);
              current_state = WAITING;
              writing_flow_data = false;
              break;
            }
          }
        }
        // If no data is recived go back to waiiting
        if (writing_flow_data == false && (millis() - time_d.flow_sensor_start_t > TIMEOUT_DURATION)) {
          write_message(cmd.UID, "ERROR serial communication with flow sensor timeout");
          current_state = WAITING;
        }
      }
      break;
    case WAITING:
      {
        // Wait for a beginning of transmission signal to come through
        if (Serial.available() > 0) {
          if (Serial.read() == BOT) {
            current_state = READ_CMD;
          }
        }
      }
      break;
  }
}
