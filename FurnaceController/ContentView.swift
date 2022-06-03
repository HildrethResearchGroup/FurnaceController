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
        GeometryReader { geo in
            HSplitView{
                
                VStack {
                    GraphViewRepresentable(graphController: controller.graph).padding()
                    
                    Button(controller.recordButtonLabel, action: controller.startOrStopRecord)
                    Text("\(String(format:"%02d", (controller.progressTime/3600) )):\(String(format:"%02d",  (controller.progressTime % 3600 / 60) )):\(String(format:"%02d", controller.progressTime % 60))").font(.system(size: 25, design: .serif))
                    HStack {
                        Text("Minutes / Sample: ")
                        TextField("Minutes / Sample", text: $controller.minutesPerSample)
                    }
                    Button("update graph") {
                        controller.graph.updateData()
                    }
                    
                }
                
                VStack{
                    InfoView(controller: controller.arduino)
                        .padding()
                    TemperatureView(controller: controller)
                        .padding()
                    ArgonFlowView(controller: controller)
                        .padding()
                    NitrogenFlowView(controller: controller)
                        .padding()
                }.frame(minWidth: geo.size.width * 0.2, idealWidth: geo.size.width * 0.6, maxWidth: geo.size.width * 0.6)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

