//  This is a test comment
//  ContentView.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import SwiftUI
import ORSSerial

struct ContentView: View {
    
    var controller = AppController()
    
    var body: some View {
        HSplitView{
            VStack {
                GraphViewRepresentable(graphController: controller.graph)
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
            }
            VStack{
                InfoView()
                
                TemperatureView(controller: controller)
                    .padding()
                    .frame(minWidth: 200, maxWidth: 300, minHeight: 100, maxHeight: 200)
                GasFlowView()
                    .padding()
                    .frame(minWidth: 200, maxWidth: 300, minHeight: 100, maxHeight: 200)
                GasFlowView()
                    .padding()
                    .frame(minWidth: 200, maxWidth: 300, minHeight: 100, maxHeight: 200)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

