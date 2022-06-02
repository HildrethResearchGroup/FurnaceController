//
//  AppController.swift
//  FurnaceController
//
//  Created by Mines Student on 6/2/22.
//

import Foundation

class AppController {
    var arduino = ArduinoController()
    var graph = GraphController()
    
    func pollForData() {
        arduino.readTemperature()
        arduino.readArgonFlow()
        arduino.readNitrogenFlow()
    }
    
    
    
}
