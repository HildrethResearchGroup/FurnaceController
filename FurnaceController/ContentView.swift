//
//  ContentView.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import SwiftUI
import ORSSerial


struct StopwatchView: View {
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let status = "Start Recording"
    @State var progressTime = 0
    
    var hours: Int {
      progressTime / 3600
    }

    var minutes: Int {
      (progressTime % 3600) / 60
    }

    var seconds: Int {
      progressTime % 60
    }
    
    
    
    var body: some View {
        let stringHours = String(format: "%02d", hours)
        let stringMinutes = String(format: "%02d", minutes)
        let stringSeconds = String(format: "%02d", seconds)
        Text("\(stringHours):\(stringMinutes):\(stringSeconds)").font(.system(size: 25, design: .serif))
        
        
        
    }
    
    
    
    func startOrStopRecord() -> Void {
        
        if(status == "Start Recording"){
            status = "Stop Recording"
            
            
            
           // .onReceive(timer) { _ in
            //    progressTime = progressTime + 1
           //     }
            
            //StopwatchView()
            
        }
        else{
            status = "Start Recording"
            //self.showSavePanel()
        }

    }
    
}




struct ContentView: View {
    var status = "Start Recording"
    @StateObject var controller = ArduinoController()
    @ObservedObject var graphController = GraphController()
    @State private var start: String = ""
    private func Start() -> Void {
        print(start)
    }
    
    
    
    var body: some View {
        
        HSplitView{
            
            VStack {
                
                GraphViewRepresentable(graphController: graphController)
                    .frame(minWidth: 800, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
            
                Button(graphController.status, action: graphController.startOrStopRecord)
                
                
                //Label("Lightning", systemImage: "bolt.fill")
                //StopwatchView()
                let time = StopwatchView()
                
                time
                
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

