//
//  ArduinoController.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import Foundation
import ORSSerial

class ArduinoController: NSObject, ObservableObject, ORSSerialPortDelegate {
    
    let TIMEOUT = 2 // the amount of timeout to give a command in seconds
    
    struct Command {
        var type: CommandType // this is to handle what to do with a response to the command
        var request: String // this is just the command part of the serial string sent to arduino. does not include the UID
        var response: String // Full response (just atm, for debugging)
        
        init(request: String, type: CommandType){
            self.type = type
            self.request = request
            self.response = ""
        }
    }
    
    enum CommandType {
        case QUERY_TEMP
        case QUERY_NITROGEN
        case QUERY_ARGON
        case GENERAL
    }
    
    var serialPortManager: ORSSerialPortManager = ORSSerialPortManager.shared()
    
    // All of these published variables are used to keep the app display updated.
    // The @Published modifier makes the view watch the variable to see if it
    // needs to be updated on the display
    @Published var nextCommand = ""
    @Published var lastResponse = "" // possibly just a debugging variable, possibly not
    
    private var commands: [Int: Command] = [:]
    private var nextID = 0
    
    @Published var lastTemp = 0.0
    @Published var lastFlowN2 = 0.0
    @Published var lastFlowAr = 0.0
    @Published var tempUnit = "C"
    @Published var flowUnit = "L/min"
    
    private let thermocoupleID = "T"
    private let nitrogenFlowID = "B"
    private let argonFlowID = "A"
    @Published var nextPortState = "Open"
    
    @Published var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            serialPort?.parity = .none
            serialPort?.baudRate = 9600
            serialPort?.delegate = self
        }
    }
    
    func sendCommand(command: Command) {
        if let port = self.serialPort{
            port.send("$ \(self.nextID) \(command.request) ;".data(using: .utf8)!)
            
            self.commands[self.nextID] = command
            self.nextID += 1
        }
    }
    
    // sends whatever command is entered into the textbox. Currently triggered by a button.
    func sendCommand() {
        let command = Command(request: self.nextCommand, type: .GENERAL)
        self.sendCommand(command: command)
    }

    func readTemperature() {
        let command = Command(request: self.thermocoupleID, type: .QUERY_TEMP)
        self.sendCommand(command: command)
    }
    
    func readArgonFlow() {
        let command = Command(request: self.argonFlowID, type: .QUERY_ARGON)
        self.sendCommand(command: command)
    }
    
    func readNitrogenFlow() {
        let command = Command(request: self.nitrogenFlowID, type: .QUERY_ARGON)
        self.sendCommand(command: command)
    }
    
    func recordTime() {
        
    }
    
    // opens/closes the serial port. controlled by a button
    func openOrClosePort() {
        if let port = self.serialPort {
            if (port.isOpen) {
                port.close()
            } else {
                port.open()
            }
        }
    }
    
    // the serialPort functions all respond to incoming packets recieved from the serial port
    // if the ORSSerial{PacketDescriptor sees a command from arduino, it will call the first function
    func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor: ORSSerialPacketDescriptor) {
        if let dataAsList = String(data: packetData, encoding: String.Encoding.ascii)?.components(separatedBy: " ") {
            let UID = Int(dataAsList[1])!
            
            if var command = commands[UID] {
                command.response = dataAsList.joined(separator: " ")
                
                if (dataAsList[2] == "TIMEDOUT") {
                    print("Command \"\(command.request)\" timed out.")
                    self.sendCommand(command: command)
                    return
                }
                
                if command.type == .QUERY_TEMP {
                    self.lastTemp = Double(dataAsList[2])!
                }
                // maybe add a confirmation that we are, in fact, reading Nitrogen data (response includes Gas Type)
                else if command.type == .QUERY_NITROGEN {
                    self.lastFlowN2 = Double(dataAsList[6])!
                }
                else if command.type == .QUERY_ARGON {
                    self.lastFlowAr = Double(dataAsList[6])!
                }
                else if command.type == .GENERAL {
                    self.lastResponse = command.response
                    print(command.response)
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
    
    // called when a serial port is opened, and adds the packet descriptor to the port
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        let descriptor = ORSSerialPacketDescriptor(prefixString: "$", suffixString: ";", maximumPacketLength: 4096, userInfo: nil)
        serialPort.startListeningForPackets(matching: descriptor)
        
        print("Port \(serialPort.path) is open")
        self.nextPortState = "Close"
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        serialPort.stopListeningForPackets(matching: serialPort.packetDescriptors.first!)
        
        print("Port \(serialPort.path) is closed")
        self.nextPortState = "Open"
    }
}
