//
//  SavedDevicesListTableViewController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 21/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SavedDevicesListTableViewController:UIViewController {
    struct PropertyKeys {
        static let showDetail = "showDetail"
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    private var devices:[Device] = []
    private var brandNames:[String] = []
    private var devicesByBrandDict:[String:[Device]] = [:]
    private var newDevices:[Device] = []
    
    private var showByBrand = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Empty tableview placeholder
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        //Select the correct segmentedControl option
        segmentedControl.selectedSegmentIndex = showByBrand ? 0 : 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Reset the counter for new devices (so also the badge)
        DeviceRealmController.instance.resetNewDevicesCounter()
        //Disable editing mode on tableView
        updateTableViewEditingMode(enabled: false)
        //Can't be put on an observer, because if we delete rows ourselves, we want the animation to play
        //With the observer, the table is refreshed before the row can be deleted, so the index is incorrect
        //Could be fixed if we check each time the observer is called if this is the current screen
        loadData()
        tableView.reloadData()
    }
    
    
    @IBAction func editBarButtonItemTapped(_ sender: Any) {
        let tableViewEditingMode = !tableView.isEditing
        updateTableViewEditingMode(enabled: tableViewEditingMode)
    }
    
    private func updateTableViewEditingMode(enabled:Bool){
        tableView.setEditing(enabled, animated: true)
        //Change text
        editBarButtonItem.title = enabled ? NSLocalizedString("Done", comment: "Edit bar button item") : NSLocalizedString("Edit", comment: "Edit bar button item")
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        //update selected value
        showByBrand = segmentedControl.selectedSegmentIndex == 0
        //fetch data accordingly
        loadData()
        tableView.reloadData()
    }
    
    private func loadData(){
        devices = []
        newDevices = []
        devices = DeviceRealmController.instance.devices
        switch showByBrand {
        case true:
            brandNames = devices.brandNames().sorted()
            devicesByBrandDict = devices.devicesByBrandDict()
            updateTableViewForDevicesAmount()
        case false:
            //new devices array
            newDevices = DeviceRealmController.instance.newlyAddedDevices
            //all devices, ordered by newest first, without new devices
            devices = devices.reversed()
            //filter out the new devices
            devices = devices.filter{device in
                !newDevices.contains{$0.name == device.name}
            }
        }
        updateTableViewForDevicesAmount()
    }
    
    private func updateTableViewForDevicesAmount(){
        //Enable edit button when devices are present
        if newDevices.count > 0 || devices.count > 0 {
            editBarButtonItem.isEnabled = true
        }else{
            editBarButtonItem.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case PropertyKeys.showDetail:
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.device = devices[tableView.indexPathForSelectedRow!.row]
        default:
            fatalError("Unknown segue")
        }
    }

}

extension SavedDevicesListTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch showByBrand {
        case true:
            return brandNames.count
        case false:
            //Return number of sections based on new device amount and/or device amount
            if newDevices.count > 0 && devices.count > 0 {
                return 2
            }else if newDevices.count > 0 || devices.count > 0{
                return 1
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch showByBrand {
        case true:
             return devicesByBrandDict[brandNames[section]]?.count ?? 0
        case false:
            if newDevices.count > 0 && section == 0 {
                //There is a section for new devices
                return newDevices.count
            }else{
                return devices.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch showByBrand {
        case true:
                 return brandNames[section]
        case false:
            if newDevices.count > 0 && section == 0 {
                //New devices
                return "New devices"
            }
            //All devices
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedDeviceCell", for: indexPath)
        var device:Device
        switch showByBrand {
        case true:
            let brandName = brandNames[indexPath.section]
            device = devicesByBrandDict[brandName]!.sort()[indexPath.row]
        case false:
            if newDevices.count > 0 && indexPath.section == 0 {
                //New devices
                device = newDevices[indexPath.row]
            }else{
                //All devices
                device = devices[indexPath.row]
            }
        }
        cell.textLabel?.text = device.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else{return}
        switch showByBrand{
        case true:
            let deviceToBeRemoved = devicesByBrandDict[brandNames[indexPath.section]]!.sort()[indexPath.row]
            //Keep track whether we also need to delete the section
            if DeviceRealmController.instance.remove(favorite: deviceToBeRemoved){
                //update local variables
                loadData()
                
                if tableView.numberOfSections != brandNames.count{
                    let indexSet = IndexSet(arrayLiteral: indexPath.section)
                    //Delete the whole section
                    tableView.deleteSections(indexSet, with: .fade)
                }else{//section amount is unchanged
                    // Delete the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        case false:
            var deviceToBeRemoved:Device
            if indexPath.section == 0 && newDevices.count > 0{
                //Remove a device from new devices section
                deviceToBeRemoved = newDevices[indexPath.row]
            }else{
                //There are new devices, but it's the second section
                //There are no new devices
                deviceToBeRemoved = devices[indexPath.row]
            }
            // Delete the row from the data source
            if DeviceRealmController.instance.remove(favorite: deviceToBeRemoved){
                //update local variables
                loadData()
                //Check if amount of section is changed
                if tableView.numberOfSections == 2 && (newDevices.count == 0 || devices.count == 0) ||
                    tableView.numberOfSections == 1 && (newDevices.count == 0 && devices.count == 0){
                    let indexSet = IndexSet(arrayLiteral: indexPath.section)
                    //Delete the whole section
                    tableView.deleteSections(indexSet, with: .fade)
                }else{//section amount is unchanged
                    // Delete the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
        //Check if placeholder needs to be shown
        if newDevices.count <= 0 && devices.count <= 0 {
            self.tableView.reloadEmptyDataSet()
        }
    }
}

//Empty dataset
extension SavedDevicesListTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 30, weight: .heavy)]
        return NSAttributedString(string: NSLocalizedString("No favorites", comment: "Empty dataset placeholder title"), attributes:attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)]
        return NSAttributedString(string: NSLocalizedString("Find a device and save to favorites", comment: "Empty dataset placeholder description"), attributes:attributes)
    }
    
}
