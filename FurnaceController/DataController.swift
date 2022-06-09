//
//  DataController.swift
//  FurnaceController
//
//  Created by Mines Student on 6/2/22.
//

import Foundation

class DataController {
    
    /// File URL to save current running data to
    var fileURL: URL?
    
    init() {
        self.fileURL = URL(fileURLWithPath: "/Users/student/Documents/\(Date.now.formatted(.iso8601)).csv")
    }
    
    /// writes a single line of data to the CSV file
    func writeLine (data: String) {
        do {
            try data.appendLineToURL(fileURL: self.fileURL!)
        }
        catch {
            print("Error, could not append to file at URL \(self.fileURL!.absoluteString)")
        }
    }
    
    func saveData(url: URL) {
        try? FileManager.default.moveItem(at: self.fileURL!, to: url)
    }
    
    /// gets the CSV data as a 2D array of doubles, representing elapsed time, and the three sensor data points
    /// unused function
    func getData() throws -> [[Double]] {
        let data = try? Data(contentsOf: self.fileURL!)
        let stringFromData = String(data: data!, encoding: .ascii)
        
        return strToCSV(string: stringFromData!)
    }
    /// converts CSV string into nice array of doubles
    func strToCSV(string: String) -> [[Double]] {
        let arr1 = string.components(separatedBy: "\n")
        var arr2: [[Double]] = [[]]
        // convert string to array, but wrong orientation
        for rowStr in arr1 {
            let rowArr = rowStr.components(separatedBy: ",")
            if (rowArr.count != 4){
                return [[-1]]
            }
            arr2.append([Double(rowArr[0])!, Double(rowArr[1])!, Double(rowArr[2])!, Double(rowArr[3])!])
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

// code stolen, CREDIT: https://stackoverflow.com/questions/27327067/append-text-or-data-to-text-file-in-swift
extension String {
    func appendLineToURL(fileURL: URL) throws {
         try (self + "\n").appendToURL(fileURL: fileURL)
     }

     func appendToURL(fileURL: URL) throws {
         let data = self.data(using: String.Encoding.utf8)!
         try data.append(fileURL: fileURL)
     }
 }

 extension Data {
     func append(fileURL: URL) throws {
         if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
             defer {
                 fileHandle.closeFile()
             }
             fileHandle.seekToEndOfFile()
             fileHandle.write(self)
         }
         else {
             try write(to: fileURL, options: .atomic)
         }
     }
 }
