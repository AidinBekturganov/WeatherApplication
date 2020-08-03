//
//  WeatherLocation.swift
//  WeatherApp
//
//  Created by User on 7/29/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}


