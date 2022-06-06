//
//  WireframeView.swift
//  FurnaceController
//

import SwiftUI
import ORSSerial

/*
 * InfoView contains the app title, the connection status, the port selection dropdown, and the open port button
 */
struct InfoView: View {
    
    @ ObservedObject var controller: ArduinoController
    
    @ State var status: String
    
    init(controller: ArduinoController) {
        self.controller = controller
        self.status = "Not Connected"
    }
    
    var body: some View {
        VStack{
            // MARK: Title
            Text("Furnace Controller")
                .font(.title)
                .fontWeight(.bold)
                .frame(alignment: .top)
            
            HStack {
                // MARK: Connection Status
                // Status text indicating if current state of connection to Arduino
                Text("Status:")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(status)
                    .font(.body)
                    .foregroundColor(.red)
            }
            
            
            HStack{
                
                // MARK: Port Selection Dropdown
                // Dropdown menu showing all available ports that can be connected to
                Picker("Select Port", selection: $controller.serialPort) {
                    ForEach(controller.serialPortManager.availablePorts, id:\.self) { port in
                        Text(port.name).tag(port as ORSSerialPort?)
                    }
                }
                
                // MARK: Open Port Button
                // Button for opening port selected from dropdown menu
                Button(controller.nextPortState) {controller.openOrClosePort()}
                
            }
            .padding(10)
        }
    }
}

/*
 * TemperatureView contains the display of the current temperature, the TextField for updating the temperature,
 * and the button for confirming an update
 */
struct TemperatureView: View {
    
    @State private var temp: String = ""
    
    var controller: AppController?
    
    init(controller: AppController) {
        self.controller = controller
    }
    
    var body: some View {
        VStack {
            HStack {
                // MARK: Temperature Display
                // Displays the temperature measured at the last request in degrees Celcius
                Text("Temperature (ºC):")
                Text(String((controller?.arduino.lastTemp)!))
            }.frame(alignment: .leading)

            
            HStack {
                // MARK: Update Temperature
                // Both the textfield and update button for setting a new temperature
                // This is NONFUNCTIONAL at the moment
                TextField("", text: $temp)
                Button("Set Temperature"){
                    print("set")
                }
            }
            
        }
    }
}

/*
 * ArgonFlowView contains the display of the current flowrate of Argon, the TextField for updating the
 * flowrate, and the button for confirming an update
 */
struct ArgonFlowView: View {
    
    @State private var flow: String = ""               // last measured flowrate
    
    var controller: AppController?
    
    init(controller: AppController) {
        self.controller = controller
    }
    
    var body: some View {
        VStack {
             
            HStack {
                
                // MARK: Display Flowrate
                // Displays the flowrate measured at the last request in ...
                Text("Argon Flowrate (L/min)")
                Text(String((controller?.arduino.lastFlowAr)!))
                
            }.frame(alignment: .leading)

            HStack {
                
                // MARK: Update Flowrate
                // Both the textfield and update button for setting a new flowrate
                TextField("", text: $flow)
                Button("Set Flow Rate"){
                    print("")
                
                }
            }
        }
    }
}

struct NitrogenFlowView: View {
    
    @State private var flow: String = ""         // last measured flowrate
    
    var controller: AppController?
    
    init(controller: AppController) {
        self.controller = controller
    }
    
    var body: some View {
        VStack {
            
            HStack {
                
                // MARK: Display Flowrate
                // Displays the flowrate measured at the last request in ...
                Text("Nitrogen Flowrate (L/min)")
                Text(String((controller?.arduino.lastFlowAr)!))
                
            }.frame(alignment: .leading)

            HStack {
                
                // MARK: Update Flowrate
                // Both the textfield and update button for setting a new flowrate
                TextField("", text: $flow)
                Button("Set Flow Rate"){
                    print("")
                }
                
            }
        }
    }
}

struct StopWatchView: View {
    @ObservedObject var controller: AppController
    
    init(controller: AppController) {
        self.controller = controller
    }
    
    var body: some View {
        VStack {
            Button(controller.recordButtonLabel, action: {
                // controller.startOrStopRecord
            })
            Text("\(String(format:"%02d", (controller.progressTime/3600) )):\(String(format:"%02d",  (controller.progressTime % 3600 / 60) )):\(String(format:"%02d", controller.progressTime % 60))")
                .font(.system(size: 25, design: .serif))
            HStack {
                Text("Minutes / Sample: ")
                TextField("Minutes / Sample", text: $controller.minutesPerSample)
            }
        }
    }
}

// CurrentReadingView is a debugging view which includes a TextField for entering commands to be sent to the
// Arduino unit
struct CurrentReadingView: View {
    var controller: ArduinoController
    
    init(controller: ArduinoController){
        self.controller = controller
    }
    
    // this view is about 200 pixels wide
    var body: some View {
        HStack{
            VStack (alignment: .trailing){
                
                // MARK - Titles for Data
                Text("Temperature: ")
                Text("Nitrogen Flow Rate: ")
                Text("Argon Flow Rate: ")
            }
            
            VStack (alignment: .leading){
                // MARK - Last Measurements
                Text("\(controller.lastTemp)º\(controller.tempUnit)")
                Text("\(controller.lastFlowN2) \(controller.flowUnit)")
                Text("\(controller.lastFlowAr) \(controller.flowUnit)")
            }
        }
    }
}
