//
//  Countries.swift
//  AroundTheWorld
//
//  Created by Giuseppe Sardo on 4/11/2023.
//

import Foundation

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
