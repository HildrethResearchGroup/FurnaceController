//
//  SwiftUIView.swift
//  FurnaceController
//
//  Created by Mines Student on 6/9/22.
//

import SwiftUI

struct ErrorView: View {
    
    @ObservedObject var controller = AppController.shared
    
    
    var body: some View {
        Text(controller.errorMessage)
            .foregroundColor(.red)
            .fontWeight(.semibold)
            .font(.headline)
//        Button("Clear Error Message") {
//            controller.errorMessage = ""
//        }
//        .disabled(controller.errorMessage == "")
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(controller: AppController.shared)
    }
}
