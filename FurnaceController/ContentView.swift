//  This is a test comment
//  ContentView.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import SwiftUI
import ORSSerial

struct ContentView: View {
    
    /// Reference to the singleton instance of AppController.
    ///
    /// 
    @ObservedObject var controller = AppController.shared
    
    var body: some View {
        GeometryReader { geometry in
            HSplitView {
                    
                VStack{
                    
                    InfoView()
                        .padding()
                        .frame(alignment: .top)
                    
                    TemperatureView()
                        .padding()
                    
                    NitrogenFlowView()
                        .padding()
                    
                    ArgonFlowView()
                        .padding()
                    
                    MeasurementRateView()
                        .padding()
                    
                    ErrorView()
                        .padding()
                }
                .frame(minWidth: geometry.size.width * 0.2, maxWidth: geometry.size.width * 0.5, minHeight: geometry.size.height, maxHeight: geometry.size.height)
                
                VStack {
                    
                    StopWatchView()
                        .padding()
                    
                    GraphViewRepresentable(graphController: controller.graph)
                        .padding()
                    
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

