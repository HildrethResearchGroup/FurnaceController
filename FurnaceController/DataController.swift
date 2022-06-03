//
//  DataController.swift
//  FurnaceController
//
//  Created by Mines Student on 6/2/22.
//

import Foundation

class DataController {
    
    // fileURL to save current running data to
    var fileURL: URL?
    var startDate: Date?
    
    init() {
        self.fileURL = URL(fileURLWithPath: "/Users/student/Documents/\(Date.now.formatted(.iso8601)).csv")
        self.startDate = Date.now
    }
    
    // writes a single line of data to the CSV file
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
    
    // gets the CSV data as a 2D array of doubles, representing elapsed time, and the three sensor data points
    func getData() throws -> [[Double]] {
        let data = try? Data(contentsOf: self.fileURL!)
        let stringFromData = String(data: data!, encoding: .ascii)
        
        return strToCSV(string: stringFromData!)
    }
    
    // converts CSV string into nice array of doubles
    func strToCSV(string: String) -> [[Double]] {
        let arr1 = string.components(separatedBy: "\n")
        var arr2: [[Double]] = [[]]
        // convert string to array, but wrong orientation
        for rowStr in arr1 {
            let rowArr = rowStr.components(separatedBy: ",")
            if (rowArr.count != 4){
                return [[-1]]
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let timeElapsed = startDate?.timeIntervalSince(dateFormatter.date(from: rowArr[0])!)
            arr2.append([timeElapsed!, Double(rowArr[1])!, Double(rowArr[2])!, Double(rowArr[3])!])
        }
        
        // transpose this array, then return it
        var arr3: [[Double]] = [[], [], [], []]
        for row in arr2 {
            arr3[0].append(row[0])
            arr3[1].append(row[1])
            arr3[2].append(row[2])
            arr3[3].append(row[3])
        }
        return arr3
    }
}

