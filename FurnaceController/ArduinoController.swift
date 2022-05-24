//
//  ArduinoController.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import Foundation
import ORSSerial

class ArduinoController: NSObject, ObservableObject, ORSSerialPortDelegate {
    
    struct Command {
        var id: Int
        var type: String
        var receivedResponse: Bool
        
        init(id: Int, type: String){
            self.id = id
            self.type = type
            self.receivedResponse = false
        }
    }
    
    var serialPortManager: ORSSerialPortManager = ORSSerialPortManager.shared()
    
    // All of these published variables are used to keep the app display updated.
    // The @Published modifier makes the view watch the variable to see if it
    // needs to be updated on the display
    private static let QUERY_TEMP = "temp?"
    
    @Published var nextCommand = ""
    @Published var lastResponse = "" // possibly just a debugging variable, possibly not
    
    private var commands: [Command] = []
    private var nextID = 0
    
    @Published var lastTemp = 0
    @Published var lastFlowN2 = 0
    @Published var lastFlowAr = 0
    @Published var tempUnit = "C"
    @Published var flowUnit = "L/min"
    
    private let thermocoupleID = "T"
    private let nitrogenFlowID = "N"
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
    
    // sends whatever command is entered into the textbox. Currently triggered by a button.
    func sendCommand() {
        if let port = self.serialPort{
            let command = "$ \(self.nextCommand) ;"
            
            port.send(command.data(using: .utf8)!)
        }
    }
    
    func readTemperature() {
        if let port = self.serialPort{
            let command = Command(id: self.nextID, type: ArduinoController.QUERY_TEMP)
            self.nextID += 1
            
            port.send("$ \(command.id) \(self.thermocoupleID)\r ;".data(using: .utf8)!)
            
            self.commands.append(command)
        }
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
            self.lastResponse = dataAsList[1...dataAsList.count - 2].joined(separator: " ")
            
            let requestType = self.requestTypes[Int(dataAsList[1])!] // gets the type of command sent according to the ID
            let requestData = dataAsList[2] // this is arbitrary string data, used in if statements
            
            if requestType == ArduinoController.QUERY_TEMP {
                self.lastTemp = Int(dataAsList[2])!
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
        let descriptor = ORSSerialPacketDescriptor(prefixString: "$", suffixString: ";", maximumPacketLength: 1024, userInfo: nil)
        serialPort.startListeningForPackets(matching: descriptor)
        
        print("Port \(serialPort.path) is open")
        self.nextPortState = "Close"
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        print("Port \(serialPort.path) is open")
        self.nextPortState = "Open"
    }
}
