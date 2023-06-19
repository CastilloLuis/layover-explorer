//
//  LayoverTiming.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/19/23.
//

import SwiftUI

struct LayoverTiming: View {
    
    @Binding var layoverHours: String
    
    var body: some View {
        VStack {
            VStack {
                Text("How long is your layover?")
                    .font(.custom("Roboto-Bold", size: 28))
                TextField("0", text: $layoverHours)
                    .keyboardType(.numberPad)
                    .padding()
                    .textFieldStyle(DefaultTextFieldStyle())
                    .font(.custom("Roboto-Regular", size: 150))
                    .multilineTextAlignment(.center)
                    .background(.white)
            }
        }
    }
}

struct LayoverTiming_Previews: PreviewProvider {
    static var previews: some View {
        LayoverTiming(layoverHours: .constant(""))
    }
}
