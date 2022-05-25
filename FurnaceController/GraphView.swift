//
//  GraphView.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/19/21.
//

import Foundation
import SwiftUI

class GraphView: NSView {
    var graphController: GraphController? = nil

    private var graph: DPDrawingView = DPDrawingView()
    
    convenience init(_ graphControllerIn: GraphController) {
        let newFrame = NSRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100.0, height: 100.0))
        self.init(frame: newFrame)
        
        
        graphController = graphControllerIn
        
        graph = DPDrawingView()
        
        graph = DPDrawingView()
        graph.frame = newFrame
        graph.autoresizingMask = [.width, .height]
        
        self.addSubview(graph)
        graphController?.dgController?.setDrawingView(graph)
        
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



