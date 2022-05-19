//
//  ContentView.swift
//  FurnaceController
//
//  Created by Mines Student on 5/17/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var controller = ArduinoController()
    
    var body: some View {
        VStack{
            CurrentReadingView(controller: controller)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
