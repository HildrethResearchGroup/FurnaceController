//
//  ContentView.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/18/21.
//

import SwiftUI

struct ContentView: View {
    @State var graphController = GraphController()
    
    var body: some View {
        VStack{
            Slider(value: $graphController.adjustableValue, in: 0.0...10.0) {
                Text("Value")
            }
            Button("Increment"){graphController.updateData()}
            GraphViewRepresentable(graphController: graphController)
                .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
