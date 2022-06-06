//  This is a test comment
//  ContentView.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import SwiftUI
import ORSSerial

struct ContentView: View {
    
    @ObservedObject var controller = AppController()
    
    var body: some View {
        HSplitView {
            
            VStack {
                
                GraphViewRepresentable(graphController: controller.graph).padding()     // graph
                
                StopWatchView(controller: controller).padding()                         // stopwatch
                
                /*
                Button("update graph") {
                    controller.graph.updateData()
                 */
                
            }
                
            
            VStack{
                
                InfoView(controller: controller.arduino)                // title and port status
                    .padding()
                    .frame(alignment: .top)
                
                TemperatureView(controller: controller)                 // temperature data and setting
                    .padding()
                
                ArgonFlowView(controller: controller)                   // argon flowrate data and setting
                    .padding()
                
                NitrogenFlowView(controller: controller)                // nitrogen flowrate data and setting
                    .padding()
                
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

