//  This is a test comment
//  ContentView.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import SwiftUI
import ORSSerial






struct ContentView: View {
    @StateObject var controller = ArduinoController()
    @StateObject var graphController = GraphController()
    @StateObject var watch = StopWatch()

    @State private var start: String = ""
    
    private func Start() -> Void {
        print(start)
    }
    

    var body: some View {
        
        HSplitView{
            
            VStack {
                
                GraphViewRepresentable(graphController: graphController)
                    .frame(minWidth: 800, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
            
//                let time: StopwatchView = StopwatchView()
                
                Button(watch.status, action: watch.startOrStopRecord)

                //Label("Lightning", systemImage: "bolt.fill")
                //StopwatchView()
//                StopWatch.StopwatchView(stopWatch: watch)
                Text("\(String(format:"%02d", (watch.progressTime/3600) )):\(String(format:"%02d",  (watch.progressTime % 3600 / 60) )):\(String(format:"%02d", watch.progressTime % 60))").font(.system(size: 25, design: .serif))
            }
            ControlView()
            
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

