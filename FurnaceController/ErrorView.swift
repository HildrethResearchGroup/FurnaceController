
import SwiftUI

/// Subview containing the text item for error messages.
///
/// The error messages are passed from the Arduino into the AppController by the ArduinoController. These error messages, which exist in AppController are what are displayed by this class
struct ErrorView: View {
    
    /// Reference to the singleton instance of AppController.
    ///
    /// AppController contains the error message that will be displayed. The default value of this error message is an empty string.
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
