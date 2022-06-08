//
//  ArgonFlowView.swift
//  FurnaceController
//
//  Created by Mines Student on 6/6/22.
//

import SwiftUI

/*
 * ArgonFlowView contains the display of the current flowrate of Argon, the TextField for updating the
 * flowrate, and the button for confirming an update
 */
struct ArgonFlowView: View {
    
    @State private var flow: String = ""               // last measured flowrate
    
    @ObservedObject var controller: ArduinoController
    
    init(controller: ArduinoController) {
        self.controller = controller
    }
    
    var body: some View {
        VStack {
             
            HStack {
                
                // MARK: Display Flowrate
                // Displays the flowrate measured at the last request in ...
                Text("Argon Flowrate (L/min)")
                Text(String(controller.lastFlowAr))
                
            }

            HStack {
                
                // MARK: Update Flowrate
                // Both the textfield and update button for setting a new flowrate
                
                TextField("", text: $flow)
                    .disabled(!controller.statusOK)
                
                Button ("Set Flowrate") {
                    
                    //TODO: Add alerts for invalid inputs
                    if let flowNum = Double(flow) {
                        if flowNum >= 0 && flowNum <= 1 {
                            controller.setArgonFlow(flow: flowNum)
                        }
                    }
                    
                }.disabled(!controller.statusOK)
            }
        }
    }
}

