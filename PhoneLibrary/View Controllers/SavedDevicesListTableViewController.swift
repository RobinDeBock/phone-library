//
//  SavedDevicesListTableViewController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 21/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit

class SavedDevicesListTableViewController: UITableViewController {

    private var devices:[Device] = []
    private var brandNames:[String] = []
    private var devicesByBrandDict:[String:[Device]] = [:]
    
    private var showByBrand = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Reset the counter for new devices (so also the badge)
        DeviceRealmController.instance.resetNewDevicesCounter()
        //Can't be put on an observer, because if we delete rows ourselves, we want the animation to play
        //With the observer, the table is refreshed before the row can be deleted, so the index is incorrect
        //Could be fixed if we check each time the observer is called if this is the current screen
        loadData()
        tableView.reloadData()
    }
    
    private func loadData(){
        devices = DeviceRealmController.instance.devices.reversed()
        if showByBrand{
            brandNames = devices.brandNames().sorted()
            print(brandNames)
            devicesByBrandDict = devices.devicesByBrandDict()
        }
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

extension SavedDevicesListTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        print(brandNames)
        return showByBrand ? brandNames.count : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showByBrand{
            print(devicesByBrandDict[brandNames[section]]?.count ?? 0)
            return devicesByBrandDict[brandNames[section]]?.count ?? 0
        }else if section == 0 {
            return devices.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if showByBrand{
            return brandNames[section]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedDeviceCell", for: indexPath)
        var device:Device
        if showByBrand {
            device = devicesByBrandDict[brandNames[indexPath.section]]!.sort()[indexPath.row]
        }else{
            device = DeviceRealmController.instance.devices[indexPath.row]
        }
        cell.textLabel?.text = device.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else{return}
        if showByBrand{
            // Delete the row from the data source
            let deviceToBeRemoved = devicesByBrandDict[brandNames[indexPath.section]]!.sort()[indexPath.row]
            //Keep track whether we also need to delete the section
            if DeviceRealmController.instance.remove(favorite: deviceToBeRemoved){
                loadData()
                if tableView.numberOfSections != brandNames.count{
                    let indexSet = IndexSet(arrayLiteral: indexPath.section)
                    tableView.deleteSections(indexSet, with: .fade)
                }else{//section amount is unchanged
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }else{
            // Delete the row from the data source
            if DeviceRealmController.instance.removeByIndex(index: indexPath.row){
                loadData()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
    }
}
