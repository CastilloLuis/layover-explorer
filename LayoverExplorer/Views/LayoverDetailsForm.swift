//
//  LayoverDetailsForm.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/13/23.
//

import SwiftUI
import CoreLocation

struct LayoverDetailsForm: View {
    @EnvironmentObject var network: Network
    @State private var activeTab = 0

    @State private var showSearchBar = false
    @State private var showCountryList = false
    @State private var loading = false
    @State private var isButtonPressed = false
    @State private var showSuggestedPlaces = false
    @State private var showEmojis = false
    
    @State private var suggestedPlaces: [SuggestedPlace] = []
    @State private var countries: [Country] = []
    
    @State var layoverHours = ""
    @State var selectedDate = Date()
    @State var selectedLocation: SelectedSearchCity? = nil
    @State var selectedThingsToDo: [String] = []

    @Namespace private var namespace

    func getSuggestedPlans() async {
        let suggestions = await network.getAISuggestions("\(selectedLocation!.city), \(selectedLocation!.name)", selectedThingsToDo, layoverHours)
        suggestedPlaces = suggestions

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            loading = false
            showSuggestedPlaces = true
        }
    }
    
    func generatePlan() async {
        if (selectedLocation == nil || selectedThingsToDo.count == 0 || layoverHours.isEmpty || loading || showEmojis) {
            return
        }
        
        withAnimation(.linear(duration: 0.5)) {
            isButtonPressed.toggle()
//            showEmojis.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 0.2)) {
                isButtonPressed.toggle()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.linear(duration: 0.2)) {
//                showEmojis = false
                loading = true
                Task { await getSuggestedPlans() }
            }
        }
    }
    
    var body: some View {
        ZStack {
            
            if (loading) {
                Loader()
            }
            
            if (!loading) {
                TabView(selection: $activeTab) {
                    LayoverDestination(countries: $countries, showCountryList: $showCountryList, showSearchBar: $showSearchBar, selectedLocation: $selectedLocation)
                    .tag(1)
                
                    ThingsToDo(selectedThingsToDo: $selectedThingsToDo)
                    .tag(2)
                    
                    LayoverTiming(layoverHours: $layoverHours)
                    .tag(3)
                    
                }
                .tabViewStyle(PageTabViewStyle())
                .animation(.easeInOut)
                .edgesIgnoringSafeArea(.bottom)
                
                if (!showCountryList) {
                    GeometryReader { geometry in
                        ZStack {
                            VStack {
                                Text(activeTab == 3 ? "Explore suggestions" : "Next")
                                    .font(.custom("Roboto-Medium", size: 20))
                                    .padding()
                                    .foregroundColor(.white)
                            }
                            .frame(width: !isButtonPressed ? 300 : 280)
                            .frame(height: !isButtonPressed ? 50 : 30)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(#colorLiteral(red: 0.04705882353, green: 0.04705882353, blue: 0.04705882353, alpha: 1)),
                                        Color(#colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1))
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                            .onTapGesture {
                                if (activeTab < 3) {
                                    activeTab += 1
                                    return
                                }
                                Task {
                                    await generatePlan()
                                }
                            }
//                            .opacity((selectedLocation == nil || selectedThingsToDo.count == 0 || layoverHours == "0") ? 0.6 : 1)

//                            if showEmojis {
//                                ZStack {
//                                    ForEach(emojis, id: \.self) { emoji in
//                                        EmojiExplosion(emoji: emoji, screenSize: geometry.size)
//                                    }
//                                }
//                                .offset(x: geometry.size.width/2, y: geometry.size.height/2)
//                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                }
            }
            
        }
        .padding()
        .background(.white)
        .sheet(isPresented: $showSuggestedPlaces) {
            Suggestions(suggestions: $suggestedPlaces)
        }
        .task {
            countries = await network.getCountries()
            print(countries)
        }
    }
}

struct LayoverDetailsForm_Previews: PreviewProvider {
    static var previews: some View {
        LayoverDetailsForm()
            .environmentObject(Network())
    }
}
