
import Foundation
import ORSSerial
import SwiftUI

/// The interface between the Arduino and the rest of the Swift application. Handles initialization of the connection with an Arduino, sending commands to the Arduino, and receiving and parsing data received from the Arduino.
///
/// This class relies heavily on the ORSSerial library created by armadsen. For more in-depth documentation, go to [their github repository](https://github.com/armadsen/ORSSerialPort).
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
    /// sends a generic command type, using the request field as the `Data` of the command (see Command language specs)
    func sendCommand(command: Command) {
        if let port = self.serialPort{
            port.send("$ \(self.nextID) \(command.request) ;".data(using: .utf8)!)
            
            self.commands[self.nextID] = command
            self.nextID += 1
        }
    }
    
    // Sends whatever command is entered into the textbox. Currently triggered by a button. Used for debugging
//    func sendCommand() {
//        let command = Command(request: self.nextCommand, type: .GENERAL)
//        self.sendCommand(command: command)
//    }
    
    // next 3 functions are to read in sensor data
    func readTemperature() {
        let command = Command(request: self.thermocoupleID, type: .QUERY_TEMP)
        self.sendCommand(command: command)
    }
    
    func readArgonFlow() {
        let command = Command(request: self.argonFlowID, type: .QUERY_ARGON)
        self.sendCommand(command: command)
    }
    
    func readNitrogenFlow() {
        let command = Command(request: self.nitrogenFlowID, type: .QUERY_NITROGEN)
        self.sendCommand(command: command)
    }
    
    func setArgonFlow(flow: Double) {
        let command = Command(request: self.argonFlowID + "s" + String(flow), type: .GENERAL)
        self.sendCommand(command: command)
    }
    
    func setNitrogenFlow(flow: Double) {
        let command = Command(request: self.nitrogenFlowID + "s" + String(flow), type: .GENERAL)
        self.sendCommand(command: command)
    }
    
    func getStatus() {
        if let port = self.serialPort {
            port.send("$ -1 STATUS ;".data(using: String.Encoding.utf8)!)
        }
        
        let command = Command(request: "STATUS", type: .STATUS)
        self.sendCommand(command: command)
    }
    
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
    
    /// opens/closes the serial port. controlled by a button
    func openOrClosePort() {
        if let port = self.serialPort {
            if (port.isOpen) {
                port.close()
            } else {
                port.open()
            }
        }
    }
    
    /// the serialPort functions all respond to incoming packets recieved from the serial port
    /// if the ORSSerial{PacketDescriptor sees a command from arduino, it will call the first function
    func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor: ORSSerialPacketDescriptor) {
        if var dataAsList = String(data: packetData, encoding: String.Encoding.ascii)?.components(separatedBy: " ") {
            while dataAsList.contains("") {
                dataAsList.remove(at: dataAsList.firstIndex(of: "")!)
            }
            print(dataAsList)
            if let UID = Int(dataAsList[1]){
            
                if var command = commands[UID] {
                    command.response = dataAsList.joined(separator: " ")
                    
                    if (dataAsList[2] == "ERROR") {
                        let errorResponse = dataAsList[3...dataAsList.count-2].joined(separator: " ")
                        AppController.shared.errorMessage = "ERROR: " + errorResponse
                        return
                    }
                    else if (dataAsList[2] == "?") {
                        let errorResponse = "unknown command sent to flow sensor"
                        AppController.shared.errorMessage = "ERROR: " + errorResponse
                        return
                    }
                    
                    if command.type == .QUERY_TEMP {
                        self.lastTemp = Double(dataAsList[2])!
                        self.values[0] = self.lastTemp
                    }
                    // TODO: maybe add a confirmation that we are, in fact, reading Nitrogen data (response includes Gas Type)
                    else if command.type == .QUERY_ARGON {
                        self.lastFlowAr = Double(dataAsList[6])!
                        self.values[1] = self.lastFlowAr
                    }
                    else if command.type == .QUERY_NITROGEN {
                        self.lastFlowN2 = Double(dataAsList[6])!
                        self.values[2] = self.lastFlowN2
                    }
                    else if command.type == .STATUS {
                        self.statusOK = dataAsList[2] == "OK"
                        
                        if !self.statusOK {
                            let errorResponse = dataAsList[3...dataAsList.count-2].joined(separator: " ")
                            AppController.shared.errorMessage = "ERROR: " + errorResponse
                            return
                        }
                    }
                    else if command.type == .GENERAL {
                        self.lastResponse = command.response
                        //print(command.response)
                    }
                    
                    if values[0] != -1 && values[1] != -1 && values[2] != -1 {
                        AppController.shared.recordData(temp: values[0], flowAr: values[1], flowN2: values[2])
                        values = [-1, -1, -1]
                    }
                }
            }
        }
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("SerialPort \(serialPort) encountered an error: \(error)")
    }
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    /// called when a serial port is opened
    /// - adds the packet descriptor to the port
    /// - updates the status
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        let descriptor = ORSSerialPacketDescriptor(prefixString: "$", suffixString: ";", maximumPacketLength: 4096, userInfo: nil)
        serialPort.startListeningForPackets(matching: descriptor)
        
        print("Port \(serialPort.path) is open")
        self.nextPortState = "Close"
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.getStatus()
        }
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        serialPort.stopListeningForPackets(matching: serialPort.packetDescriptors.first!)
        
        print("Port \(serialPort.path) is closed")
        self.nextPortState = "Open"
        self.statusOK = false
    }
}
