//
//  InfoView.swift
//  FurnaceController
//
//  Created by Mines Student on 6/6/22.
//

import SwiftUI
import ORSSerial


/// Subview containing the application's title, the connection status with the Arduino unit, the serial port selection dropdown, and the open port button.
///
/// This view contains the title text for the application as well as the text, dropdown menu, and button aspects for selecting an Arduino to interact with.
///
/// The connection status text is determined by the statusOK boolean that exists in the ArduinoController class. The different text options are implemented using a ternary conditional operator.
///
/// The dropdown menu communicates with the serialPortManager variable (which is a reference to the singleton instance of the ORSSerialPortManager object from the ORSSerial library). Each option in the dropdown menu is retrieved from the availablePorts property of the ORSSerialPortManager.
///
///  Upon pressing the open button next to the serial port selection dropdown, the open 
///
/// The serial port selection dropdown and the button for opening the
///
///
struct InfoView: View {
    
    @ObservedObject var appController: AppController = AppController.shared
    @ObservedObject var controller: ArduinoController = AppController.shared.arduino
    
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
                }
                .disabled(controller.serialPort == nil || appController.recording)
            }
            .padding(10)
        }
    }
}
