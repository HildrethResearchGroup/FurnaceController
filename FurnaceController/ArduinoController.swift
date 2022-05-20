//
//  ArduinoController.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import Foundation
import ORSSerial

class ArduinoController: NSObject, ObservableObject, ORSSerialPortDelegate {
    
    enum RequestType: Int {
        case readData = 1
    }
    
    var serialPortManager: ORSSerialPortManager = ORSSerialPortManager.shared()
    
    var lastTemp = 0
    var lastFlowN2 = 0
    var lastFlowAr = 0
    
    var tempUnit = "C"
    var flowUnit = "L/min"
    
    @Published var nextPortState = "Open"
    @Published var nextCommand = ""
    @Published var isRecording = false
    
    @Published var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            serialPort?.parity = .none
            serialPort?.baudRate = 9600
            serialPort?.delegate = self
        }
    }
    
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
    
    func sendCommand() {
        if let port = self.serialPort{
            print("Sending \"\(self.nextCommand)\" to \(port.path) which is open (\(port.isOpen))")
            port.send(self.nextCommand.data(using: .utf8)!)
        }
    }
    
    func openOrClosePort() {
        if let port = self.serialPort {
            if (port.isOpen) {
                port.close()
            } else {
                port.open()
            }
        }
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data, to request: ORSSerialRequest) {
        let string = String(data: data, encoding: .utf8)
        print("Got \(string) from the serial port! POG!")
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        print(String(data: data, encoding: .utf8))
    }
    
    func serialPort(_ serialPort: ORSSerialPort, requestDidTimeout response: ORSSerialRequest){
        print("timed out")
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("SerialPort \(serialPort) encountered an error: \(error)")
    }
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        print("Port was removed")
    }
    
    func testCommand(){
        let command = "!!testing;;".data(using: String.Encoding.ascii)!
        let responseDescriptor = ORSSerialPacketDescriptor(prefixString: "!", suffixString: ";", maximumPacketLength: 100, userInfo: nil)
        let request = ORSSerialRequest(dataToSend: command,
            userInfo: nil,
            timeoutInterval: 2,
            responseDescriptor: responseDescriptor)
        serialPort?.send(request)
        print("request sent")
    }
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        print("Port \(serialPort.path) is open")
        self.nextPortState = "Close"
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        print("Port \(serialPort.path) is open")
        self.nextPortState = "Open"
    }
}
