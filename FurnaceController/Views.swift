//
//  WireframeView.swift
//  FurnaceController
//
//  Created by Preston Grant Yates on 5/24/22.
//
import SwiftUI
import ORSSerial

struct InfoView: View {
    
    @ObservedObject var controller = ArduinoController()
    
    @State private var start: String = ""
    private func Start() -> Void {
        print(start)
    }
    
    var body: some View {
        VStack{
            
            HStack {
                Text("Status:")
                Text("Connected")
            }.frame(alignment: .leading)
            
            HStack{
                Picker("Select Port", selection: $controller.serialPort) {
                    ForEach(controller.serialPortManager.availablePorts, id:\.self) { port in
                        Text(port.name).tag(port as ORSSerialPort?)
                    }
                }
                Button(controller.nextPortState) {controller.openOrClosePort()}
            }
            .padding(10)
        }
    }
}

struct TemperatureView: View {
    
    @State private var temp: String = ""
    
    var controller: AppController?
    
    init(controller: AppController) {
        self.controller = controller
    }
    
    var body: some View {
        VStack {
            //curent temp
            HStack {
                Text("Current Temperature(ºK):")
                Text(String((controller?.ardiono.lastTemp)!))
            }.frame(alignment: .leading)

            //set temp
            HStack {
                TextField("", text: $temp)
                Button("Set Temperature"){
                    print("set")
                }
            }
            
        }
    }
}

struct GasFlowView: View {
    
    @State private var label: String
    @State private var flow: String
    
    init(label: String) {
        self.label = label
        self.flow = ""
    }
    
    private func getRate() -> Void {
        print(flow)
    }
    
    var body: some View {
        VStack {
            //current flow rate
            HStack {
                Text(label)
                TextField("\(flow)", text: $flow).disabled(true)
            }.frame(alignment: .leading)

            //setting flow rate
            HStack {
                TextField("", text: $flow)
                Button("Set Flow Rate", action: getRate)
            }
        }
    }
}

struct CurrentReadingView: View {
    var controller: ArduinoController
    
    init(controller: ArduinoController){
        self.controller = controller
    }
    
    // this view is about 200 pixels wide
    var body: some View {
        HStack{
            VStack (alignment: .trailing){
                Text("Temperature: ")
                Text("Nitrogen Flow Rate: ")
                Text("Argon Flow Rate: ")
            }
            VStack (alignment: .leading){
                Text("\(controller.lastTemp)º\(controller.tempUnit)")
                Text("\(controller.lastFlowN2) \(controller.flowUnit)")
                Text("\(controller.lastFlowAr) \(controller.flowUnit)")
            }
        }
    }
}
