//
//  ArduinoController.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import Foundation
import ORSSerial
import SwiftUI
/**
The ArduinoController is what sends commands to and receives data from the arduino, and handles all usbport 
 
 */
class ArduinoController: NSObject, ObservableObject, ORSSerialPortDelegate {
    
    struct Command {
        /// this is to handle what to do with a response to the command
        var type: CommandType
        /// this is just the command part of the serial string sent to arduino. does not include the UID
        var request: String
        /// Full response (used for debugging)
        var response: String
        
        init(request: String, type: CommandType){
            self.type = type
            self.request = request
            self.response = ""
        }
    }
    
    /// types of commands that require handling a response
    enum CommandType {
        case QUERY_TEMP
        case QUERY_ARGON
        case QUERY_NITROGEN
        case GENERAL
        case STATUS
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
    @Published var lastFlowAr = 0.0
    @Published var lastFlowN2 = 0.0
    @Published var tempUnit = "C"
    @Published var flowUnit = "L/min"
    
    // this is used to see if all 3 sensors have collected data, so we can write it to a file
    var values: [Double] = [-1, -1, -1]
    
    private let thermocoupleID = "TEMP"
    private let nitrogenFlowID = "B"
    private let argonFlowID = "A"
    @Published var nextPortState = "Open"
    @Published var statusOK = false
    
    let MAX_FLOWRATE = 10.0
    
    @Published var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            serialPort?.parity = .none
            serialPort?.baudRate = 9600
            serialPort?.delegate = self
        }
    }
    
    /// sends a generic command type, using the request field as the `Data` of the command (see Command language specs)
    func sendCommand(command: Command) {
        if let port = self.serialPort{
            port.send("$ \(self.nextID) \(command.request) ;".data(using: .utf8)!)
            
            self.commands[self.nextID] = command
            self.nextID += 1
        }
    }
    
    // sends whatever command is entered into the textbox. Currently triggered by a button. Used for debugging
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
