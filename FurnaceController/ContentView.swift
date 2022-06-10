//  This is a test comment
//  ContentView.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import SwiftUI
import ORSSerial

struct ContentView: View {
    
    @ObservedObject var controller = AppController.shared
    
    var body: some View {
        GeometryReader { geometry in
            HSplitView {
                    
                VStack{
                    
                    InfoView()                                             // title and port status
                        .padding()
                        .frame(alignment: .top)
                    
                    TemperatureView(controller: controller.arduino)                 // temperature data and setting
                        .padding()
                    
                    NitrogenFlowView(controller: controller.arduino)                // nitrogen flowrate data and setting
                        .padding()
                    
                    ArgonFlowView(controller: controller.arduino)           // argon flowrate data and setting
                        .padding()
                    
                    MeasurementRateView(controller: controller)
                        .padding()
                    
                    ErrorView(controller: controller)
                        .padding()
                }
                .frame(minWidth: geometry.size.width * 0.2, maxWidth: geometry.size.width * 0.5, minHeight: geometry.size.height, maxHeight: geometry.size.height)
                
                VStack {
                    
                    StopWatchView(controller: controller)                                   // stopwatch
                        .padding()
                    
                    GraphViewRepresentable(graphController: controller.graph)
                        .padding()     // graph
                    
                }
                .frame(minWidth: geometry.size.width * 0.5, maxWidth: geometry.size.width * 0.8, minHeight: geometry.size.height, maxHeight: geometry.size.height)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

