//
//  DataController.swift
//  FurnaceController
//
//  Created by Mines Student on 6/2/22.
//

import Foundation

class DataController {
    
    var fileURL: URL?
    
    init() {
        self.fileURL = URL(fileURLWithPath: "/Users/student/Documents/data.csv")
        print(self.fileURL?.absoluteString)
    }
    
    func writeLine (data: String) {
        do {
            let prevData = try String(contentsOf: self.fileURL!)
            let newData = prevData + data + "\n"
            print(newData)
            try? newData.data(using: String.Encoding.ascii)?.write(to: self.fileURL!)
        } catch {
            print("error")
            try? "".data(using: String.Encoding.ascii)?.write(to: self.fileURL!)
        }
    }
    
}

