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
    
    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["txt"]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save your text"
        savePanel.message = "Choose a folder and a name to store your text."
        savePanel.nameFieldLabel = "File name:"
        
        let response = savePanel.runModal()
            return response == .OK ? savePanel.url : nil
    }
  /*
    struct StopwatchView: View {
        @State var progressTime = 0
        
        var hours: Int {
          progressTime / 3600
        }

        var minutes: Int {
          (progressTime % 3600) / 60
        }

        var seconds: Int {
          progressTime % 60
        }
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        var body: some View {
            let stringHours = String(format: "%02d", hours)
            let stringMinutes = String(format: "%02d", minutes)
            let stringSeconds = String(format: "%02d", seconds)
            Text("\(stringHours):\(stringMinutes):\(stringSeconds)").font(.system(size: 25, design: .serif))
                .onReceive(timer) { _ in
                    progressTime = progressTime + 1
                }
        }
    }
    
 */
    
    
    
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
