//
//  ListModel.swift
//  WeatherApp
//
//  Created by User on 7/29/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import Foundation

enum CityError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct ListModel {
    let resourceURL: URL
    let apiKey = "305b4bde581a31882242b4d4358bf25f"
    
    init(city: String) {
        
        let resourceString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        
        guard let resourceUrl = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceUrl
    }
    
    func getCity(completion: @escaping(Result<(String, Double, Double), CityError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let citiesResponse = try decoder.decode(cities.self, from: jsonData)
                let citiesDetails = citiesResponse.name
                let citiesLat = citiesResponse.coord.lat
                let citiesLon = citiesResponse.coord.lon
                completion(.success((citiesDetails , citiesLat, citiesLon)))
                
            } catch {
                completion(.failure(.canNotProcessData))
            }
            
        }
        dataTask.resume()
    }
}



