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
    var dataController: DataController?
    
    var startDate: Date?
    
    // timer functions
    @Published var recording: Bool = false
    @Published var progressTime: Int = 0
    @Published var minutesPerSample = "1"
    
    @Published var errorMessage: String = ""
    
    // timers for the stopwatch and data polling
    var stopwatchTimer: Timer?
    var pollingTimer: Timer?
    
    // handles all new data functionality (polling from ardiuino, saving to file, graphing, etc)
    func pollForData() {
        // poll for data from arduino
        arduino.readTemperature()
        arduino.readArgonFlow()
        arduino.readNitrogenFlow()
    }
    
    func recordData(temp: Double, flowAr: Double, flowN2: Double) {
        // save data to the savefile
        //TODO: Move this data to csv conversion into DataController
        let nextLine = String(self.progressTime) + "," + String(temp) + "," + String(flowAr) + "," + String(flowN2)
        dataController!.writeLine(data: nextLine)
        
        // TODO: graph that data
        graph.updateData(time: Double(self.progressTime) / 60, temp: temp, flowAr: flowAr, flowN2: flowN2)
    }
    
    // starts and stops logic recording
    func startOrStopRecord(){
        if(self.recording == false){
            // TODO: should this also handle RESETTING data?
            if let minsPerSamp = Double(self.minutesPerSample) {
                
                // on timer started
                self.recording = true
                self.progressTime = 0 // reset progress timer
                self.startDate = Date.now // set startTime
                dataController = DataController() // also reset all file data
                graph.resetData()
                
                // initialize the timers
                stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    self.progressTime = self.progressTime + 1
                }
                
                pollingTimer = Timer.scheduledTimer(withTimeInterval: minsPerSamp * 60, repeats: true) { timer in
                    self.pollForData()
                }
                
                // poll for data right away to get imediate data (and not have to wait for timer)
                self.pollForData()
            }
        }
        else{
            self.recording = false
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
                self.dataController!.saveData(url: panelURL)
            }
        }
    }
}
