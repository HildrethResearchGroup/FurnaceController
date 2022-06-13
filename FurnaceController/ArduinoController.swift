
import Foundation
import ORSSerial
import SwiftUI

/// The interface between the Arduino and the rest of the Swift application. Handles initialization of the connection with an Arduino, sending commands to the Arduino, and receiving and parsing data received from the Arduino.
///
/// This class relies heavily on the ORSSerial library created by armadsen. For more in-depth documentation, go to [their github repository](https://github.com/armadsen/ORSSerialPort).
///
/// ArduinoController implements the  ObservableObject and ORSSerialPortDelegate protocols. It is also a subclass of NSObject. The ObservableObject protocol indicates that the view may need to be updated if certain properties, marked with the @Published property wrapper, are updated. The ORSSerialPortDelegate protocol makes it so that the ArduinoController class is informed whenever the port receives data, whenever the port is opened/closed, whenever an error with the port is detected, and whenever the port is disconnected. The serialPort:didReceiveData method is part of this protocol.
///
///

class ArduinoController: NSObject, ObservableObject, ORSSerialPortDelegate {
    
    // MARK: Command Struct
    
    /// Stores information for commands sent to Arduino
    ///
    /// Contains command type, the command string, and a response for debugging.
    struct Command {
        
        /// Specifies which sensor or status check the command is meant for.
        ///
        /// This is to handle what to do with a response to the command
        var type: CommandType
        
        /// The command that will be sent to the Arduino (without the ID)
        ///
        /// This is just the command part of the serial string sent to the Arduino. does not include the UID
        var request: String
        
        /// Full response from Arduino
        ///
        /// Used for debugging
        var response: String
        
        ///  Initializer for a Command object
        /// - Parameters:
        ///   - request: The String command sent to the Arduino along with the command ID
        ///   - type:  Defines which aspect of the hardware the command is communicating with
        init(request: String, type: CommandType){
            self.type = type
            self.request = request
            self.response = ""
        }
    }
    
    // MARK: Enumerated CommandType Object
    
    /// Types of commands that require handling a response
    ///
    /// Meaning for each command type:
    /// * QUERY_TEMP =
    /// * QUERY_ARGON =
    /// * QUERY_NITROGEN =
    /// * GENERAL =
    /// * STATUS =
    enum CommandType {
        case QUERY_TEMP
        case QUERY_ARGON
        case QUERY_NITROGEN
        case GENERAL
        case STATUS
    }
    
    // MARK: Variables
    
    /// Reference to the singleton instance of ORSSerialPortManager
    ///
    /// Provides a list of ports with its availablePorts property.
    var serialPortManager: ORSSerialPortManager = ORSSerialPortManager.shared()
    
    // All of these published variables are used to keep the app display updated.
    // The @Published modifier makes the view watch the variable to see if it
    // needs to be updated on the display
    
    // TODO: Complete Documentation
    @Published var nextCommand = ""
    
    @Published var lastResponse = ""
    
    /// A dictionary that stores command history by command ID.
    private var commands: [Int: Command] = [:]
    
    /// The command ID that the next command sent will use
    private var nextID = 0
    
    /// The last temperature value that was received from the Arduino
    @Published var lastTemp = 0.0
    
    /// The last Argon flowrate value that was received from the Arduino
    @Published var lastFlowAr = 0.0
    
    /// The last Nitrogen flowrate value that was received from the Arduino
    @Published var lastFlowN2 = 0.0
    
    /// The temperature units being used
    @Published var tempUnit = "C"
    
    /// The flowrate units being used
    @Published var flowUnit = "L/min"
    
    // this is used to see if all 3 sensors have collected data, so we can write it to a file
    var values: [Double] = [-1, -1, -1]
    
    /// Sensor ID that is used to identify that the command should communicate with the Thermocouple.
    private let thermocoupleID = "TEMP"
    
    /// Sensor ID that is used to identify that the command should communicate with the Nitrogen Flow Meter.
    private let nitrogenFlowID = "B"
    
    /// Sensor ID that is used to identify that the command should communicate with the Argon Flow Meter.
    private let argonFlowID = "A"
    
    /// String indicator of current port state.
    ///
    /// This indicator is used for determining if the open or close function should be used when the openOrClosePort function is callled. It also acts as the Text for the button next to the port selection dropdown in InfoView
    @Published var nextPortState = "Open"
    
    // TODO: Clarify with Josh when getStatus is called
    
    /// Current status of the connection between the application and the Arduino
    ///
    /// A true value indicates that the Arduino is connected and that all sensors are sending appropriate signals to the Arduino. This value will change when an Arduino unit is connected, when an Arduino unit is closed or disconnected, and when the status command returns a bad value.
    @Published var statusOK = false
    
    /// Max flowrate that the sensors can handle
    ///
    /// This value serves as an upper bound to values which may be input to the sensor. If a value larger than this value is entered, it will automatically be adjusted to this value.
    let MAX_FLOWRATE = 10.0
    
