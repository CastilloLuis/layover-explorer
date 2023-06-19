//
//  LayoverDestination.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/19/23.
//

import SwiftUI

struct LayoverDestination: View {
    
    @Binding var countries: [Country]
    @Binding var showCountryList: Bool
    @Binding var showSearchBar: Bool
    @Binding var selectedLocation: SelectedSearchCity?
    
    @State var countrySearched = ""
    @State var showBackButton = false

    @Namespace private var namespace
    
    func filteredCountries() -> [Country] {
        if (countrySearched.isEmpty)  { return countries }
        return countries.filter { country in
            country.cities.contains { elem in
                elem.lowercased().contains(countrySearched.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack {
            if (showSearchBar) {
                Button {
                    withTransaction(Transaction(animation: .timingCurve(0.25, 0.7, 0.5, 1.2, duration: 0.2))) {
                        showSearchBar.toggle()
                    }
                    countrySearched = ""
                    showCountryList.toggle()
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
                        withAnimation(.timingCurve(0.25, 0.7, 0.5, 1.2, duration: 0.2)) {
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
                        withTransaction(Transaction(animation: .timingCurve(0.25, 0.7, 0.5, 1.2, duration: 0.2))) {
                            showSearchBar.toggle()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
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
                            filteredCountries(), id: \.self
                        ) { country in
                            LazyVStack(alignment: .leading) {
                                LazyHStack {
                                    Text(createEmojiFlag(isoCode: country.iso2) ?? "🏳️")
                                    Text(country.name)
                                }
                                .font(.custom("Roboto-Medium", size: 30))
                                LazyVStack {
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
                                            showSearchBar.toggle()
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
                .animation(nil)
            }
        }
    }
}

struct LayoverDestination_Previews: PreviewProvider {
    static var previews: some View {
        LayoverDestination(
            countries: .constant([]),
            showCountryList: .constant(false),
            showSearchBar: .constant(false),
            selectedLocation: .constant(nil)
        )
    }
}
