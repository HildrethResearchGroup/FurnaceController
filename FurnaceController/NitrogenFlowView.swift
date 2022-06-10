//
//  NitrogenFlowView.swift
//  FurnaceController
//
//  Created by Mines Student on 6/6/22.
//

import SwiftUI

struct NitrogenFlowView: View {
    
    @State private var flow: String = ""         // last measured flowrate
    
    @ObservedObject var controller: ArduinoController
    
    init(controller: ArduinoController) {
        self.controller = controller
    }
    
    var body: some View {
        VStack {
            
            HStack {
                
                // MARK: Display Flowrate
                // Displays the flowrate measured at the last request in ...
                Text("Nitrogen Flowrate (L/min)")
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
                            if flowNum > 1 {
                                flowNum = 1
                            }
                            flow = String(flowNum)
                            controller.setNitrogenFlow(flow: flowNum)
                        }
                    }
                
                Button ("Set Flowrate"){
                    
                    if var flowNum = Double(flow) {
                        if flowNum < 0 {
                            flowNum = 0
                        }
                        if flowNum > 1 {
                            flowNum = 1
                        }
                        flow = String(flowNum)
                        controller.setNitrogenFlow(flow: flowNum)
                    }
                }.disabled(!controller.statusOK)
            }
        }
    }
}
