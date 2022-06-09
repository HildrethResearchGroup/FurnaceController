//
//  SwiftUIView.swift
//  FurnaceController
//
//  Created by Mines Student on 6/9/22.
//

import SwiftUI

struct ErrorView: View {
    
    @ObservedObject var controller: AppController
    
    init(controller: AppController) {
        self.controller = controller
    }
    
    var body: some View {
        Text(controller.errorMessage)
            .foregroundColor(.red)
            .fontWeight(.semibold)
            .font(.headline)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
