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
        
        loadDevices()
    }
    
    //Fetch the phones depending on the search type
    private func loadDevices(){
        guard let searchValue = searchValue, let searchType = searchType else {return}
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        switch searchType {
        case SearchType.SearchByBrand:
                DeviceNetworkController.instance.fetchDevicesByBrand(searchValue){fetchedPhones in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.updateUI(with: fetchedPhones)
            }
        case SearchType.SearchByName:
            DeviceNetworkController.instance.fetchDevicesByName(searchValue){fetchedPhones in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                  self.updateUI(with: fetchedPhones)
                }
            }
        }
    
    
    private func updateUI(with fetchedPhones:[Device]?){
    DispatchQueue.main.async {
        guard let fetchedPhones = fetchedPhones else{
            //if list is nil, an error occured
            self.showAlert(with: "Devices could not be fetched")
            return
        }
            self.devices = fetchedPhones
            self.tableView.reloadData()
        }
    }
    
    private func showAlert(with message:String){
        let alertController = UIAlertController(title: "iOScreator", message: "Hello, world!", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
        let device = devices[indexPath.row]
        cell.textLabel?.text = device.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetail":
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.device = devices[tableView.indexPathForSelectedRow!.row]
        default:
            fatalError("Unknown segue")
        }
    }

}
