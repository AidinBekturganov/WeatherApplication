//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by User on 7/29/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit
import Foundation


class SearchViewController: UITableViewController, UISearchControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var locations = LocationListViewController()
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchLocation: [WeatherLocation] = []
    var (name, lat, lon) = ("", 0.0, 0.0)
    
    var infoOfCities: (String, Double, Double) = ("", 0, 0) {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                (self.name, self.lat, self.lon) = self.infoOfCities
                let newLocation = WeatherLocation(name: self.name, latitude: self.lat, longitude: self.lon)
                self.searchLocation.append(newLocation)
                self.tableView.reloadData()
                self.searchBar.isHidden = true
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButton.isEnabled = false
        searchBar.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchLocation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSearch", for: indexPath)
        
        cell.textLabel?.text = searchLocation[indexPath.row].name
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchBarText = searchBar.text else { return }
        let cityRequest = ListModel(city: searchBarText)
        cityRequest.getCity { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let info):
                self?.infoOfCities = info
                self?.addBarButton.isEnabled = true
            }
        }
    }
}
