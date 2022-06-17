//
//  GraphController.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/21/21.
//

import Foundation
import SwiftUI

/// Interface between FurnaceController application and DataGraph application. Implements functions for saving data values and for communicating those data values to the DataGraph application.
///
/// This class works closely with the DGController object of the DataGraph application. (I believe) The DGController is an object which contains the values and functions which DataGraph uses to create its graphs. This class also implements a function for saving data entered as a parameter to the data arrays in DataModel. In the same function, that same information is sent to the DataGraph application. The extension functionality to DGDataColumn deals with how data in the form of Doubles is converted into a form that the DataGraph application can work with, and then how it passed to the DataGraph application.
class GraphController: ObservableObject {
    
    /// A part of the DataGraph applications Swift logic which connects the graph to a DataGraph file
    @Published var graph: DGController?
    
    /// An object which contains all of the data.
    private var data = DataModel()
    
    /// Initializes the graph to the "Basic Script" graph
    init() {
        if graph == nil {
            graph = DGController(fileInBundle: "Basic Script")
        }
    }
    
    /// Add a new set of data to both the stored data and the DataGraph application
    /// - Parameters:
    ///   - time: Measured time in minutes
    ///   - temp: Measured temperature in degrees Celcius
    ///   - flowAr: Measured flowrate of Argon
    ///   - flowN2: Measured flowrate of Nitrogen
    ///
    ///   Calls the update function of the DataModel class to record a new datapoint for each property being meassured: time, temperature, Argon flowrate and Nitrogen flowrate. Additionally, adds a new data column to the DataGraph application so that the new data will appear on the Temperature and Flowrate vs. Time graph.
    func updateData(time: Double, temp: Double, flowAr: Double, flowN2: Double) {
        // Update the saved data
        data.update(time: time, temp: temp, flowAr: flowAr, flowN2: flowN2)
        
        // Update the data in DataGraph
        graph?.dataColumn(at: 1).setDataWith(data.time)
        graph?.dataColumn(at: 2).setDataWith(data.temp)
        graph?.dataColumn(at: 3).setDataWith(data.flowAr)
        graph?.dataColumn(at: 4).setDataWith(data.flowN2)
    }
    
    /// Resets graph data
    ///
    /// Called in between experiment runs. Initializes a new DataModel which has all value arrays empty.
    func resetData() {
        data = DataModel()
    }
}

// Added functionality to DGDataColumn object which allows data to be set by calling the setDataWith function with a double array as the parameter
extension DGDataColumn {
    /// Adds data to the DGDataColumn object after converting its values into String objects
    /// - Parameter values: A set a data values in the form of Doubles
    ///
    /// I am not entirely clear on what this function does, but I believe it adds the double array it is passed to the DGDataColumn object, a DataGraph object, in the form of String objects.
    func setDataWith(_ values: [Double]) {
        self.setDataFrom(values.map( {String($0)} ))
    }
}
