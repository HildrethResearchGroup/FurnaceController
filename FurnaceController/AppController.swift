
import Foundation
import SwiftUI

/// Contains almost all of the backend logic for the FurnaceController app. Contains the timer objects and communicates with ArduinoController, DataController and GraphController.
///
/// This class contains both of the timers that are used in the FurnaceController application: one for displaying on the GUI and the other for determining when the sensors are polled. To poll the sensors, AppController communicates with ArduinoController. The data received is then communicated to GraphController and DataController to update the graph and CSV, respectively. AppController also has the main logic for starting and stopping the data recording.
///
/// AppController is currently a singleton class because there were some issues getting sensor data from the ArduinoController back to AppController after polling. It may be valuable for testing to update AppController with dependency injection instead.
class AppController: ObservableObject {
    
    /// Singleton instance of AppController
    ///
    /// By declaring a static, constant instance of AppController within the AppController class, AppController is made into a singleton. If an init method is created for AppController, it should be set to private
    static let shared = AppController()
    
    /// The interface between the Arduino and the rest of the program
    ///
    /// The ArduinoController contains the logic for polling the Arduino for flowrate and temperature data. 
    var arduino = ArduinoController()
    
    /// The interface between the GraphView application and the FurnaceController application
    ///
    /// The data from polling the sensors needs to be communicated with GraphController in order for the graph in the GUI to be updated with the new data.
    var graph = GraphController()
    
    /// The interface between the computer's filesystem and the rest of the application
    ///
    /// The data from polling the sensors needs to be communicated with DataController in order for that data to be added the the CSV file.
    var dataController: DataController?
    
    /// Indicates whether an experiment is in progress
    ///
    /// This variable indicates the state of the timer object. It is primarily used to determine the format and functionality of the start/stop button. It is also used to determine whether or not certain objects in the GUI are enabled or disabled (some features are disabled while an experiment is in progress).
    @Published var recording: Bool = false
    
    /// The time in seconds for which the experiment has been running
    ///
    /// When the timer is started, this value increases by one every second. This value is used to calculate the exact number of days, hours, minutes, and seconds for which an experiment has been run.
    @Published var progressTime: Int = 0
    
    /// The rate at which the sensors are sampled.
    ///
    /// This value determines how many minutes the program waits before is sends another polling request to the Arduino.
    /// i.e
    /// * One sample occurs every minute - minutesPerSample = 1
    /// * One sample occurs every two minutes - minutesPerSample = 2
    @Published var minutesPerSample = "1"
    
    /// An error message received from the Arduino
    ///
    /// When the Arduino encounters an error, it will determine the appropriate error message to send to the application. That error message is recorded in this variable
    @Published var errorMessage: String = ""
    
    /// Timer used to generate the stopwatch in the GUI
    ///
    /// Determines when to increment `progressTime` which is the value which is used to calculate the days, hours, minutes, and seconds for the GUI's stopwatch
    var stopwatchTimer: Timer?
    
    /// Timer used to determine when to poll the Arduino for data
    ///
    /// Timer to poll every N minutes, input by the user in `minutesPerSample`
    var pollingTimer: Timer?
    
    /// Sends a polling request to the Arduino for temperature and flowrate data
    ///
    /// Uses the ArduinoController commands to send a data polling request to the Arduino. The Arduino will then poll the different sensors and return a data packet to the application.
    func pollForData() {
        arduino.readTemperature()
        arduino.readArgonFlow()
        arduino.readNitrogenFlow()
    }
    
    
    /// Records the data inputted in both a CSV file and the graph displayed in the GUI
    /// - Parameters:
    ///   - temp: The temperature value last received from the Arduino
    ///   - flowAr: The Argon flowrate value last received from the Arduino
    ///   - flowN2: The Nitrogen flowrate value last received from the Arduino
    ///
    ///   Utilizes GraphController and DataController to update the graph in the GUI and the CSV file containing all of the recorded value, respectively.
    func recordData(temp: Double, flowAr: Double, flowN2: Double) {
        // convert the data inputted to a comma seperated string and send it to the CSV file
        let nextLine = String(self.progressTime) + "," + String(temp) + "," + String(flowAr) + "," + String(flowN2)
        dataController!.writeLine(data: nextLine)

        // update the graph in the GUI
        graph.updateData(time: Double(self.progressTime) / 60, temp: temp, flowAr: flowAr, flowN2: flowN2)
    }
    
    /// Starts and stops recording of data
    ///
    /// Starts the timer objects if the data is not being recorded and makes the first polling request to the data. This is also where the sampling rate get adjusted if a value less than 0.1 minutes is entered. If the data is being recorded, then the timers are stopped and the save dialog is displayed when this function is called.
    func startOrStopRecord(){
        // On timer started
        if(self.recording == false){
            if var minsPerSamp = Double(self.minutesPerSample) {
                
                self.recording = true
                self.progressTime = 0              // reset progress timer
                dataController = DataController() // also reset all file data
                graph.resetData()
                
                // Update the sample rate if it was set to a value less than 0.1 minutes
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
                
                // poll for data right away to get immediate data (and not have to wait for timer)
                self.pollForData()
            }
        }
        
        // On timer stopped
        else{
            self.recording = false
            stopwatchTimer?.invalidate()
            pollingTimer?.invalidate()
            
            self.showSavePanel()
        }
    }
    
    /// Displays the savepanel
    ///
    /// A generic save panel is displayed to the user allowing them and moves the saved CSV data to the specified filepath
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
