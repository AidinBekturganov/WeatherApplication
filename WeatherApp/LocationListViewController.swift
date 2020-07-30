//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by User on 7/29/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {

    @IBOutlet weak var tableVIew: UITableView!
    var weatherLocations: [WeatherLocation] = []
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var weatherLocation = WeatherLocation(name: "Bishkek", latitude: 12.12412, longitude: 12.1241245)
        weatherLocations.append(weatherLocation)
        weatherLocation = WeatherLocation(name: "Tokmok", latitude: 4.12412, longitude: 15.5262)
        weatherLocations.append(weatherLocation)
        weatherLocation = WeatherLocation(name: "Naryn", latitude: 12.1242, longitude: 12.11545)
        weatherLocations.append(weatherLocation)
        tableVIew.dataSource = self
        tableVIew.delegate = self
    }

    @IBAction func addButtonPressed(_ sender: Any) {
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        if tableVIew.isEditing{
            tableVIew.setEditing(false, animated: true)
           // sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableVIew.setEditing(true, animated: true)
           // sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    @IBAction func unwingFromAdding(segue: UIStoryboardSegue){
        let source = segue.source as! SearchViewController
        let newIndex = IndexPath(row: weatherLocations.count, section: 0)
        if source.searchLocation.isEmpty{
            return
        } else {
            weatherLocations.append(source.searchLocation[0])
            tableVIew.insertRows(at: [newIndex], with: .bottom)
            tableVIew.scrollToRow(at: newIndex, at: .bottom, animated: true)
            print(weatherLocations.count)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GetCity"{
            
        }
    }
    

}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = weatherLocations[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = weatherLocations[sourceIndexPath.row]
        weatherLocations.remove(at: sourceIndexPath.row)
        weatherLocations.insert(itemToMove, at: sourceIndexPath.row)
    }
    
}

