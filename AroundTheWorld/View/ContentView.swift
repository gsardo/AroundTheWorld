//
//  ContentView.swift
//  AroundTheWorld
//
//  Created by Giuseppe Sardo on 26/3/2023.
//

import SwiftUI

struct ContentView: View { //View
    @State private var selectedCountryIndex = 0
    @State private var countries = [Country]() // ViewModel is where data is maniuplated
    @State private var countryInfo: CountryInfo?
    @State private var borderCommonName: [String?] = []
    @State var viewModel = CountriesViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select a country", selection: $selectedCountryIndex) {
                        ForEach(countries.indices, id: \.self) { index in
                            Text("\(countries[index].name) (\(countries[index].countryCode))")
                        }
                    }
                }
                
                if let countryInfo = countryInfo {
                    Text("Official name: \(countryInfo.officialName)")
                    Text("Region: \(countryInfo.region)")
                    let borderCommonNames = borderCommonName
                        Text("Bordering countries:")
                        ForEach(borderCommonNames, id: \.self) { commonName in
                            Text(commonName ?? "None found")

                    }
                } else {
                    Text("Select a country to view information")
                }
            }
            .navigationBarTitle(Text("AroundTheWorld"), displayMode: .inline)
            .onAppear {
                viewModel.fetchAllCountries()
            }
            .onChange(of: selectedCountryIndex) { _ in
                if let countryCode = countries[selectedCountryIndex].countryCode.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
                    viewModel.fetchAllInfo(code: countryCode)
                }
            }
        }
    }
}

//Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
