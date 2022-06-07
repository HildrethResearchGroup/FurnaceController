//
//  NitrogenFlowView.swift
//  FurnaceController
//
//  Created by Mines Student on 6/6/22.
//

import SwiftUI

struct NitrogenFlowView: View {
    
    @State private var flow: String = ""         // last measured flowrate
    
    var controller: AppController?
    
    init(controller: AppController) {
        self.controller = controller
    }
    
    var body: some View {
        VStack {
            
            HStack {
                
                // MARK: Display Flowrate
                // Displays the flowrate measured at the last request in ...
                Text("Nitrogen Flowrate (L/min)")
                Text(String((controller?.arduino.lastFlowAr)!))
                
            }

            HStack {
                
                // MARK: Update Flowrate
                // Both the textfield and update button for setting a new flowrate
                TextField("", text: $flow)
                Button ("Set Flowrate"){
                    
                    // TODO: Send set setpoint command to Arduino
                    
                }
            }
        }
    }
}
