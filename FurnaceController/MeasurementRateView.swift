//


import SwiftUI

/// Subview containing the textfield for updating the sampling rate
///
/// The textfield can be used to update the sampling rate at which the application polls the sensors. The value is read from the textfield when an experiment is started and the textfield will be disabled.
struct MeasurementRateView: View {
    
    /// Reference to the singleton instance of AppController.
    ///
    /// AppController contains the value being used for the sampling rate.
    @ObservedObject var controller: AppController = AppController.shared
    
    var body: some View {
        VStack {
            
            HStack {
                
                // MARK: set sample rate
                Text("Minutes / Sample:")
                
                TextField("", text: $controller.minutesPerSample).disabled(controller.recording)
            }
        }
    }
    
    
    
    
    
    
    
  /*
    var body: some View {
        HStack {
            Text("Minutes/Sample: ")
            TextField("Minutes / Sample", text: $controller.minutesPerSample)
        }
    }
    
*/
    
}
