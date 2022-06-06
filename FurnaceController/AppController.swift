//
//  AppController.swift
//  FurnaceController
//
//  Created by Mines Student on 6/2/22.
//

import Foundation

class AppController: ObservableObject {
    
    // sub-controllers, used to manipulate data and graphs
    var arduino = ArduinoController()
    var graph = GraphController()
    
    // saved data
    @Published var connectionStatus: String = "Not Connected"
    
    // timer functions
    @Published var recordButtonLabel: String = "Start Recording"
    @Published var progressTime: Int = 0
    @Published var minutesPerSample = "1"
    
    // timers for the stopwatch and data polling
    var stopwatchTimer: Timer?
    var pollingTimer: Timer?
    
    // tell arduino to get data
    func pollForData() {
        arduino.readTemperature()
        arduino.readArgonFlow()
        arduino.readNitrogenFlow()
    }
    
    // starts and stops logic recording
    func startOrStopRecord(){
        if(self.recordButtonLabel == "Start Recording"){
            
            let minsPerSamp = Double(self.minutesPerSample)
            self.recordButtonLabel = "Stop Recording"
            
            self.progressTime = 0 // reset progress timer
            
            // initialize the timers
            stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.progressTime = self.progressTime + 1
            }
            
            pollingTimer = Timer.scheduledTimer(withTimeInterval: minsPerSamp! * 60, repeats: true) { timer in
                self.pollForData()
            }
            
            // poll for data right away to get imediate data (and not have to wait for timer)
            self.pollForData()
        }
        else{
            self.recordButtonLabel = "Start Recording"
            //self.showSavePanel()
            stopwatchTimer?.invalidate()
            pollingTimer?.invalidate()
        }
    }
    
}
