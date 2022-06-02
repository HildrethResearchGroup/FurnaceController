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
    @Published var status: String = "Start Recording"
    @Published var progressTime: Int = 0
    var timer:Timer?
    
    //let stringHours = String(format: "%02d", hours)
    //let stringMinutes = String(format: "%02d", minutes)
    //let stringSeconds = String(format: "%02d", seconds)
    
    

    
    func startOrStopRecord() -> Void {
        if(self.status == "Start Recording"){
            self.status = "Stop Recording"
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.progressTime = self.progressTime + 1

            }
                
            print("1")

            

            //StopwatchView()
            
        }
        else{
            self.status = "Start Recording"
            //self.showSavePanel()
            print("2")
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