    /// Defines the selected serial port with the didSet property observer
    ///
    /// The didSet property observer makes it so that whenever the serial port is changed, the values within the didSet observer are updated.
    @Published var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            serialPort?.parity = .none
            serialPort?.baudRate = 9600
            serialPort?.delegate = self
        }
    }
    
    // MARK: Functions
    
    // TODO: Check specifics with Josh
    // sends a generic command type, using the request field as the `Data` of the command (see Command language specs)
    
    
    /// Send a GENERIC type command to the Arduino
    /// - Parameter command: The command that should be sent to the Arduino
    ///
    /// The request field acts as the 'Data' of the command (look at the command language specs). A command in the form
    /// "$ [Command ID] [Command] ;"
    /// will be sent as data in the utf 8 data encoding.
    func sendCommand(command: Command) {
        if let port = self.serialPort{
            // Send the command
            port.send("$ \(self.nextID) \(command.request) ;".data(using: .utf8)!)
            
            self.commands[self.nextID] = command
            self.nextID += 1                           // increment the command ID
        }
    }
    
/*
 The below function is used for testing
 */
//    Sends whatever command is entered into the textbox. Currently triggered by a button. Used for debugging
//    func sendCommand() {
//        let command = Command(request: self.nextCommand, type: .GENERAL)
//        self.sendCommand(command: command)
//    }
    
    // Next 3 functions are to read in sensor data
    
    /// Send a read temperature request to the Arduino.
    ///
    /// This command instructs the Arduino to send the current temperature it is reading from the thermocouple back to the application.
    func readTemperature() {
        let command = Command(request: self.thermocoupleID, type: .QUERY_TEMP)
        self.sendCommand(command: command)
    }
    
    
    /// Send a read Argon flowrate request to the Arduino
    ///
    /// This command instructs the Arduino to send a polling request to the Argon flow meter. The sensor will then return a data packet which includes the flowrate which will be passed by the Arduino back to the application.
    func readArgonFlow() {
        let command = Command(request: self.argonFlowID, type: .QUERY_ARGON)
        self.sendCommand(command: command)
    }
    
    /// Send a read Nitrogen flowrate request to the Arduino
    ///
    /// This command instructs the Arduino to send a polling request to the Nitrogen flow meter. The sensor will then return a data packet which includes the flowrate which will be passed by the Arduino back to the application.
    func readNitrogenFlow() {
        let command = Command(request: self.nitrogenFlowID, type: .QUERY_NITROGEN)
        self.sendCommand(command: command)
    }
    
    
    /// Send a set Argon flowrate command to the Arduino, which will update the appropriate sensor.
    /// - Parameter flow: The setpoint that the Argon sensor should be updated to.
    func setArgonFlow(flow: Double) {
        let command = Command(request: self.argonFlowID + "s" + String(flow), type: .GENERAL)
        self.sendCommand(command: command)
    }
    
    /// Send a set Nitrogen flowrate command to the Arduino, which will update the appropriate sensor
    /// - Parameter flow: The setpoint that the Nitrogen sensor should be updated to.
    func setNitrogenFlow(flow: Double) {
        let command = Command(request: self.nitrogenFlowID + "s" + String(flow), type: .GENERAL)
        self.sendCommand(command: command)
    }
    
    // TODO: Confirm when this function is called
    
    /// Send a status check command to the Arduino
    ///
    /// This command is called whenever a Arduino is connected.
    func getStatus() {
        if let port = self.serialPort {
            port.send("$ -1 STATUS ;".data(using: String.Encoding.utf8)!)
        }
        
        let command = Command(request: "STATUS", type: .STATUS)
        self.sendCommand(command: command)
    }
    
    /// Send a series of 14 commands back-to-back.
    ///
    /// This is a function for testing the load that the Application to Arduino to Sensors connection can handle.
    func commandBomb() {
        self.getStatus()
        self.readTemperature()
        self.readArgonFlow()
        self.readNitrogenFlow()
        self.setArgonFlow(flow: 1)
        self.setNitrogenFlow(flow: 0)
        self.setArgonFlow(flow: 0.5)
        self.setNitrogenFlow(flow: 0.5)
        self.setArgonFlow(flow: 0)
        self.setNitrogenFlow(flow: 1)
        self.readTemperature()
        self.readArgonFlow()
        self.readNitrogenFlow()
        self.getStatus()
    }
    
    /// Determines based on the current port status whether the port should be opened or closed when this function is called.
    ///
    /// This function is attached to the open/close button that exists within InfoView.
    func openOrClosePort() {
        if let port = self.serialPort {
            if (port.isOpen) {
                port.close()
            } else {
                port.open()
            }
        }
    }
    
    /// Respond to incoming packets recieved from the serial port and appropriately parse the data.
    ///
    ///- Parameters:
    ///   - serialPort: Current serial port that is being communicated with
    ///   - packetData: Data in the form of a packet
    ///   - descriptor: Format of the data packet
    ///
    /// Based on the command ID that is listed at the start of any data packet that is returned, the command with the same ID that exists within the command history has its response property updated. Then, the second field is checked to determine which type of command the Arduino is responding to. This indicates which fields of the returned data packet need to be used to update certain variables for storing the data. This is also the field that indicates if an error occurred or if a bad command was passed to the Arduino.
    func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor: ORSSerialPacketDescriptor) {
        
        // First the data is parsed by spaces into a list of values
        if var dataAsList = String(data: packetData, encoding: String.Encoding.ascii)?.components(separatedBy: " ") {
            
            // Remove any empty data from the list
            while dataAsList.contains("") {
                dataAsList.remove(at: dataAsList.firstIndex(of: "")!)
            }
            
            // Print the list of data
            print(dataAsList)
            
            // Set UID equal to the command ID identified by the packet
            if let UID = Int(dataAsList[1]){
                
                // In the command history, record the data packet as the response for the command with the matching command ID
                if var command = commands[UID] {
                    command.response = dataAsList.joined(separator: " ")
                    
                    
                    // Response for when an error is detected
                    if (dataAsList[2] == "ERROR") {
                        let errorResponse = dataAsList[3...dataAsList.count-2].joined(separator: " ")
                        AppController.shared.errorMessage = "ERROR: " + errorResponse
                        return
                    }
                    // Response for when an unknown command is detected
                    else if (dataAsList[2] == "?") {
                        let errorResponse = "unknown command sent to flow sensor"
                        AppController.shared.errorMessage = "ERROR: " + errorResponse
                        return
                    }
                    // Process for handling a data packet from a temperature data request
                    if command.type == .QUERY_TEMP {
                        self.lastTemp = Double(dataAsList[2])!
                        self.values[0] = self.lastTemp
                    }
                    // TODO: maybe add a confirmation that we are, in fact, reading Nitrogen data (response includes Gas Type)
                    // Process for handling a data packet from an Argon sensor data request
                    else if command.type == .QUERY_ARGON {
                        self.lastFlowAr = Double(dataAsList[6])!
                        self.values[1] = self.lastFlowAr
                    }
                    // Process for handling a data packet from a Nitrogen sensor data request
                    else if command.type == .QUERY_NITROGEN {
                        self.lastFlowN2 = Double(dataAsList[6])!
                        self.values[2] = self.lastFlowN2
                    }
                    // Process for handling a data packet from an Arduino and Sensor status request
                    else if command.type == .STATUS {
                        self.statusOK = dataAsList[2] == "OK"
                        
                        // Indicate an error if the status request indicates a bad status
                        if !self.statusOK {
                            let errorResponse = dataAsList[3...dataAsList.count-2].joined(separator: " ")
                            AppController.shared.errorMessage = "ERROR: " + errorResponse
                            return
                        }
                    }
                    // Process for handling a data packet returned from a GENERAL command
                    else if command.type == .GENERAL {
                        self.lastResponse = command.response
                        //print(command.response)
                    }
                    
                    // Check that the values have been updated
                    if values[0] != -1 && values[1] != -1 && values[2] != -1 {
                        AppController.shared.recordData(temp: values[0], flowAr: values[1], flowN2: values[2])
                        values = [-1, -1, -1]
                    }
                }
            }
        }
    }
    
    
    /// Prints an error message when an error relating to the serial port connection occurs
    /// - Parameters:
    ///   - serialPort: Current serial port that is being communicated with
    ///   - error: Error relating the serial port connection
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("SerialPort \(serialPort) encountered an error: \(error)")
    }
    
    
    /// Updates the serial port when the device is physically disconnected from the port
    /// - Parameter serialPort: Current serial port that is being communicated with
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    

    ///  Initializes the connection with a port and starts searching for packages that follow a certain descriptor.
    /// - Parameter serialPort: Current serial port that is being communicated with
    ///
    /// This function is called when a serial port is first opened. It starts by adding a package desriptor which indicates the characters which will indicate the beginning and end of a packet. This descriptor is then connected to the serial port that was just opened. Finally, the status of the Arduino port is updated in order to update elements of the GUI and prevent users from opening a second port before closing the one that was just opened.
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        // Indicate the type of packet that the program should be looking for
        let descriptor = ORSSerialPacketDescriptor(prefixString: "$", suffixString: ";", maximumPacketLength: 4096, userInfo: nil)
        serialPort.startListeningForPackets(matching: descriptor)
        
        // Update the variable relating to the status of the port
        print("Port \(serialPort.path) is open")
        self.nextPortState = "Close"
        
        // Start a timer connected to the port
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.getStatus()
        }
    }
    
    /// Terminates the connection with a port and updates the port connection status
    /// - Parameter serialPort: Current serial port that is being communicated with
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        // Indicate that the program should stop looking for packets
        serialPort.stopListeningForPackets(matching: serialPort.packetDescriptors.first!)
        
        // Update the status of the port connection
        print("Port \(serialPort.path) is closed")
        self.nextPortState = "Open"
        self.statusOK = false
    }
}
