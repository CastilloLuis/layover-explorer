//
//  LayoverDetailsForm.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/13/23.
//

import SwiftUI

struct LayoverDetailsForm: View {
    @State var countrySearched = ""
    @State var showCountryList = false
    @State var showBackButton = false

    @Namespace private var namespace

    func filteredCountries() -> [Country] {
        if (countrySearched.isEmpty)  { return getCountries() }
        return getCountries().filter { country in
            country.name.contains(countrySearched)
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
                    .font(.system(size: 32, weight: .bold))
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
                
            } else {
                Text("Where's the layover?")
                    .font(.system(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search country", text: $countrySearched)
                        .padding(.leading)
                }
                .padding()
                .frame(width: 300, height: 55)
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
                            .font(.system(size: 28))
                        }
                    }
//                    .overlay(
//                        GeometryReader { geo in
//                            Color.clear.onAppear {
//                                contentSize = geo.size
//                            }
//                        }
//                    )
                }
                .padding(.top, -30)

            }
        }
        .padding()
        .frame(height: 500)
        .background(.white)
    }
}

struct LayoverDetailsForm_Previews: PreviewProvider {
    static var previews: some View {
        LayoverDetailsForm()
    }
}
