//
//  AppController.swift
//  FurnaceController
//

import Foundation
import SwiftUI

class AppController: ObservableObject {
    
    static let shared = AppController()
    
    // sub-controllers, used to manipulate data and graphs
    var arduino = ArduinoController()
    var graph = GraphController()
    var dataController = DataController()
    
    var startDate: Date?
    
    // saved data
    @Published var connectionStatus: String = "Not Connected"
    @Published var connectionColor:Color = Color.red
    
    // timer functions
    @Published var recordButtonLabel: String = "Start Recording"
    @Published var recordButtonColor: Color = Color.green
    @Published var progressTime: Int = 0
    @Published var minutesPerSample = "1"
    
    // timers for the stopwatch and data polling
    var stopwatchTimer: Timer?
    var pollingTimer: Timer?
    
    // handles all new data functionality (polling from ardiuino, saving to file, graphing, etc)
    func pollForData() {
        // poll for data from arduino
        arduino.readTemperature()
        arduino.readArgonFlow()
        arduino.readNitrogenFlow()
        
        // save data to the savefile
        //TODO: Move this data to csv conversion into DataController
        let nextLine = String(self.progressTime) + "," + String(arduino.lastTemp) + "," + String(arduino.lastFlowAr) + "," + String(arduino.lastFlowN2)
        dataController.writeLine(data: nextLine)
        
        // TODO: graph that data
        graph.updateData(time: Double(self.progressTime), temp: arduino.lastTemp, flowAr: arduino.lastFlowAr, flowN2: arduino.lastFlowN2)
    }
    
    // starts and stops logic recording
    func startOrStopRecord(){
        if(self.recordButtonLabel == "Start Recording"){
            // TODO: should this also handle RESETTING data? 
            
            // on timer started
            let minsPerSamp = Double(self.minutesPerSample)
            self.recordButtonLabel = "Stop Recording"
            self.recordButtonColor = Color.red
            
            self.progressTime = 0 // reset progress timer
            
            // initialize the timers
            stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.progressTime = self.progressTime + 1
            }
            
            pollingTimer = Timer.scheduledTimer(withTimeInterval: minsPerSamp! * 60, repeats: true) { timer in
                self.pollForData()
            }
            // set startTime
            self.startDate = Date.now
            
            // poll for data right away to get imediate data (and not have to wait for timer)
            self.pollForData()
        }
        else{
            self.recordButtonLabel = "Start Recording"
            stopwatchTimer?.invalidate()
            pollingTimer?.invalidate()
            
            self.showSavePanel()
        }
    }
    
    // TODO: Implement savepanel function
    func showSavePanel(){
        let panel = NSSavePanel()
        panel.nameFieldLabel = "Save data as:"
        panel.nameFieldStringValue = "data.csv"
        panel.canCreateDirectories = true
        panel.begin { response in
            if response == NSApplication.ModalResponse.OK, let panelURL = panel.url {
                self.dataController.saveData(url: panelURL)
            }
        }
    }
}
