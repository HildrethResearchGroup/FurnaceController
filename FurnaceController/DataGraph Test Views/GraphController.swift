//
//  GraphController.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/21/21.
//

import Foundation
import SwiftUI

class GraphController: ObservableObject {
    @Published var tempGraph: DGController?
    @Published var flowGraph: DGController?
    
    private var data = DataModel()
    
    init() {
        if tempGraph == nil {
            tempGraph = DGController(fileInBundle: "Basic Script")
        }
        if flowGraph == nil {
            flowGraph = DGController(fileInBundle: "Basic Script")
        }
    }
    
    func updateData(time: Double, temp: Double, flowAr: Double, flowN2: Double) {
        data.update(time: time, temp: temp, flowAr: flowAr, flowN2: flowN2)
        tempGraph?.dataColumn(at: 1).setDataWith(data.time)
        tempGraph?.dataColumn(at: 2).setDataWith(data.temp)
        
        
    }
}

extension DGDataColumn {
    func setDataWith(_ values: [Double]) {
        self.setDataFrom(values.map( {String($0)} ))
    }
}
