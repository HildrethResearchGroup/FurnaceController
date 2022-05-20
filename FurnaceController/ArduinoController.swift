//
//  ArduinoController.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import Foundation
import ORSSerial

class ArduinoController: NSObject, ObservableObject, ORSSerialPortDelegate {
    
    var serialPortManager: ORSSerialPortManager = ORSSerialPortManager.shared()
    
    // All of these published variables are used to keep the app display updated.
    // The @Published modifier makes the view watch the variable to see if it
    // needs to be updated on the display
    @Published var nextCommand = ""
    @Published var lastResponse = ""
    
    @Published var lastTemp = 0
    @Published var lastFlowN2 = 0
    @Published var lastFlowAr = 0
    
    @Published var tempUnit = "C"
    @Published var flowUnit = "L/min"
    
    @Published var nextPortState = "Open"
    @Published var isRecording = false // currently unused
    
    @Published var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            serialPort?.parity = .none
            serialPort?.baudRate = 9600
            serialPort?.delegate = self
        }
    }
    
    // these next 2 functions are not used either... yet...
    func getRecordButton() -> String {
        if self.isRecording {
            return "Stop Recording"
        }
        return "Start Recording"
    }
    
    func record() {
        if self.isRecording {
            self.isRecording = false
            return
        }
        self.isRecording = true
    }
    
    // sends whatever command is entered into the textbox. Currently triggered by a button.
    func sendCommand() {
        if let port = self.serialPort{
            port.send(self.nextCommand.data(using: .utf8)!)
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
