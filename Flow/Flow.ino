#include <SoftwareSerial.h>

#define rxPin 10
#define txPin 11
#define BUFFER_SIZE 256
#define TIMEOUT_DURATION 3000 // 3 seconds in miliseconds
#define EOT ';' // End of transmission
#define BOT '$' // Beginning of transmission

enum STATE {READ_CMD = 0, WRITE_CMD = 1, WAIT_FOR_DATA = 2, WAITING = 3};
enum STATE current_state;

struct time_delta {
  long int start_t;
  long int end_t;
} time_d;

bool time_waiting = false;

// Set up a new SoftwareSerial object
SoftwareSerial flowSerial =  SoftwareSerial(rxPin, txPin, false);

// data from fluid flow sensor
char flow_data[BUFFER_SIZE];

// input str from mac application
char input_data[BUFFER_SIZE];
int input_pos;

// parsed tokens from input_data
char* input_tokens[BUFFER_SIZE];
int tokens_length;

int UID;

bool writing_flow_data;

const char space_delim[2] = " ";

// Fills passed in buf with buf_size - 2 data. Last character of sequence is always null terminating char
// Returns number of characters written
int fill_buffer_from_stream(Stream &data, char buf[], int buf_size) {
  memset(buf, '\0', sizeof(char)*buf_size);
  int i = 0;
  if (data.available() > 0) {
    char c;
    while ( (c = data.read()) != -1 && i < buf_size - 1) {
      buf[i++] = c;
    }
  }
  return i;
}
// Writes a message to the serial Stream
void write_message(int uid, const char* msg) {
  Serial.write(BOT);
  Serial.write(" ");
  Serial.write("30");
  Serial.write(" ");
  Serial.write(msg);
  Serial.write(" ");
  Serial.write(EOT);
}

// parses input_data and fills input_tokens and sets tokens_length
void parse_cmd() {
  char input_data_cpy[BUFFER_SIZE];
  // strtok changes the passed in array and place '\0' where the delim chars are
  memcpy(input_data_cpy, input_data, BUFFER_SIZE);

  int i = 0;
  char *token = strtok(input_data_cpy, space_delim);
  while (token != NULL) {
    input_tokens[i++] = token;
    token = strtok(NULL, space_delim);
  }
  tokens_length = i + 1;
}

// returns true on End of Transmission Signal encountered
// returns false if data still needs to be read
bool read_serial_in() {
  if (Serial.available() > 0) {
    char c;
    while ((c = Serial.read()) != -1 && input_pos < BUFFER_SIZE - 1) {
      if (c == EOT) {
        input_data[input_pos] = '\0';
        input_pos = 0;
        return true;
      }
      input_data[input_pos++] = c;
    }
    if (input_pos == BUFFER_SIZE - 1) {
      write_message(-1, "ERROR input buffer stream overflow");
      // clear the stream so the next message can procceed from a defined input_data state
      input_pos = 0;
      memset(input_data, '\0', BUFFER_SIZE);
    }
  }
  return false;
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

  // initalize state
  // initally we're just waiting for some sort of command to come in over serial
  current_state = WAITING;
  input_pos = 0;
  UID = -1;

  time_d.start_t = 0;
  time_d.end_t = 0;

  writing_flow_data = false;
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

        if (tokens_length < 2) {
          write_message(-1, "ERROR malformed input");
          current_state = WAITING;
        } else {
          UID = atoi(input_tokens[0]);
        }
        // $ <UID> <COMMAND> ;
        // input_tokens[1] is the actual command
        // COMMAND has no delimiters
        // Send the flow sensor the command
        char* COMMAND = input_tokens[1];
        if (strcmp(COMMAND, "TEMP") == 0){
          // can just read it and send it over
          write_message(UID, "5");
          current_state = WAITING;
        }else{
        flowSerial.write(COMMAND);
        flowSerial.write("\r");
        // start the timeout timer
        time_d.start_t = millis();
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
            Serial.print(UID, DEC);
            Serial.write(" ");
          }
          char c;
          while ((c = flowSerial.read()) != -1) {
            if (c != '\r'){
              Serial.write(c);
            }else{
              Serial.write(" ");
              Serial.write(EOT);
              current_state = WAITING;
              writing_flow_data = false;
              break;
            }
          }
        }
        // If no data is recived go back to waiiting
        if (writing_flow_data == false && (millis() - time_d.start_t > TIMEOUT_DURATION)) {
          write_message(UID, "ERROR serial communication with flow sensor timeout"); 
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
