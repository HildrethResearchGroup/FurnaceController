//
//  WireframeView.swift
//  FurnaceController
//
//  Created by Preston Grant Yates on 5/24/22.
//
import SwiftUI
import ORSSerial


struct Measure{
    let temp: Double
}


private func getTemperatures() -> [Measure]{
    var temps = [Measure]()
    
    for _ in 1...20{
        let value = Measure(temp:Double.random(in: 100...300))
        temps.append(value)
    }
    
    return temps
}


private func getYearlyLabels() -> [String] {
    return(2015...2021).map { String($0)}
}






struct GasFlowView: View {
    @ObservedObject var controller = ArduinoController()
    
    @State private var flow: String = ""
    
    
    private func getRate() -> Void {
        print(flow)
    }
    var body: some View {
        VStack {
            
            //current flow rate
            HStack {
                Text("Current Flow Rate(Liters/minute):")
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
    @ObservedObject var controller = ArduinoController()
    
    @State private var temp: String = ""
    
    private func getTemp() -> Void {
        print(temp)
    }
    
    var body: some View {
        VStack {

            
            //curent temp
            HStack {
                Text("Current Temperature(ºK):")
                TextField("\(temp)", text: $temp).disabled(true)
            }.frame(alignment: .leading)

            //set temp
            HStack {
                TextField("", text: $temp)
                Button("Set Temperature", action: getTemp)
            }
            
        }
    }
}



    


struct ControlView: View {
    
    let temps = getTemperatures().map{Int($0.temp)}
    let labels = getYearlyLabels()
    
    //var controlLabel: Label<Title:"Furnace Controller", <#Icon: View#>>;
    // controlLabel.font = controlLabel.font.withSize(20)
    //controlLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20.0)
    var body: some View {
            VStack{
                
                
                InfoView()
                
                TemperatureView()
                    .padding()
                    .frame(minWidth: 200, maxWidth: 300, minHeight: 100, maxHeight: 200)
                GasFlowView()
                    .padding()
                    .frame(minWidth: 200, maxWidth: 300, minHeight: 100, maxHeight: 200)
                GasFlowView()
                    .padding()
                    .frame(minWidth: 200, maxWidth: 300, minHeight: 100, maxHeight: 200)
            }
     
        
        
    }
}
