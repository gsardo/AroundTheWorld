//
//  CountriesViewModel.swift
//  AroundTheWorld
//
//  Created by Giuseppe Sardo on 4/11/2023.
//

import Foundation

class CountriesViewModel {
    
    private let service = CountriesDataService()
    private var countries = [Country]()
    
    init() {
        fetchAllCountries()
    }
    
    func fetchAllCountries() {
        service.fetchCountries()
    }
    
    func fetchAllInfo(code: String) {
        service.fetchCountryInfo(countryCode: code)
    }
}
