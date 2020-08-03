//
//  MainModel.swift
//  WeatherApp
//
//  Created by User on 7/29/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import Foundation

struct Cities: Codable {
    var response: cities
}

struct cities: Codable {
    var name: String
    var coord: Coordinates
}

struct Coordinates: Codable {
    var lon: Double
    var lat: Double
}


