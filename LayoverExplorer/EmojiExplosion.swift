//
//  EmojiExplosion.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/14/23.
//

import SwiftUI

struct EmojiExplosion: View {
    let emoji: String
    let screenSize: CGSize?
    
    @State private var position: CGPoint = .zero
    
    var body: some View {
        if let sSize = screenSize {
            Text(emoji)
                .font(.largeTitle)
                .position(position)
                .animation(
                    Animation.timingCurve(0.1, 0.7, 0.1, 0.7, duration: 0.2)
                        .repeatForever(autoreverses: false)
                        .delay(Double.random(in: 0...1))
                )
                .onAppear {
                    let randomX = CGFloat.random(in: -sSize.width/4...sSize.width/4)
                    let randomY = CGFloat.random(in: -sSize.height/4...sSize.height/4)
                    position = CGPoint(x: randomX, y: randomY)
                }
        }
    }
}

struct EmojiExplosion_Previews: PreviewProvider {
    static var previews: some View {
        EmojiExplosion(emoji: "", screenSize: nil)
    }
}
