//
//  LayoverDetailsForm.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/13/23.
//

import SwiftUI
import CoreLocation

enum FocusField: Hashable {
  case field
}

let things_to_do = [
    [
        ["🍴", "eat"],
        ["🚎", "do half day tours"]
    ],
    [
        ["🗽", "go to iconic places"],
        ["💥", "be surprise"]
    ],
    [
        ["🍷", "have a drink"],
        ["🚖", "do a quick trip"]
    ]
]

let emojis = ["💥", "🚝", "🗽", "🚖", "🎆", "🌟", "🎉", "✨", "🌈", "🎇","💥", "🚝", "🗽", "🚖", "🎆", "🌟", "🎉", "✨", "🌈", "🎇","💥", "🚝", "🗽", "🚖", "🎆", "🌟", "🎉", "✨", "🌈", "🎇","💥", "🚝", "🗽", "🚖", "🎆", "🌟", "🎉", "✨", "🌈", "🎇"]

struct LayoverDetailsForm: View {
    @EnvironmentObject var network: Network
    
    @State var countrySearched = ""
    @State var showCountryList = false
    @State var showBackButton = false
    @State var loading = false
    @State private var isButtonPressed = false
    @State private var showSuggestedPlaces = false
    @State private var showEmojis = false
    
    @State private var suggestedPlaces: [SuggestedPlace] = []
    @State private var countries: [Country] = []
    
    @State var layoverHours = "0"
    @State var selectedDate = Date()
    @State var selectedLocation: SelectedSearchCity? = nil
    @State var selectedThingsToDo: [String] = []

    @Namespace private var namespace
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    func filteredCountries() -> [Country] {
        if (countrySearched.isEmpty)  { return countries }
        return countries.filter { country in
            country.cities.contains { elem in
                elem.contains(countrySearched)
            }
        }
    }
    
    func getSuggestedPlans() async {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let selectedDateStr = dateFormatter.string(from: selectedDate)
        
        let suggestions = await network.getAISuggestions("\(selectedLocation!.city), \(selectedLocation!.name)", selectedThingsToDo, selectedDateStr, layoverHours)
        suggestedPlaces = suggestions
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            loading = false
            showSuggestedPlaces = true
        }
    }
    
    func generatePlan() async {
        if (selectedLocation == nil || selectedThingsToDo.count == 0 || layoverHours == "0" || loading || showEmojis) {
            return
        }
        withAnimation(.linear(duration: 0.5)) {
            isButtonPressed.toggle()
            showEmojis.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 0.2)) {
                isButtonPressed.toggle()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.linear(duration: 0.2)) {
                showEmojis = false
                loading = true
                Task { await getSuggestedPlans() }
            }
        }
    }
    
    var body: some View {
        VStack {
            
            if (loading) {
                Loader()
            }
            
            if (!loading) {
                if (showCountryList) {
                    Button {
                        withTransaction(Transaction(animation: .timingCurve(0.25, 0.7, 0.5, 1.2, duration: 0.3))) {
                            showCountryList.toggle()
                        }
                        countrySearched = ""
                    } label: {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                    }
                    .padding(10)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                    .offset(x: showBackButton ? 0 : -100)
                    
                    Text("Where's the layover?")
                        .font(.custom("Roboto-Bold", size: 28))
                        .frame(maxWidth: .infinity)
                        .opacity(0)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search country", text: $countrySearched)
                            .padding(.leading)
                    }
                    .padding()
                    .frame(height: 65)
                    .frame(maxWidth: .infinity)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .background(Color(hex: "#f7f7f7"))
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 8
                        )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
                    .offset(y: -60)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                            withAnimation(.timingCurve(0.25, 0.7, 0.5, 1.2, duration: 0.3)) {
                                showBackButton.toggle()
                            }
                        }
                    }
                    .onDisappear {
                        showBackButton.toggle()
                    }
                    Spacer()
                } else {
                    Text("Where's the layover?")
                        .font(.custom("Roboto-Bold", size: 20))
                        .frame(maxWidth: .infinity)
                    
                    if (selectedLocation == nil) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search country", text: $countrySearched)
                                .padding(.leading)
                                .disabled(true)
                        }
                        .padding()
                        .frame(width: 300, height: 50)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#B0B0B0"), lineWidth: 2)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 8
                            )
                        )
                        .matchedGeometryEffect(id: "rectangle", in: namespace)
                        .onTapGesture {
                            withTransaction(Transaction(animation: .timingCurve(0.25, 0.7, 0.5, 1.2, duration: 0.3))) {
                                showCountryList.toggle()
                            }
                        }
                    } else {
                        HStack {
                            Text("\(selectedLocation?.flag ?? "") \(selectedLocation?.city ?? ""), \(selectedLocation?.name ?? "")")
                                .font(.custom("Roboto-Medium", size: 28))
                            Button {
                                selectedLocation = nil
                                withAnimation {
                                    countrySearched = ""
                                }
                            } label: {
                                Image(systemName: "multiply")
                            }
                            .foregroundColor(.black)
                            .padding(5)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 65)
                    }
                    
                    
                }

                if (showCountryList) {
                    ScrollView {
                        LazyVStack {
                            ForEach(
                                filteredCountries()
                            ) { country in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(createEmojiFlag(isoCode: country.iso2) ?? "🏳️")
                                        Text(country.name)
                                    }
                                    .font(.custom("Roboto-Medium", size: 30))
                                    VStack {
                                        ForEach (country.cities, id: \.self) { city in
                                            VStack {
                                                Text(city)
                                                    .font(.custom("Roboto-Regular", size: 25))
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding([.top, .bottom], 10)
                                            .onTapGesture {
                                                selectedLocation = SelectedSearchCity(
                                                    name: country.name,
                                                    flag: "\(createEmojiFlag(isoCode: country.iso2) ?? "🏳️")",
                                                    city: city
                                                )
                                                showCountryList.toggle()
                                            }
                                        }
                                    }
                                    Divider()
                                }
                                .padding(.bottom, 15)
                            }
                        }
                    }
                    .padding(.top, -30)
                }
                
                if (!showCountryList) {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Text("I'd like to...")
                        .font(.custom("Roboto-Bold", size: 20))
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
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                if (!showCountryList) {
                    VStack {
                        Text("When's the layover")
                            .font(.custom("Roboto-Bold", size: 20))
                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                
                if (!showCountryList) {
                    VStack {
                        Text("How many hours?")
                            .font(.custom("Roboto-Bold", size: 20))
                        TextField("", text: $layoverHours)
                            .keyboardType(.numberPad)
                            .padding()
                            .frame(width: 100, height: 50)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .font(.custom("Roboto-Regular", size: 40))
                            .multilineTextAlignment(.center)
                            .background(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "#B0B0B0"), lineWidth: 2)
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 8
                                )
                            )
                    }
                }

                if (!showCountryList) {
                    GeometryReader { geometry in
                        ZStack {
                            VStack {
                                Text("Create Plan")
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
                                Task {
                                    await generatePlan()
                                }
                            }
                            .opacity((selectedLocation == nil || selectedThingsToDo.count == 0 || layoverHours == "0") ? 0.6 : 1)
                            
                            if showEmojis {
                                ZStack {
                                    ForEach(emojis, id: \.self) { emoji in
                                        EmojiExplosion(emoji: emoji, screenSize: geometry.size)
                                    }
                                }
                                .offset(x: geometry.size.width/2, y: geometry.size.height/2)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
