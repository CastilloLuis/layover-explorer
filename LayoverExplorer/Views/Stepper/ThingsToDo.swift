//
//  ThingsToDo.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/19/23.
//

import SwiftUI

struct ThingsToDo: View {
    
    @Binding var selectedThingsToDo: [String]
    
    var body: some View {
        VStack {
            Text("What would you like to do?")
                .font(.custom("Roboto-Bold", size: 28))
                .frame(maxWidth: .infinity)
            
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(things_to_do, id: \.self) { row in
                        LazyHGrid(rows: [GridItem(.flexible())]) {
                            ForEach(row, id: \.self) { plan in
                                HStack {
                                    Text("\(plan[0]) \(plan[1])")
                                        .font(.system(size: selectedThingsToDo.contains(plan[1]) ? 15 : 14))
                                        .foregroundColor(
                                            !selectedThingsToDo.contains(plan[1])
                                            ? Color.black : Color.white
                                        )
                                        .scaleEffect(selectedThingsToDo.contains(plan[1]) ? 1 : 0.9)
                                }
                                .padding([.top, .bottom], 5)
                                .padding([.leading, .trailing], 10)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(
                                            colors: selectedThingsToDo.contains(plan[1]) ? [
                                                Color(#colorLiteral(red: 0.04705882353, green: 0.04705882353, blue: 0.04705882353, alpha: 1)),
                                                Color(#colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1))
                                            ] :  [
                                                Color.white,
                                                Color(#colorLiteral(red: 0.9, green: 0.9, blue: 0.9, alpha: 1))
                                            ]
                                        ),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 3.5, x: 0, y: 2)
                                .onTapGesture {
                                    withAnimation(.interpolatingSpring(stiffness: 200, damping: 10)) {
                                        if selectedThingsToDo.contains(plan[1]) {
                                            if let idx = selectedThingsToDo.firstIndex(where: {$0 == plan[1]}) {
                                                selectedThingsToDo.remove(at: idx)
                                            }
                                        } else {
                                            selectedThingsToDo.append(plan[1])
                                        }
                                    }
                                }
                                .scaleEffect(0.98)
                            }
                        }
                    }
                }
                .padding([.top, .bottom], 5)
            }
            .frame(height: 120)
        }
    }
}

struct ThingsToDo_Previews: PreviewProvider {
    static var previews: some View {
        ThingsToDo(selectedThingsToDo: .constant([]))
    }
}
