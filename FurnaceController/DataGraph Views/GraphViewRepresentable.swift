//
//  GraphViewRepresentable.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/21/21.
//

import Foundation
import SwiftUI

/// The actual view of the graph which is used in the GUI.
///
/// Uses the NSViewRepresentable wrapper to integrate an AppKit view into the NSView GraphView.
struct GraphViewRepresentable: NSViewRepresentable {
    typealias NSViewType = GraphView
    
    @ObservedObject var graphController: GraphController
    
    
    func makeNSView(context: Context) -> GraphView {
        
        let graphView = GraphView(graphController)
        
        graphView.autoresizingMask = [.width, .height]
        
        return graphView
    }
    
    func updateNSView(_ nsView: GraphView, context: Context) {
        
    }
}
