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

struct LayoverDetailsForm: View {
    @EnvironmentObject var network: Network
    
    @State var countrySearched = ""
    @State var showCountryList = false
    @State var showBackButton = false
    @State private var isButtonPressed = false
    @State private var isShowingSheet = false
    
    @State private var selectedDate = Date()
    @State var selectedCountry: Country? = nil
    @State var selectedThingsToDo: [String] = []

    @Namespace private var namespace
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    func filteredCountries() -> [Country] {
        if (countrySearched.isEmpty)  { return getCountries() }
        return getCountries().filter { country in
            country.name.contains(countrySearched)
        }
    }
    
    func tryApi() async {
        await network.helloWorldFlask()
    }

    func openMaps(_ latitude: Double, _ longitude: Double) {
        let urlString = "http://maps.apple.com/?ll=\(latitude),\(longitude)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    var body: some View {
        VStack {
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
                
                if (selectedCountry == nil) {
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
                        Text("\(selectedCountry?.flag ?? "") \(selectedCountry?.name ?? "")")
                            .font(.custom("Roboto-Medium", size: 30))
                        Button {
                            selectedCountry = nil
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

            if (showCountryList && !countrySearched.isEmpty) {
                ScrollView {
                    LazyVStack {
                        ForEach(
                            filteredCountries()
                        ) { country in
                            HStack {
                                Text(country.flag)
                                Text(country.name)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 15)
                            .font(.system(size: 20))
                            .onTapGesture {
                                selectedCountry = country
                                showCountryList.toggle()
                            }
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
                    Text("Create Plan")
                        .font(.headline)
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
                    isShowingSheet.toggle()
                    if (selectedCountry == nil || selectedThingsToDo.count == 0) {
                        return
                    }
                    print(selectedDate)
                    withAnimation(.linear(duration: 0.5)) {
                        isButtonPressed.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.linear(duration: 0.2)) {
                            isButtonPressed.toggle()
                        }
                    }
                }
                .opacity(selectedCountry == nil || selectedThingsToDo.count == 0 ? 0.6 : 1)
            }
        }
        .padding()
        .background(.white)
        .sheet(isPresented: $isShowingSheet) {
            VStack {
                Text("Custom plan")
                    .font(.headline)
                ScrollView {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Mercado San Miguel")
                                .font(.headline)
                            Text("The Archeological Museum of Madrid holds an extensive collection of pre-historical and classical antiquities. The museum contains artifacts from throughout the Iberian Peninsula.")
                                .font(.custom("Roboto-Regular", size: 12)).lineLimit(3)
                                .truncationMode(.tail)
                            Text("https://website.com")
                                .font(.custom("Roboto-Regular", size: 10))
                            Spacer()
                            Text("🚕 30 minutes")
                                .font(.custom("Roboto-Regular", size: 15))
                            Text("🚝 30 minutes")
                                .font(.custom("Roboto-Regular", size: 15))
                        }
                        VStack {
                            MapPreview(coordinate:  CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060))
                        }
                        .frame(width: 120, height: 100)
                        .cornerRadius(10)
                        .onTapGesture {
                            openMaps(40.7128, -74.0060)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "FDFDFD"), Color(hex: "F4F4F4")]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(15)
                    .padding()
                    .shadow(color: Color.gray.opacity(0.25), radius: 10, x: 0, y: 2)


                }
                .frame(maxWidth: .infinity)
                Spacer()
            }
            .padding()
        }
        .task {
            await tryApi()
        }
    }
}

struct LayoverDetailsForm_Previews: PreviewProvider {
    static var previews: some View {
        LayoverDetailsForm()
            .environmentObject(Network())
    }
}
