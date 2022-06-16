
import Foundation

/// The interface between the Swift application the the computer's filesystem.
///
/// This class implements functions for saving data to a CSV file. It works by writing the data to a temporary file and then moving that data to a user-created file at a later time. Although it is not used in the FurnaceController, this class also has the functionality to convert strings with a comma-seperated value format into corresponding data arrays.

class DataController {
    
    /// File URL to save current running data to
    ///
    /// This is a temporary file which the data is saved to before the user selects the file name and location for actually storing the data.
    var fileURL: URL?
    
    /// Initializes a generic file URL in Documents
    ///
    /// The user is allowed to rename the file later, but it is necessary to initialize the file first so that data can be written to it
    init() {
        self.fileURL = URL(fileURLWithPath: "/Users/student/Documents/\(Date.now.formatted(.iso8601)).csv")
    }
    
    /// Writes a single line of data to the CSV file
    /// - Parameter data: A line of data in a comma-seperated format
    ///
    /// A single comma-seperated line of data in the form "temperature, Argon flowrate, Nitrogen flowrate" is written to the file.
    func writeLine (data: String) {
        do {
            // append the data to the file created
            try data.appendLineToURL(fileURL: self.fileURL!)
        }
        catch {
            // prints an error message indicating the the file could not be printed to the file; giving the file's absolute string for the URL
            print("Error, could not append to file at URL \(self.fileURL!.absoluteString)")
        }
    }
    
    /// Actually save the file to a user-selected URL
    /// - Parameter url: The actual URL that the user chosses to save the data to
    func saveData(url: URL) {
        // Move the data from the generic URL to the user-selected URL
        try? FileManager.default.moveItem(at: self.fileURL!, to: url)
    }
    
    /// Gets the CSV data as a 2D array of doubles, representing elapsed time, and the three sensor data points
    ///
    /// unused function
    func getData() throws -> [[Double]] {
        let data = try? Data(contentsOf: self.fileURL!)
        let stringFromData = String(data: data!, encoding: .ascii)
        
        return strToCSV(string: stringFromData!)
    }
    
    /// Converts CSV string into an array of doubles
    /// - Parameter string: a string of values in a comma-seperated format
    /// - Returns: an array containing multiple arrays corresponding to the different values measured
    ///
    /// The string is first converted into a two-dimensional array where each row represents one set of data in the format "temperature, Argon flowrate, Nitrogen flowrate." To group the appropriate data together, the array needs to be transposed. This will produce an array containing 3 arrays: one for all temperature values, one for all Argon flowrate values, and one for all Nitrogen flowrate values.
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

/// Extends the functionality of the String object to append to a file.
///
/// This code was taken from [this] https://stackoverflow.com/questions/27327067/append-text-or-data-to-text-file-in-swift StackOverflow conversation.
extension String {
    
    /// Appends a line of data including a newline to a file
    ///  - Parameter fileURL: File Url of the file the data is being appended to
    func appendLineToURL(fileURL: URL) throws {
         try (self + "\n").appendToURL(fileURL: fileURL)
     }

    
    /// Converts a string to data which is appended to a file
    /// - Parameter fileURL: File URL of the file the data is being appended to
     func appendToURL(fileURL: URL) throws {
         // Convert the string to data encoded using utf8
         let data = self.data(using: String.Encoding.utf8)!
         
         // Append the data to the file
         try data.append(fileURL: fileURL)
     }
 }

/// Extends the functionality of the Data object to append to a file
///
/// This code was taken from [this] https://stackoverflow.com/questions/27327067/append-text-or-data-to-text-file-in-swift StackOverflow conversation.
 extension Data {
     
     /// Appends data to the end of a file
     /// - Parameter fileURL: File URL of the file the data is being appended to
     ///
     /// Defers closing a file. Seeks out the end of a file and ... (I am not sure from here)
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
