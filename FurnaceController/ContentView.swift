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
    @ObservedObject var watch = StopWatch()
    
    var body: some View {
        GeometryReader { geo in
            HSplitView{
                
                VStack {
                    GraphViewRepresentable(graphController: controller.graph).padding()
                    Button(watch.status, action: watch.startOrStopRecord)
                    Text("\(String(format:"%02d", (watch.progressTime/3600) )):\(String(format:"%02d",  (watch.progressTime % 3600 / 60) )):\(String(format:"%02d", watch.progressTime % 60))").font(.system(size: 25, design: .serif))
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

