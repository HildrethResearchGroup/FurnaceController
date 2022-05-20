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
                Button("Send Command")
                    {controller.testCommand()}
            }
            
            
            CurrentReadingView(controller: controller)
        }
    }
}

extension ORSSerialPort: Identifiable {
    public var id: ORSSerialPort {return self}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
