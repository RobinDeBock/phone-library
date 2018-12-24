//
//  DeviceListTableViewController.swift
//  DeviceLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit

class DevicesListTableViewController: UITableViewController {

    var searchValue: String?
    var searchType:SearchType?
    
    var devices:[Device]=[]
    
    enum SearchType {
        case SearchByBrand
        case SearchByName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(searchValue!)
        print(searchType!)
        
        loadDevices()
    }
    
    //Fetch the phones depending on the search type
    private func loadDevices(){
        guard let searchValue = searchValue, let searchType = searchType else {return}
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        switch searchType {
        case SearchType.SearchByBrand:
                DeviceNetworkController.instance.fetchDevicesByBrand(searchValue){fetchedPhones in
                    self.updateUI(with: fetchedPhones)
            }
        case SearchType.SearchByName:
            DeviceNetworkController.instance.fetchDevicesByName(searchValue){fetchedPhones in
                  self.updateUI(with: fetchedPhones)
                }
            }
        }
    
    
    private func updateUI(with fetchedPhones:[Device]?){
    DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //if list is empty show warning and stuff
        if let fetchedPhones = fetchedPhones {
            print(fetchedPhones)
            self.devices = fetchedPhones
            self.tableView.reloadData()
            }
        }
    }

    //Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return devices.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        //get the right phone
        let phone = devices[indexPath.row]
        cell.textLabel?.text = phone.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
        /*
        if DeviceRealmController.instance.add(favorite: devices[indexPath.row]){
            tableView.deselectRow(at: indexPath, animated: true)
        }*/
    }

}
