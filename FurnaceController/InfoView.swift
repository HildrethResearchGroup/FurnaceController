
import SwiftUI
import ORSSerial


/// Subview containing the application's title, the connection status with the Arduino unit, the serial port selection dropdown, and the open port button.
///
/// This view contains the title text for the application as well as the text, dropdown menu, and button aspects for selecting a serial port to use.
///
/// The connection status text is determined by the statusOK boolean that exists in the ArduinoController class. The different text options are implemented using a ternary conditional operator.
///
/// The dropdown menu communicates with the serialPortManager variable (which is a reference to the singleton instance of the ORSSerialPortManager object from the ORSSerial library). Each option in the dropdown menu is retrieved from the availablePorts property of the ORSSerialPortManager.
///
/// Upon pressing the "Open" button next to the serial port selection dropdown, the nextPortState variable in ArduinoController is updated to "Close" which changes the text in the button. Additionally, when the port is opened, the serialPortWasOpened function is called which sends a status checking command to the Arduino and updates StatusOK based on the response it receives. When the "Close" button is pressed, the nextPortState is updated to "Open" and the serialPortWasClosed function is called.
///
/// The serial port selection dropdown and the button for opening/closing the port are disabled when the timer is running, which is indicated by the "recording" boolean in AppController. Additionally, the dropdown menu is disabled if no ports are detected.

struct InfoView: View {
    
    /// Reference to the singleton instance of AppController.
    ///
    /// AppController contains the status of the timer (recording or not recording) which is used to determine if certain elements should be disabled. It also contains the ArduinoController object which is being used to interface with the Arduino.
    
    @ObservedObject var appController: AppController = AppController.shared
    
    /// Reference to the ArduinoController object, arduino, that exists in AppController.
    ///
    /// The ArduinoController contains the connection status of the Arduino, the list of available ports that are used in the dropdown menu, and the functions for opening and closing the ports. The function for opening the port also contains the logic for sending a command to the Arduino to check its connection to the sensors.

    @ObservedObject var arduinoController: ArduinoController = AppController.shared.arduino
    
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
                Text(arduinoController.statusOK ? "Connected" : "Not Connected")
                    .font(.body)
                    .foregroundColor(arduinoController.statusOK ? Color.green : Color.red)
            }
            
            
            
            HStack{
                
                // MARK: Port Selection Dropdown
                // Dropdown menu showing all available ports that can be connected to
                Picker("Select Port", selection: $arduinoController.serialPort) {
                    ForEach(arduinoController.serialPortManager.availablePorts, id:\.self) { port in
                        Text(port.name).tag(port as ORSSerialPort?)
                    }
                }.disabled(appController.recording)
                
                // MARK: Open Port Button
                // Button for opening port selected from dropdown menu
                Button(arduinoController.nextPortState) {
                    arduinoController.openOrClosePort()
                }
                .disabled(arduinoController.serialPort == nil || appController.recording)
            }
            .padding(10)
            
//            Button("Test Command Dump") {
//                arduinoController.commandBomb()
//            }
        }
    }
}
