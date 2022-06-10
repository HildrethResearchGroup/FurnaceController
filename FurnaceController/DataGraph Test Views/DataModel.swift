//
//  DataModel.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/21/21.
//

import Foundation
import SwiftUI

class DataModel {
    var time: [Double] = []
    var temp: [Double] = []
    var flowAr: [Double] = []
    var flowN2: [Double] = []
    
    func update(time: Double, temp: Double, flowAr: Double, flowN2: Double) {
        self.time.append(time)
        self.temp.append(temp)
        self.flowAr.append(flowAr)
        self.flowN2.append(flowN2)
    }
}
