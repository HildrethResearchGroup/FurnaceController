
import SwiftUI
import ORSSerial

struct ContentView: View {
    
    /// Reference to the singleton instance of AppController.
    ///
    /// This reference to AppController is for the purpose of passing the graph object in AppController into the GraphViewRepresentable view as a parameter.
    @ObservedObject var controller = AppController.shared
    
    var body: some View {
        
        /*
         GeometryReader is a built-in method for determining the size of a certain view. This allows for the
         use of frame() to size objects according to the size of the view instead of using a static size.
         */
        GeometryReader { geometry in
            HSplitView {
                    
                VStack{
                    
                    // Title, Port Selection, and Connection Status
                    // NOTE: Currently the title and connection status appear offscreen when the window is not in fullscreen.
                    InfoView()
                        .padding()
                        .frame(alignment: .top)
                    
                    // Current Temperature and Temperature Control(disabled)
                    TemperatureView()
                        .padding()
                    
                    // Current Nitrogen Flow Rate and Nitrogen Flow Rate Control
                    NitrogenFlowView()
                        .padding()
                    
                    // Current Argon Flow Rate and Argon Flow Rate Control
                    ArgonFlowView()
                        .padding()
                    
                    // Minutes Per Sample Control
                    MeasurementRateView()
                        .padding()
                    
                    // Error Status (transparent until error occurs)
                    ErrorView()
                        .padding()
                }
                .frame(minWidth: geometry.size.width * 0.2, maxWidth: geometry.size.width * 0.5, minHeight: geometry.size.height, maxHeight: geometry.size.height)
                
                VStack {
                    
                    // Stopwatch for Experiment
                    StopWatchView()
                        .padding()
                    
                    // Graphs of Temperature and Flow Rates vs. Time
                    GraphViewRepresentable(graphController: controller.graph)
                        .padding()
                    
                }
                .frame(minWidth: geometry.size.width * 0.5, maxWidth: geometry.size.width * 0.8, minHeight: geometry.size.height, maxHeight: geometry.size.height)
            }
        }
    }
}

// Preview View
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

