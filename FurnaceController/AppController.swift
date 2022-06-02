//
//  AppController.swift
//  FurnaceController
//
//  Created by Mines Student on 5/27/22.
//

import Foundation

class AppController {
    
    let arduino = ArduinoController()
    
    var timer: Timer?
    var isRecording = false
    
    func startOrStopRecording() {
        if isRecording {
            // stop recording, open save dialogue, and save file
        }
        else {
            // start the timer, collect data, 
        }
    }
    
    func collectSensorData() {
        arduino.recordTime()
        arduino.readTemperature()
        arduino.readArgonFlow()
        arduino.readNitrogenFlow()
    }
}
