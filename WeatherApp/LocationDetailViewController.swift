//
//  LocationDetailViewController.swift
//  WeatherApp
//
//  Created by User on 7/30/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    print("JUST CREATED DATE FORMATTER")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d, h:mm aaa"
    return dateFormatter
}()

class LocationDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temparuterLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundOfDayOrNight: UIView!
    
    var weatherDetail: WeatherDetail!
    var locationIndex = 0
    let gradient = CAGradientLayer()
    var locationManager: CLLocationManager!
    let backView = UIView()
    let gradientClass = Gradient()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundOfDayOrNight.layer.addSublayer(gradient)
        tableView.tableFooterView = backView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        
        if locationIndex == 0 {
            getLocation()
        }
        
        updateUserInterface()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateUserInterface() {
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        let weatherLocation = pageViewController.weatherLocations[locationIndex]
        weatherDetail = WeatherDetail(name: weatherLocation.name, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
        
        
        pageControll.numberOfPages = pageViewController.weatherLocations.count
        pageControll.currentPage = locationIndex
        weatherDetail.getData() {
            DispatchQueue.main.async {
                dateFormatter.timeZone = TimeZone(identifier: self.weatherDetail.timezome)
                let usableDate = Date(timeIntervalSince1970: self.weatherDetail.current)
                self.dateLabel.text = dateFormatter.string(from: usableDate)
                self.placeLabel.text = weatherLocation.name
                self.temparuterLabel.text = "\(self.weatherDetail.temperature)°"
                self.summaryLabel.text = self.weatherDetail.summary
                self.imageView.image = UIImage(named: "\(self.weatherDetail.dayIcon)")
                print(self.weatherDetail.dayIcon)
                let suffix = self.weatherDetail.dayIcon.suffix(1)
                if suffix == "n" {
                    self.gradientClass.setNightGradiant(view: self.backgroundOfDayOrNight, gradient: self.gradient)
                } else {
                    self.gradientClass.setDayGradient(view: self.backgroundOfDayOrNight, gradient: self.gradient)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationListViewController
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        destination.weatherLocations = pageViewController.weatherLocations
    }
    
    @IBAction func unwindFromLocationViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! LocationListViewController
        locationIndex = source.selectedLocationIndex
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        pageViewController.weatherLocations = source.weatherLocations
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: locationIndex)], direction: .forward, animated: false, completion: nil)
    }
    
    @IBAction func pageControllTapped(_ sender: UIPageControl) {
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        let direction: UIPageViewController.NavigationDirection
        if sender.currentPage < locationIndex {
            direction = .reverse
        } else {
            direction = .forward
        }
        
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: sender.currentPage)], direction: direction, animated: true, completion: nil)
    }
    
    
    
}

extension LocationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let label = UILabel()
        label.text = "The Data is Loading"
        backView.addSubview(label)
        return weatherDetail.dailyWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForDetails", for: indexPath)
        if let label = cell.viewWithTag(1001) as? UILabel {
            label.text = weatherDetail.dailyWeatherData[indexPath.row].dailyWeekday
        }
        if let labelWithHighTemp = cell.viewWithTag(1002) as? UILabel {
            labelWithHighTemp.text = "\(weatherDetail.dailyWeatherData[indexPath.row].dailyHigh)°"
        }
        if let labelWithLowTemp = cell.viewWithTag(1003) as? UILabel {
            labelWithLowTemp.text = "\(weatherDetail.dailyWeatherData[indexPath.row].dailyLow)°"
        }
        if let labelWithSummary = cell.viewWithTag(1004) as? UILabel {
            labelWithSummary.text = "\(weatherDetail.dailyWeatherData[indexPath.row].dailySummary)°"
        }
        if let labelWithImage = cell.viewWithTag(1005) as? UIImageView {
            labelWithImage.image = UIImage(named: weatherDetail.dailyWeatherData[indexPath.row].dailyIcon)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension LocationDetailViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthentificationStatus(status: status)
    }
    
    func oneButtonAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleAuthentificationStatus(status: CLAuthorizationStatus) {
        
        switch status {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            oneButtonAlert(title: "Location service has been denied", message: "It may be that parental controls are restricting location use in this app")
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location service", message: "Select 'Settings' below to enable getting your current location" )
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("ERROR \(status)")
        }
    }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
        }
        let cancelActions = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelActions)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last ?? CLLocation()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            var locationName = ""
            if placemarks != nil {
                let placemark = placemarks?.last
                locationName = placemark?.name ?? "Parts unknown"
            } else {
                print(error?.localizedDescription)
                locationName = "Couldn'n find the place"
            }
            
            let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
            pageViewController.weatherLocations[self.locationIndex].latitude = currentLocation.coordinate.latitude
            pageViewController.weatherLocations[self.locationIndex].longitude = currentLocation.coordinate.longitude
            pageViewController.weatherLocations[self.locationIndex].name = locationName
            
            self.updateUserInterface()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
