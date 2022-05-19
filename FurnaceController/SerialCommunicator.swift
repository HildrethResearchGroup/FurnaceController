//
//  SerialCommunicator.swift
//  FurnaceController
//
//  Created by Mines Student on 5/18/22.
//

import Foundation
import ORSSerial

class SerialCommunicator: NSObject, ORSSerialPortDelegate {
    
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        let string = String(data: data, encoding: .utf8)
        print("Got \(string ?? "nothing") from the serial port!")
    }
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        print("Port was removed")
    }
}
