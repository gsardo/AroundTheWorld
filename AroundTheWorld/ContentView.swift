//
//  ContentView.swift
//  AroundTheWorld
//
//  Created by Giuseppe Sardo on 26/3/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedCountryIndex = 0
    @State private var countries: [(name: String, countryCode: String)] = []
    @State private var countryInfo: CountryInfo?
    @State private var borderCommonName: [String] = []
    
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
                    if let borderCommonNames = borderCommonName, !borderCommonName.isEmpty {
                        Text("Bordering countries:")
                        ForEach(borderCommonNames, id: \.self) { commonName in
                            Text(commonName)
                        }
                    }
                } else {
                    Text("Select a country to view information")
                }
            }
            .navigationBarTitle(Text("AroundTheWorld"), displayMode: .inline)
            .onAppear {
                fetchCountries()
            }
            .onChange(of: selectedCountryIndex) { _ in
                if let countryCode = countries[selectedCountryIndex].countryCode.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
                    fetchCountryInfo(countryCode: countryCode)
                }
            }
        }
    }
    
    // fetch from API
    func fetchCountries() {
        guard let url = URL(string: "https://date.nager.at/api/v3/AvailableCountries") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Country].self, from: data)
                let countryNamesAndCodes = decodedData.map { (name: $0.name, countryCode: $0.countryCode) }
                DispatchQueue.main.async {
                    countries = countryNamesAndCodes
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func fetchCountryInfo(countryCode: String) {
        guard let url = URL(string: "https://date.nager.at/api/v3/CountryInfo/\(countryCode)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(CountryInfo.self, from: data)
                DispatchQueue.main.async {
                    countryInfo = decodedData
                    if let borders = decodedData.borders {
                        borderCommonName = borders.map { $0.commonName }
                    } else {
                        borderCommonName = []
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}


//JSON responses
struct Country: Codable {
    let name: String
    let countryCode: String
}

struct CountryInfo: Codable {
    let officialName: String
    let region: String
    let borders: [Border]?
}

struct Border: Codable {
    let commonName: String
    let countryCode: String
}

//Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
