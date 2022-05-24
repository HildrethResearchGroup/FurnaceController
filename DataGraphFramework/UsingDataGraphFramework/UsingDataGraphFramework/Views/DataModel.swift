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
    }
}
