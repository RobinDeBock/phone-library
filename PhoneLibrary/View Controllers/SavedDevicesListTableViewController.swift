//
//  SavedDevicesListTableViewController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 21/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SavedDevicesListTableViewController: UITableViewController {

    private var devices:[Device] = []
    private var brandNames:[String] = []
    private var devicesByBrandDict:[String:[Device]] = [:]
    
    private var showByBrand = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Empty tableview placeholder
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Reset the counter for new devices (so also the badge)
        DeviceRealmController.instance.resetNewDevicesCounter()
        //Can't be put on an observer, because if we delete rows ourselves, we want the animation to play
        //With the observer, the table is refreshed before the row can be deleted, so the index is incorrect
        //Could be fixed if we check each time the observer is called if this is the current screen
        loadData()
        updateTableViewForDevicesAmount()
        tableView.reloadData()
    }
    
    private func loadData(){
        devices = DeviceRealmController.instance.devices.reversed()
        if showByBrand{
            brandNames = devices.brandNames().sorted()
            devicesByBrandDict = devices.devicesByBrandDict()
        }
    }
    
    private func updateTableViewForDevicesAmount(){
        if devices.count <= 0 {
            navigationItem.rightBarButtonItem = nil
        }else{
            navigationItem.rightBarButtonItem = editButtonItem
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
        return showByBrand ? brandNames.count : devices.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showByBrand{
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
            let brandName = brandNames[indexPath.section]
            device = devicesByBrandDict[brandName]!.sort()[indexPath.row]
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
                //Check if placeholder needs to be shown
                if devices.count <= 0 {
                    self.tableView.reloadEmptyDataSet()
                }
            }
        }else{
            // Delete the row from the data source
            if DeviceRealmController.instance.removeByIndex(index: indexPath.row){
                loadData()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        updateTableViewForDevicesAmount()
    }
}

//Empty dataset
extension SavedDevicesListTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 30, weight: .heavy)]
        return NSAttributedString(string: "No favorites", attributes:attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)]
        return NSAttributedString(string: "Find a device and save to favorites", attributes:attributes)
    }
    
}
