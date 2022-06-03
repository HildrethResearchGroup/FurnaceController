//
//  AppController.swift
//  FurnaceController
//
//  Created by Mines Student on 6/2/22.
//

import Foundation

class AppController: ObservableObject {
    
    var arduino = ArduinoController()
    var graph = GraphController()
    
    @Published var recordButtonLabel: String = "Start Recording"
    @Published var progressTime: Int = 0
    @Published var minutesPerSample = "1"
    
    var stopwatchTimer: Timer?
    var pollingTimer: Timer?
    
    func pollForData() {
        arduino.readTemperature()
        arduino.readArgonFlow()
        arduino.readNitrogenFlow()
        print("polled")
    }
    
    func startOrStopRecord(){
        if(self.recordButtonLabel == "Start Recording"){
            
            let minsPerSamp = Double(self.minutesPerSample)
            
            self.recordButtonLabel = "Stop Recording"
            self.progressTime = 0
            
            stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.progressTime = self.progressTime + 1
            }
            
            pollingTimer = Timer.scheduledTimer(withTimeInterval: minsPerSamp! * 60, repeats: true) { timer in
                self.pollForData()
            }
            
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
