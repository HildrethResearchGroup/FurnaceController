
import SwiftUI

/// Subview containing the display of the current Argon flowrate, the textfield for updating the Argon flowrate, and the button for confirming an update.
///
/// The Argon flowrate which is displayed in the text following the "Argon Flowrate (L/min)" label exists within ArduinoController.
///
/// The textfield and button initiate the sending of a command to the Arduino, through the ArduinoController, which will update the Argon flow meter's flowrate according to the value entered by the user. If the value entered is less than the minimum flowrate, it will be rounded up to the minimum flowrate. If the value entered is greater than the maximum flowrate, it will be rounded down to the maximum flowrate. The textfield and button are disabled if the connection status of the application with the Arduino and sensors is bad.
struct ArgonFlowView: View {
    
    /// A string that appears within the textfield
    ///
    /// I am not entirely sure how the Property Wrappers of this variable work.
    @State private var flow: String = ""               // last measured flowrate
    
    /// Reference to the ArduinoController object, arduino, that exists in AppController.
    ///
    /// The ArduinoController contains the last measured Argon flowrate data which is displayed in this subview. It also contains the functionality for sending commands to the Arduino which update the Argon flowrate.
    @ObservedObject var controller: ArduinoController = AppController.shared.arduino
    
    var body: some View {
        VStack {
             
            HStack {
                
                // MARK: Display Flowrate
                // Displays the flowrate measured at the last request in L/min
                Text("Argon Flowrate (L/min)")
                Text(String(controller.lastFlowAr))
                
            }

            HStack {
                
                // MARK: Update Flowrate
                // Both the textfield and update button for setting a new flowrate
                
                TextField("", text: $flow)
                    .disabled(!controller.statusOK)
                    .onSubmit {
                        if var flowNum = Double(flow) {
                            if flowNum < 0 {
                                flowNum = 0
                            }
                            if flowNum > controller.MAX_FLOWRATE {
                                flowNum = controller.MAX_FLOWRATE
                            }
                            flow = String(flowNum)
                            controller.setArgonFlow(flow: flowNum)
                        }
                    }
                
                Button ("Set Flowrate") {
                    
                    if var flowNum = Double(flow) {
                        if flowNum < 0 {
                            flowNum = 0
                        }
                        if flowNum > controller.MAX_FLOWRATE {
                            flowNum = controller.MAX_FLOWRATE
                        }
                        flow = String(flowNum)
                        controller.setArgonFlow(flow: flowNum)
                    }
                    
                }.disabled(!controller.statusOK)
            }
        }
    }
}

