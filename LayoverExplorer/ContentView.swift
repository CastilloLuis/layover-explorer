import SwiftUI

struct ContentView: View {
    @Namespace private var namespace
    @State private var shouldMove = false

    var body: some View {
        VStack {
            if shouldMove {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 100)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
                    .offset(y: shouldMove ? 100 : 0)
                    .onTapGesture {
                        withTransaction(Transaction(animation: .linear(duration: 0.5))) {
                            shouldMove.toggle()
                        }
                    }
            } else {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
                    .onTapGesture {
                        withTransaction(Transaction(animation: .linear(duration: 0.5))) {
                            shouldMove.toggle()
                        }
                    }
            }

            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
