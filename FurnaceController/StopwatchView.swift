//
//  StopwatchView.swift
//  FurnaceController
//
//  Created by Mines Student on 6/6/22.
//

import SwiftUI

struct StopWatchView: View {
    @ObservedObject var controller: AppController
    
    init(controller: AppController) {
        self.controller = controller
    }
    
    var body: some View {
        VStack {
            
            Text("\(String(format:"%02d", (controller.progressTime/86400) )):\(String(format:"%02d", (controller.progressTime/3600) )):\(String(format:"%02d",  (controller.progressTime % 3600 / 60) )):\(String(format:"%02d", controller.progressTime % 60))")
                .font(.title)
                .toolbar {
                    ToolbarItem{startStopToolbarButton()}
                    //ToolbarItem{Button(action: controller.startOrStopRecord, label: Image("play"))}
                }
            
            
            
            HStack {
                
                Text("Minutes / Sample: ")
                TextField("Minutes / Sample", text: $controller.minutesPerSample)
                
            }
            
        }
    }
    
    @ViewBuilder
    func startStopToolbarButton() -> some View {
        Button(action: controller.startOrStopRecord) { controller.recording ? Image(systemName: "stop.circle"): Image(systemName:  "play.circle") }
    }
}

