//
//  ArduinoController.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import Foundation
import ORSSerial

class ArduinoController: ObservableObject {
    
    @Published var isRecording = false
    
    var serialPortManager: ORSSerialPortManager = ORSSerialPortManager.shared()
    
    var lastTemp = 0
    var lastFlowN2 = 0
    var lastFlowAr = 0
    
    var tempUnit = "C"
    var flowUnit = "L/min"
    
    @Published var nextPortState = "Open"
    
    @Published var serialPort: ORSSerialPort? {
        didSet {
            serialPort?.parity = .none
            serialPort?.baudRate = 9600
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
        print("Sending \"Hello, World!\"")
        self.serialPort?.send("Hello, World!".data(using: .utf8)!)
    }
    
    func openOrClosePort() {
        if let port = self.serialPort {
            if (port.isOpen) {
                port.close()
                nextPortState = "Open"
            } else {
                port.open()
                nextPortState = "Close"
            }
        }
    }
}
