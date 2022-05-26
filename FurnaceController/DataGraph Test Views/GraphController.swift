//
//  GraphController.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/21/21.
//

import Foundation
import SwiftUI

class GraphController: ObservableObject {
    @Published var dgController: DGController?
    private let valueString = "value"
    private var data = DataModel()
    
    @Published var adjustableValue = 1.0 {
        didSet {
            let parameter = dgController?.parameter(withName: valueString)
            parameter?.setValue(String(adjustableValue))
            //print("newParameter = \(parameter)")
        }
    }
    
    var computedValue: Double {
        get {return adjustableValue*2}
    }
    
    
    init() {
        if dgController == nil {
            dgController = DGController(fileInBundle: "Basic Script")
        }
    }
    
    func updateData() {
        data.update()
        dgController?.dataColumn(at: 1).setDataWith(data.xData)
        dgController?.dataColumn(at: 2).setDataWith(data.yData)
    }
    
    
    
}

extension DGDataColumn {
    func setDataWith(_ values: [Double]) {
        self.setDataFrom(values.map( {String($0)} ))
    }
    
}
