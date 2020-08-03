//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by User on 7/29/20.
//  Copyright © 2020 Aidin. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {
    
    var weatherLocations: [WeatherLocation] = []
    var selectedLocationIndex = 0
    
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVIew.dataSource = self
        tableVIew.delegate = self
    }
    
    func saveLocation() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(weatherLocations) {
            print(weatherLocations)
            UserDefaults.standard.set(encoded, forKey: "weatherLocations")
        } else {
            print("Error")
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if tableVIew.isEditing{
            tableVIew.setEditing(false, animated: true)
            editBarButton.image = #imageLiteral(resourceName: "edit")
            addBarButton.isEnabled = true
        } else {
            tableVIew.setEditing(true, animated: true)
            editBarButton.image = #imageLiteral(resourceName: "tick")
            addBarButton.isEnabled = false
        }
    }
    
    @IBAction func unwingFromAdding(segue: UIStoryboardSegue) {
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
        if segue.identifier == "GetCity" {
        } else {
            selectedLocationIndex = tableVIew.indexPathForSelectedRow!.row
            saveLocation()
        }
    }
}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForLocations", for: indexPath)
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
        weatherLocations.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath
    }
}

