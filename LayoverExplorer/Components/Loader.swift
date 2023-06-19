//
//  Loader.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/14/23.
//

import SwiftUI

let loaderStates = [
    "🌍 Creating personalized adventures for you",
    "🔍 Our AI is crafting unique experiences",
    "✨ Unveiling handpicked destinations just for you",
    "🌟 Unlocking travel wonders through advanced AI",
    "🤖 Curating extraordinary journeys for your wanderlust",
    "🔓 Discovering hidden gems with the help of our AI"
]

struct Loader: View {
    @State var currentLoaderStateIdx = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack(alignment: .center) {
            Text(loaderStates[currentLoaderStateIdx] + "...")
                .font(.custom("Roboto-Medium", size: 30))
                .multilineTextAlignment(.center)
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                withAnimation() {
                    currentLoaderStateIdx += 1
                    if (currentLoaderStateIdx >= loaderStates.count) {
                        currentLoaderStateIdx = 0
                        return
                    }
                }
            }
        }
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}
