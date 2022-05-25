//
//  DataModel.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/21/21.
//

import Foundation
import SwiftUI

class DataModel {
    var xData = [1.0, 2.0, 3.0, 4.0, 5.0]
    var yData = [2.0, -4.0, 6.0, -8.0, 10.0]
    
    func update() {
        for (index, value) in yData.enumerated() {
            yData[index] = value * -2
        }
        let x_start = xData.first ?? 0.0
        let x_last = xData.last ?? 0.0
        xData.insert(x_start - 1, at: 0)
        yData.insert(1.0, at: 0)
        xData.append(x_last + 1)
        yData.append(1.0)
        
    }
}
