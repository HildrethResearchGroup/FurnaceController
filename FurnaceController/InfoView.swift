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
    
    @ ObservedObject var controller: AppController
    
    init(controller: AppController) {
        self.controller = controller
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
                Text(controller.arduino.connectionStatus)
                    .font(.body)
                    .foregroundColor(controller.arduino.connectionColor)
            }
            
            
            
            HStack{
                
                // MARK: Port Selection Dropdown
                // Dropdown menu showing all available ports that can be connected to
                Picker("Select Port", selection: $controller.arduino.serialPort) {
                    ForEach(controller.arduino.serialPortManager.availablePorts, id:\.self) { port in
                        Text(port.name).tag(port as ORSSerialPort?)
                    }
                }
                
                // MARK: Open Port Button
                // Button for opening port selected from dropdown menu
                Button(controller.arduino.nextPortState) {
                    controller.arduino.openOrClosePort()
                    
                    // TODO: insert status checking method
                }
                
            }
            .padding(10)
        }
    }
}
