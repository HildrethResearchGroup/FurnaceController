//
//  StopwatchView.swift
//  FurnaceController
//
//  Created by Mines Student on 6/6/22.
//

import SwiftUI

struct StopWatchView: View {
    
    @ObservedObject var controller: AppController
    @ObservedObject var arduino: ArduinoController
    
    init(controller: AppController) {
        self.controller = controller
        self.arduino = controller.arduino
    }
    
    var body: some View {
        VStack {
            
            Text("\(String(format:"%02d", (controller.progressTime/86400) )):\(String(format:"%02d", (controller.progressTime/3600) )):\(String(format:"%02d",  (controller.progressTime % 3600 / 60) )):\(String(format:"%02d", controller.progressTime % 60))")
                .font(.title)
                .toolbar {
                    ToolbarItem{ startStopToolbarButton() }
                }
        }
    }
    
    @ViewBuilder
    func startStopToolbarButton() -> some View {
        Button(action: controller.startOrStopRecord) { controller.recording ? Image(systemName: "stop.fill"): Image(systemName:  "play.fill") }
            .disabled(!arduino.statusOK)
    }
}
