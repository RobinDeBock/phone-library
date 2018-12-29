//
//  DeviceListTableViewController.swift
//  DeviceLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit

class DevicesListTableViewController:UITableViewController {

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

        guard let fetchedPhones = fetchedPhones else{
            //if list is nil, an error occured
            let alertController = UIAlertController(title: "Something went wrong", message: "An error occured when fetching the devices, please try again.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Go Back", style: UIAlertAction.Style.default,handler: {action in
                //Go back to SearchViewController
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        //Load devices
        self.devices = fetchedPhones
        self.tableView.reloadData()
        
        //Showing a message when no devices are present
        if fetchedPhones.isEmpty{
            //TODO:show message
        }
        }
        
    }

}

extension DevicesListTableViewController{
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
