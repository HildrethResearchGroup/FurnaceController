//
//  InfoView.swift
//  FurnaceController
//
//  Created by Mines Student on 6/6/22.
//

import SwiftUI
import ORSSerial

/*
 * InfoView contains the app title, the connection status, the port selection dropdown, and the open port button
 */
struct InfoView: View {
    
    @ObservedObject var controller: ArduinoController
    @ObservedObject var appController: AppController
    
    init(controller: ArduinoController) {
        self.controller = controller
        self.appController = AppController.shared
    }
    
    var body: some View {
        VStack{
            // MARK: Title
            Text("Furnace Controller")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(alignment: .top)
                .scaledToFit()
            
            HStack {
                // MARK: Connection Status
                // Status text indicating if current state of connection to Arduino
                Text("Status:")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(controller.statusOK ? "Connected" : "Not Connected")
                    .font(.body)
                    .foregroundColor(controller.statusOK ? Color.green : Color.red)
            }
            
            
            
            HStack{
                
                // MARK: Port Selection Dropdown
                // Dropdown menu showing all available ports that can be connected to
                Picker("Select Port", selection: $controller.serialPort) {
                    ForEach(controller.serialPortManager.availablePorts, id:\.self) { port in
                        Text(port.name).tag(port as ORSSerialPort?)
                    }
                }.disabled(appController.recording)
                
                // MARK: Open Port Button
                // Button for opening port selected from dropdown menu
                Button(controller.nextPortState) {
                    controller.openOrClosePort()
                    
                    // TODO: insert status checking method
                }
                .disabled(controller.serialPort == nil)
            }
            .padding(10)
        }
    }
}
