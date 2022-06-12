//
//  TemperatureView.swift
//  FurnaceController
//


import SwiftUI

/*
 * TemperatureView contains the display of the current temperature, the TextField for updating the temperature,
 * and the button for confirming an update
 */
struct TemperatureView: View {
    
    @State private var temp: String = ""
    
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
