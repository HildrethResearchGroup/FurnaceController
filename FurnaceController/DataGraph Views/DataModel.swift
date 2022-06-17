//
//  DataModel.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/21/21.
//

import Foundation
import SwiftUI

/// Contains all of the values measured during an experiment.
///
/// Each of the values that are being measured in the experiment are recorded in their own arrays. Additionally, there is a function for appending a new set of data to the corresponding data arrays.
class DataModel {
    
    /// Time measurement data
    var time: [Double] = []
    
    /// Temperature measurement data
    var temp: [Double] = []
    
    /// Argon flowrate data
    var flowAr: [Double] = []
    
    /// Nitrogen flowrate data
    var flowN2: [Double] = []
    
    /// Update all of the data arrays for time, temperature, and flowrate
    func update(time: Double, temp: Double, flowAr: Double, flowN2: Double) {
        self.time.append(time)
        self.temp.append(temp)
        self.flowAr.append(flowAr)
        self.flowN2.append(flowN2)
    }
}
