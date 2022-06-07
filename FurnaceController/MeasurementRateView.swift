//
//  MeasurementRateView.swift
//  FurnaceController
//
//  Created by Mines Student on 6/6/22.
//

import SwiftUI

struct MeasurementRateView: View {
    
    @ObservedObject var controller: AppController
    @State private var rate: String = ""
    init(controller: AppController) {
        self.controller = controller
    }
    
    
    
    var body: some View {
        VStack {
            
            HStack {
                
                // MARK: Display Flowrate
                // Displays the flowrate measured at the last request in ...
                Text("Sampling Rate(mins/sample):")
                Text(String(controller.minutesPerSample))
                
            }

            HStack {
                
                // MARK: Update Flowrate
                // Both the textfield and update button for setting a new flowrate
                TextField("", text: $controller.minutesPerSample)
                Button ("Set Flowrate"){
                    
                    // TODO: alert user for invalid inputs
                    if var sampRate = Double(rate) {
                        if sampRate < 0 {
                            sampRate = 0
                        }
                        if sampRate > 1 {
                            sampRate = 0
                        }
                        
                        
                        
                        //sampling rate code for setting correct val
                        
                    }
                }
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
