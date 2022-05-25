//
//  ContentView.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import SwiftUI
import ORSSerial


struct ContentView: View {
    
    @ObservedObject var controller = ArduinoController()
    @ObservedObject var graphController = GraphController()
    
    
    var body: some View {
        VStack{
            HStack{
                Picker("Select Port", selection: $controller.serialPort) {
                    ForEach(controller.serialPortManager.availablePorts, id:\.self) { port in
                        Text(port.name).tag(port as ORSSerialPort?)
                    }
                }
                
                Button(controller.nextPortState) {controller.openOrClosePort()}
            }
            .padding(10)
            
            HStack {
                TextField("", text: $controller.nextCommand)
                Button("Send Command") {controller.sendCommand()}
            }
            
            Text("Last response: \(controller.lastResponse)")
            
            
            CurrentReadingView(controller: controller)
        
            //let graph:GraphViewRepresentable = GraphViewRepresentable(graphController: <#T##GraphController#>)
            //graph.makeNSView(context: <#T##Context#>)
            //graph.makeNSView(context: <#T##Context#>)
            
            GraphViewRepresentable(graphController: graphController).frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
