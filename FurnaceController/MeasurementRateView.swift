//
//  MeasurementRateView.swift
//  FurnaceController
//
//  Created by Mines Student on 6/6/22.
//

import SwiftUI

struct MeasurementRateView: View {
    
    @ObservedObject var controller: AppController = AppController.shared
    
    var body: some View {
        VStack {
            
            HStack {
                
                // MARK: set sample rate
                Text("Minutes / Sample:")
                
                TextField("", text: $controller.minutesPerSample).disabled(controller.recording)
            }
        }
    }
    
    
    
    
    
    
    
  /*
    var body: some View {
        HStack {
            Text("Minutes/Sample: ")
            TextField("Minutes / Sample", text: $controller.minutesPerSample)
        }
    }
    
*/
    
}
