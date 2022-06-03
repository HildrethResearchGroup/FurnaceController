//
//  StopWatch.swift
//  FurnaceController
//
//  Created by Preston Grant Yates on 6/2/22.
//

import Foundation
import ORSSerial
import SwiftUI

class StopWatch: ObservableObject{
    
    @Published var recordButtonLabel: String = "Start Recording"
    @Published var progressTime: Int = 0
    
    var timer: Timer?
}
