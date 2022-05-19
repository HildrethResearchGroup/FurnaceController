//
//  CurrentReadingView.swift
//  FurnaceController
//
//  Created by Mines Student on 5/18/22.
//

import Foundation
import SwiftUI

struct CurrentReadingView: View {
    
    var controller: ArduinoController
    
    
    init(controller: ArduinoController){
        self.controller = controller
    }
    
    // this view is about 200 pixels wide
    var body: some View {
        HStack{
            VStack (alignment: .trailing){
                Text("Temperature: ")
                Text("Nitrogen Flow Rate: ")
                Text("Argon Flow Rate: ")
            }
            VStack (alignment: .leading){
                Text("\(controller.lastTemp)º\(controller.tempUnit)")
                Text("\(controller.lastFlowN2) \(controller.flowUnit)")
                Text("\(controller.lastFlowAr) \(controller.flowUnit)")
            }
        }
    }
}
