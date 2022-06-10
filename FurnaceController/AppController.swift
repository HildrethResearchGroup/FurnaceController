//
//  AppController.swift
//  FurnaceController
//

import Foundation
import SwiftUI

/**
 AppController is the brains behind the furnace controller app. It handles both timers used, tells the arduino when to poll for data, handles graphing and saving the sensor data, and has the main logic for starting and stopping recording. It is a singleton class because we were having some issues getting sensor data from the ArduinoController back to the AppController after polling. 
 */

class AppController: ObservableObject {
    
    static let shared = AppController()
    
    /// instance of the arduino controller
    var arduino = ArduinoController()
    /// instance of the graph controller
    var graph = GraphController()
    /// instance of the data controller
    var dataController: DataController?
    
    /// determines whether the application is currently recording data
    @Published var recording: Bool = false
    @Published var progressTime: Int = 0
    @Published var minutesPerSample = "1"
    
    /// if the arduino sends an error, the error is put into this string and displayed on the UI
    @Published var errorMessage: String = ""
    
    /// timer to increment `progressTime`, used to keep track of how much time has passed in the experiment
    var stopwatchTimer: Timer?
    /// timer to poll every N minutes, input by the user in `minutesPerSample`
    var pollingTimer: Timer?
    
    /// handles all new data functionality (polling from ardiuino, saving to file, graphing, etc)
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
    
    /// starts and stops recording logic
    func startOrStopRecord(){
        if(self.recording == false){
            // TODO: should this also handle RESETTING data?
            if var minsPerSamp = Double(self.minutesPerSample) {
                
                // on timer started
                self.recording = true
                self.progressTime = 0 // reset progress timer
                dataController = DataController() // also reset all file data
                graph.resetData()
                
                if minsPerSamp < 0.1 {
                    minsPerSamp = 0.1
                    self.minutesPerSample = "0.1"
                }
                
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
    
    /// displays the savepanel and moves the saved CSV data to the specified filepath
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
