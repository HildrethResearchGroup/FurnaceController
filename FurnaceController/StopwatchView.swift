
import SwiftUI

/// Subview containing the experiment runtime timer and the start/stop recording button.
///
/// The stopwatch time is generated by using the experiment runtime in seconds that exists within AppController. This value is translated into days, hours, and minutes by using the modulo operator. The timer may drift by about 0.01 seconds each time it is called, which is every second in this case.
///
/// The start/stop button exists as a toolbar item and uses AppController's startOrStopRecord function. When the timer is not running, this button will appear as a filled play button. On the other hand, if the timer is running, it will appear as a filled stop button. When the timer is stopped, the save dialog will appear.

struct StopWatchView: View {
    
    /// Reference to the singleton instance of AppController.
    ///
    /// AppController contains the experiment runtime. It also contains the ArduinoController object which is being used to interface with the Arduino.
    @ObservedObject var controller: AppController = AppController.shared
    
    /// Reference to the ArduinoController object, arduino, that exists in AppController.
    ///
    /// The ArduinoController contains the connection status of the Arduino. The start experiment button is disabled when the connection status is bad.
    @ObservedObject var arduino: ArduinoController = AppController.shared.arduino
    
    var body: some View {
        VStack {
            
            // MARK: Stopwatch
            Text("\(String(format:"%02d", (controller.progressTime/86400) )):\(String(format:"%02d", (controller.progressTime/3600) )):\(String(format:"%02d",  (controller.progressTime % 3600 / 60) )):\(String(format:"%02d", controller.progressTime % 60))")
                .font(.title)
                .toolbar {
                    ToolbarItem{ startStopToolbarButton() }
                }
        }
    }
    
    @ViewBuilder
    /// Generates the start/stop button
    /// - Returns: A functional start/stop button
    ///
    /// Generates a button with the action of calling AppController's startOrStopRecord function. Uses a ternary operator to determine whether the button should use the stop.fill image or the play.fill image. This button will also be disabled if the connection status of the application with the Arduino and sensors is bad.
    func startStopToolbarButton() -> some View {
        Button(action: controller.startOrStopRecord) { controller.recording ? Image(systemName: "stop.fill"): Image(systemName:  "play.fill") }
            .disabled(!arduino.statusOK)
    }
}

