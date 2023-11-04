//
//  CountriesDataService.swift
//  AroundTheWorld
//
//  Created by Giuseppe Sardo on 4/11/2023.
//

import Foundation

class CountriesDataService {
    var countries: [(name: String, countryCode: String)] = []
    var countryInfo: CountryInfo?
    var borderCommonName: [String?] = []
    
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
                    self.countries = countryNamesAndCodes
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
                    self.countryInfo = decodedData
                    if let borders = decodedData.borders {
                        self.borderCommonName = borders.map { $0.commonName }
                    } else {
                        self.borderCommonName = []
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
