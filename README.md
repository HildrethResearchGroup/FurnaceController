# FurnaceController

A macOS application written in Swift that can interface with an Arduino UNO to:
- Set Flow rate data on Apex Flow Sensors
- Read Flow rate data on Apex Flow Sensors
- Read the temperature from the Furnace

Using this information the application can log the data recieved and provide an interface for setting the flow rates and reading the temperature values. 




# Table of Contents
[1. Building the Swift application](#building-the-swift-application)
[2. Brief overview of Swift code](#brief-overview-of-Swift-code)
[3. Hardware specification and diagrams](#hardware-specification-and-diagrams)
[4. Important docs and explanations](#important-docs-and-explanations)

# 1. Swift Application

**Project Dependencies**

There are a couple of dependencies for this project, which *should* all be in this repository already. If you find yourself missing anything, here is what you need:

* ORSSerialPort - https://github.com/armadsen/ORSSerialPort
* DataGraph - https://www.visualdatatools.com/DataGraph/
  * To view the graph in the application, you *must* have the DataGraph application downloaded and have a license for DataGraph. Professor Hildreth has a license. 

**Cloning the application into Xcode**

1. Download Xcode 13.4.1 (*might* also work in future versions)
2. Copy the repository URL
3. Open Xcode, click "Clone an existing project"
4. Paste repository URL into top search bar and click "clone" 3 times

**Swift Documentation**

The DocC documentation compiler converts Markdown-based text into rich documentation for Swift and Objective-C projects, and displays it right in the Xcode documentation window. To build and view the application's documentation in Xcode, click Product->Build Documentation.

# 2. Arduino and Hardware
**Language Specification**
The Arduino has a simple language API which was developed to allow for both manual testing and communication with the Swift Application.

To directly send the Arduino commands connect to the Arduino with a serial monitor set to 9600 BAUD (assuming the Arduino has been flashed with the project code & is wired correctly)

**Command Format:**
```
$ <UID> <DATA> ;
```
- **UID** is a positive 32-bit integer value 
- **DATA** is a variable length string 
    It can either be an **Immediate command** or an **Apex Flow Sensor command**
- **$** is the beginning of transmission signal (BOT)
- **;** is the end of transmission signal (EOT)

**List of Immediate commands:**
| CMD | Description |
| --- | ----------- |
| TEMP | Polls the thermocouple for the temperatuure in Celsius |
| STATUS | Prints debug information about sensors. See Status response section for more info. |

**List of Apex Flow Sensor commands**
The following commands assume a device id of A. See the Apex Flow Sensor manual on how to set the device id. 
| CMD | Description | 
| --- | ----------- |
| a | Polls the Apex Flow Device for a data frame. Typically in the form of: ```$ [Command ID]   [Unit ID]  [Absolute Pressure] [Temperature]  [Volumetric Flow]  [Mass Flow]  [Setpoint] [Gas] ;``` |
| as[floating point number] | Sets the setpoint (target for gas flow) of the device to the described value. Many Apex flow devices have hardset limits (ex: 0-10 L/min). Example Command: as0.25 : Sets the setpoint to 0.25 L/min

**Command Examples** 
| Command | Description |
| - | - |
| $ 1 STATUS ; | Polls for status of all sensors |
| $ 1 a ; | Polls flow sensor a for data | 
| $ 1 A ; | Polls flow sensor a for data (Identical to above) |
| $ 1 TEMP ; | Polls thermocouple for data |

**Flashing the Arduino & Getting communication up and running** 
1. Download the Aruino IDE from https://www.arduino.cc/en/software
2. Using the Arduino package manager, install https://github.com/adafruit/Adafruit-MAX31855-library
3. Wire up the Arduino as depicted by the Arduino Circuit Diagram
4. Configure the flow sensor devices (See Configuring the Apex Flow Sensor devices)
5. Flash the Arduino with the project code in the Controller folder
6. Open the included Serial montior with the IDE and set the BAUD to 9600
7. Send some sample commands (See Command Examples)

**Arduino Circuit Diagram**
![Arduino Circuit Diagram*](https://user-images.githubusercontent.com/63746522/173146773-a187073d-67cc-4125-81f6-e75cf9873cc7.jpg)

**Arduino State Machine**

TTL Serial is how communication between the connected MacOS application and the Arduino is conducted. This protocol is asynchronous meaning that a string sent will not all arrive at the same time. Because of this a state machine was built in order to handle staying in specific states untill all information is recived. 
Beginning of transmission signal **$** (BOT)
End of transmission signal **;** (EOT)
The arduino begins filling the input buffer when the BOT signal is recived and parses the command when the EOT signal is recived. See the arduino code for more detail. 
**IMPORTANT:** Commands must have BOT and EOT otherwise they will not be processed correctly. 
![Arduino State Diagram](https://user-images.githubusercontent.com/63746522/173144378-d2219624-6fb2-4935-a0c3-cf62166a2447.jpg)

**TTL and RS-232 as flavors of UART**
Both TTL and RS-232 are flavors of UART which stands for universal asynchronous reciver transmiter. Both TTL and RS-232 need either software emulation or a hardware chip (most common) to achieve communication. The only difference between TTL and RS-232 is the voltage levels which are designated. 

**SPI (Serial Peripheral Interface)**
The Thermocouple amplifier (Max 31855) uses SPI, but fortunately the MAX 31855 library takes care of the amplifier for you. 

Here are some useful docs for learning about UART, RS-232, and TTL 
- https://www.circuitbasics.com/basics-uart-communication/#:~:text=UART%20stands%20for%20Universal%20Asynchronous,transmit%20and%20receive%20serial%20data.
- https://support.unitronics.com/index.php?/selfhelp/view-article/connect-devices-with-ttl-interface-levels-to-rs232-interface

# 3. Important docs and explanations

### System Architecture

Here is a high-level overview of all of the components of our project and how they interact. 
![Architecture Diagram](https://user-images.githubusercontent.com/63746522/173135280-58aab64d-c667-485b-831b-c4a724d6ab8b.jpg)

### Configuring the Apex Flow Sensor devices
- Set Baud rate to 9600
- Nitrogen has device ID A
- Argon had device ID B  
- Details on to do this can be found in the device manual : https://apexvacuum.com/wp-content/uploads/2021/09/DOC-MANUAL-M-2021-Apex.pdf  

**Here are some links for hardware and serial communications:**  
* [Thermocouple introduction](https://www.britannica.com/technology/thermocouple "InfoLink")

* “RS-232 vs. TTL Serial Communication,” https://www.sparkfun.com/tutorials/215#:~:text=This%20method%20of%20serial%20communication,'0')%20is%200V

* “Operating Manual For Mass Flow Meters Models M · MQ · MS · MW · MB · MBQ · MBS · MWB,” https://apexvacuum.com/wp-content/uploads/2021/09/DOC-MANUAL-M-2021-Apex.pdf

* “Serial communication Basic Knowledge -RS-232C/RS-422/RS-485,” https://www.contec.com/support/basic-knowledge/daq-control/serial-communicatin/ 

* “RS232 Serial Communication Protocol: Basics, Working & Specifications,” https://circuitdigest.com/article/rs232-serial-communication-protocol-basics-specifications

* “VCC and VSS Pins,” https://www.tutorialspoint.com/vcc-and-vss-pins#:~:text=VCC%20(Voltage%20Common%20Collector)%20is,Supply)%20means%20ground%20or%20zero

* “What is Arduino?,” https://www.arduino.cc/en/Guide/Introduction
