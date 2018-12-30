//
//  SavedDevicesListTableViewController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 21/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit

class SavedDevicesListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Reset the counter for new devices (so also the badge)
        DeviceRealmController.instance.resetNewDevicesCounter()
        //Can't be put on an observer, because if we delete rows ourselves, we want the animation to play
        //With the observer, the table is refreshed before the row can be deleted, so the index is incorrect
        //Could be fixed if we check each time the observer is called if this is the current screen, but why bother, this is much cleaner
        tableView.reloadData()
    }

}

extension SavedDevicesListTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return DeviceRealmController.instance.devices.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedDeviceCell", for: indexPath)
        let phone = DeviceRealmController.instance.devices[indexPath.row]
        cell.textLabel?.text = phone.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if DeviceRealmController.instance.removeByIndex(index: indexPath.row){
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
