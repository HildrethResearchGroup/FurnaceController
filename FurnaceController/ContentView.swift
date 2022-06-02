//  This is a test comment
//  ContentView.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import SwiftUI
import ORSSerial

struct StopwatchView: View {
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var status: String = "Start Recording"
    @State var progressTime: Int = 0
    
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
            .onReceive(timer) {_ in
                progressTime = progressTime + 1
            }
        
        
    }
    
    
    
    func startOrStopRecord() -> Void {
        print("\(status)")
        
        self.status = "foo"
        print("Got here")
        
        if(status == "Start Recording"){
            status = "Stop Recording"
            
            print("1")
            print("\(status)")
            

            //StopwatchView()
            
        }
        else{
            status = "Start Recording"
            //self.showSavePanel()
            print("2")
        }

    }
    
}




struct ContentView: View {
    @StateObject var controller = ArduinoController()
    @ObservedObject var graphController = GraphController()
    @State var time = StopwatchView()
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
                
                Button(time.status, action: time.startOrStopRecord)
                
                
                //Label("Lightning", systemImage: "bolt.fill")
                //StopwatchView()
                
                
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

