//
//  GraphView.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/19/21.
//

import Foundation
import SwiftUI

/// A viewable graph that is connected to a GraphController
///
/// According to Apple Documentation, NSView is an "...infrastructure for drawing, printing, and handling events in an app." NSViews are not usually used directly, but they provide the framework for a view. In this case, the view that is actually implemented is GraphViewRepresentable which uses GraphView.
///
/// This class sets up the actual graph which will be displayed on the GUI and connects that graph to the GraphController.
class GraphView: NSView {
    
    /// The interface between graph which will be displayed on the GUI and the DataGraph application.
    var graphController: GraphController? = nil

    private var graph: DPDrawingView = DPDrawingView()
    
    /// Initializes the graph as a viewable object and connects that object to the GraphView controller
    convenience init(_ graphControllerIn: GraphController) {
        // Initiate the frame of the graph
        let newFrame = NSRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100.0, height: 100.0))
        self.init(frame: newFrame)
        
        // Initialize graphController based on argument passed
        graphController = graphControllerIn
        
        graph = DPDrawingView()
        
        graph = DPDrawingView()
        graph.frame = newFrame
        graph.autoresizingMask = [.width, .height]       // autoresizing feature
        
        self.addSubview(graph)                           // add the graph as a subview of GraphView
        graphController?.graph?.setDrawingView(graph)    // connect the graph to the GraphController
        
    }
    
    
    /// Provide GraphView with NSView's init
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

    }
    
    /// A required, failable initiator which throws a fatal error
    ///
    /// A required initiator is an initiator which must be applied to all direct subclasses. A failable initiator, indicated by the question mark, will automatically discard inits that fail.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



