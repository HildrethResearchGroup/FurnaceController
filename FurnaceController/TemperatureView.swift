//
//  TemperatureView.swift
//  FurnaceController
//


import SwiftUI

/// Subview containing the display of the current temperature, the textfield for updating the temperature, and the button for confirming an update.
///
/// The temperature which is displayed in the text following the "Temperature (ºC):" label exists within ArduinoController.
///
/// A textfield and button were included for updating the temperature. However, since this functionality does not exist yet, these features are disabled.
struct TemperatureView: View {
    
    /// A string that appears within the textfield
    ///
    /// I am not entirely sure how the Property Wrappers of this variable work.
    @State private var temp: String = ""
    
    /// Reference to the ArduinoController object, arduino, that exists in AppController.
    ///
    /// The ArduinoController contains the last measured temperature data which is displayed in this subview.
    @ObservedObject var controller: ArduinoController = AppController.shared.arduino
    
    var body: some View {
        VStack {
            
            HStack {
                // MARK: Temperature Display
                // Displays the temperature measured at the last request in degrees Celcius
                Text("Temperature (ºC):")
                Text(String(controller.lastTemp))
            }.frame(alignment: .leading)

            
            HStack {
                // MARK: Update Temperature
                // Both the textfield and update button for setting a new temperature
                // This is NONFUNCTIONAL at the moment
                TextField("", text: $temp)
                    .disabled(true)
                
                Button("Set Temperature") {
                    
                    // MARK: NONFUNCTIONAL BUTTON
                    
                }.disabled(true)
            }
        }
    }
}
