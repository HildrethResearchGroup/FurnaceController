# FurnaceController

A macOS application written in Swift that can interface with an Arduino UNO to:
- Set Flow rate data on Apex Flow Sensors
- Read Flow rate data on Apex Flow Sensors
- Read the temperature from the Furnace

Using this information the application can log the data recieved and provide an interface for setting the flow rates and reading the temperature values. 

# Table of Contents
1. Building the Swift application
2. Brief overview of Swift code
3. Hardware specification and diagrams
4. Important docs and explanations

# 1. Building the Swift application

# 2. Brief overview of Swift code

# 3. Arduino and Hardware
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

**Arduino State Machine**
**UART**
**TTL and UART**


# 4. Important docs and explanations

**Files included:**
ContentView.swift

# System Architecture
![image](/Users/prestonyates/Desktop/untitled%20folder/Screen%20Shot%202022-06-09%20at%201.54.22%20PM.png)




# Setup DataGraph Application
Import DataGraph.framework

- Make sure the Framework is installed/placed in the Folder after the .proj file

- Add the DataGraph.framework to your Target:
	- Targets → General → Frameworks, Libraries, and Embedded Content
	- Select: + button
	- Select: "Add Other" → Add Files
	- Select: the DataGraph.Framework Folder



- Create a .h file named: YourApplicationName-Bridging-Header.h
	- Select the top-level folder in your project (just under the blue project icon
	- Select: Menubar → File → New File
	- Select: Under Source → Header File
	- Name your file:  yourApplicaitonName-Bridging_Header.h
	- Make sure Targets is checked "Yes"


- Copy-Paste the supplied Bridging-Header information into your .h bridging-header file



- Make sure the path to the Bridging Header is correct
    	- Project → Build Settings → All
	- Swift Compiler - General → Objective-C Bridging Header:  <Internal Path: e.g. TestApp/TestApp-Bridging-Header.h>


- Switch Architecture to x86_64 on both the Project and the Target

- Under Build Settings, in Packaging, make sure the Defines Module setting for the framework target is set to Yes.
	- Project → Build Settings → All
	- Packaging → Defines Module:  Yes

- Turn OFF Hardened Runtime
	- Targets → Signing and Capabilities → Hardened Runtime 
	- There is a small, grey "x" in the upper left corner of the Hardened Runtime settings (just below the dividing line).  
	- Click "x" to remove all hardened runtime.


- Test the Importing of the Framework:
 	- Drag and Drop the files from the unzipped DataGraph Test Views.zip folder
	- Located under Files → DataGraph Framework → DataGraph Text Views.zip
	- Compile your application
	- Make sure there are no Compile Errors
  - Try to make DataGraph View
```
struct ContentView: View {
    @ObservedObject var graphController = GraphController()
    
    var body: some View {
        VStack{
            HStack {
                Slider(value: $graphController.adjustableValue, in: 0.0...10.0) {
                    Text(String(format: "%.2f", graphController.adjustableValue))
                }
                Text(String(format: "%.2f", graphController.computedValue))
            }
            
            Button("Increment"){graphController.updateData()}
            GraphViewRepresentable(graphController: graphController)
                .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        }
        .padding()
    }
}

```



# Circuit Diagrams and Hardware Setup

**Here are some links for hardware and serial communications:**

* Thermocouple introduction: https://www.britannica.com/technology/thermocouple

* “RS-232 vs. TTL Serial Communication,” https://www.sparkfun.com/tutorials/215#:~:text=This%20method%20of%20serial%20communication,'0')%20is%200V

* “Operating Manual For Mass Flow Controllers Models MC · MCD · MCE · MCQ · MCR · MCS · MCV · MCW,” https://documents.alicat.com/manuals/DOC-MANUAL-9V-MC.pdf 

* “Operating Manual For Mass Flow Meters Models M · MQ · MS · MW · MB · MBQ · MBS · MWB,” https://apexvacuum.com/wp-content/uploads/2021/09/DOC-MANUAL-M-2021-Apex.pdf  

* “Serial communication Basic Knowledge -RS-232C/RS-422/RS-485,” https://www.contec.com/support/basic-knowledge/daq-control/serial-communicatin/ 

* “Swift,” https://developer.apple.com/swift/

* “RS232 Serial Communication Protocol: Basics, Working & Specifications,” https://circuitdigest.com/article/rs232-serial-communication-protocol-basics-specifications

* “VCC and VSS Pins,” https://www.tutorialspoint.com/vcc-and-vss-pins#:~:text=VCC%20(Voltage%20Common%20Collector)%20is,Supply)%20means%20ground%20or%20zero

* “What is Arduino?,” https://www.arduino.cc/en/Guide/Introduction

# Additional Design Documents


