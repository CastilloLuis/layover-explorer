import SwiftUI

struct ContentView: View {
    @Namespace private var namespace
    @State private var shouldMove = false

    var body: some View {
        VStack {
            LayoverDetailsForm()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
