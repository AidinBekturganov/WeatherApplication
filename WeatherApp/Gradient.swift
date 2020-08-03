//
//  Gradient.swift
//  WeatherApp
//
//  Created by User on 8/2/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import Foundation
import UIKit

class Gradient {
    
    let gradient = CAGradientLayer()
    
    func setNightGradiant(view: UIView, gradient: CAGradientLayer) {
        let topColor = UIColor(red: 64/250, green: 61/250, blue: 106/250, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 82/250, green: 78/250, blue: 164/250, alpha: 1.0).cgColor
        gradient.frame = view.bounds
        gradient.colors = [topColor, bottomColor]
    }
    
    func setDayGradient(view: UIView, gradient: CAGradientLayer) {
        let topColor = UIColor(red: 255/250, green: 186/250, blue: 163/255, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 238/250, green: 204/250, blue: 168/250, alpha: 1.0).cgColor
        gradient.frame = view.bounds
        gradient.colors = [topColor, bottomColor]
    }
}
