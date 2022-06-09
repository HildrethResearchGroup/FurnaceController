//
//  GraphController.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/21/21.
//

import Foundation
import SwiftUI

class GraphController: ObservableObject {
    @Published var graph: DGController?
    
    private var data = DataModel()
    
    init() {
        if graph == nil {
            graph = DGController(fileInBundle: "Basic Script")
        }
    }
    
    func updateData(time: Double, temp: Double, flowAr: Double, flowN2: Double) {
        data.update(time: time, temp: temp, flowAr: flowAr, flowN2: flowN2)
        graph?.dataColumn(at: 1).setDataWith(data.time)
        graph?.dataColumn(at: 2).setDataWith(data.temp)
        graph?.dataColumn(at: 3).setDataWith(data.flowAr)
        graph?.dataColumn(at: 4).setDataWith(data.flowN2)
        
        
    }
    
    func resetData() {
        data = DataModel()
    }
}

extension DGDataColumn {
    func setDataWith(_ values: [Double]) {
        self.setDataFrom(values.map( {String($0)} ))
    }
}
