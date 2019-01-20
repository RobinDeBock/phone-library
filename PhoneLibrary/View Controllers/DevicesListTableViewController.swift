//
//  DeviceListTableViewController.swift
//  DeviceLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class DevicesListTableViewController:UITableViewController{

    struct PropertyKeys {
        static let showDetail = "showDetail"
    }
    
    var searchValue: String?
    var searchType:SearchType?
    
    var devices:[Device]=[]
    private var emptyListPlaceHolderIsShown:Bool = false
    
    enum SearchType {
        case SearchByBrand
        case SearchByName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide the seperators
        self.tableView.separatorStyle = .none
        
        //Empty tableview placeholder
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        //Add observer for the devices list
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: DeviceRealmController.devicesUpdatedNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Heavy task
        loadDevices()
    }
    
    //Using a seperate function to reload the tableview
    @objc private func reload(){
        tableView.reloadData()
    }
    
    //Fetch the phones depending on the search type
    private func loadDevices(){
        guard let searchValue = searchValue, let searchType = searchType else {return}
        
        //Show activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        switch searchType {
        case SearchType.SearchByBrand:
                DeviceNetworkController.instance.fetchDevicesByBrand(searchValue){(fetchedDevices, error) in
                   self.handleFetchedDevices(fetchedDevices, error: error)
            }
        case SearchType.SearchByName:
            DeviceNetworkController.instance.fetchDevicesByName(searchValue){(fetchedDevices, error) in
                    self.handleFetchedDevices(fetchedDevices, error: error)
                }
            }
        }
    
    private func handleFetchedDevices(_ fetchedDevices:[Device]?, error:DeviceNetworkController.NetworkError?){
        //Hide activity indicator
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //If error is present, we check what type it is and handle accordingly
        if let error = error{
            switch error{
            case .EmptyApiKey:
                let alertController = UIAlertController(title: NSLocalizedString("Missing API token", comment: "Error alert title"), message: NSLocalizedString("There is no token present, necessary for using the API. \n Please get a viable token at fonoapi.freshpixl.com.", comment: "Error alert message"), preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Go Back", comment:""), style: UIAlertAction.Style.default,handler: {action in
                    //Go back to SearchViewController
                    self.navigationController?.popViewController(animated: true)
                }))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Open settings", comment:""), style: UIAlertAction.Style.default,handler: {action in
                    //Open the app settings
                    //SOURCE: https://stackoverflow.com/questions/46421646/how-to-open-your-app-in-settings-ios-11
                    //*-*-*-*-*-*-*-*-
                    if let url = URL(string:UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    //*-*-*-*-*-*-*-*-
                    //Go back to SearchViewController
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
                return
            case .InvalidApiKey:
                let alertController = UIAlertController(title: NSLocalizedString("Invalid API token", comment: "Error alert title"), message: NSLocalizedString("The API token is invalid, necessary for using the API. \n Please get a viable token at fonoapi.freshpixl.com.", comment: "Error alert message"), preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Go Back", comment:""), style: UIAlertAction.Style.default,handler: {action in
                    //Go back to SearchViewController
                    self.navigationController?.popViewController(animated: true)
                }))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Open settings", comment:""), style: UIAlertAction.Style.default,handler: {action in
                    //Open the app settings
                    //SOURCE: https://stackoverflow.com/questions/46421646/how-to-open-your-app-in-settings-ios-11
                    //*-*-*-*-*-*-*-*-
                    if let url = URL(string:UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    //*-*-*-*-*-*-*-*-
                    //Go back to SearchViewController
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            }
        }
        
                DispatchQueue.main.async {
        guard let fetchedDevices = fetchedDevices else{
            //if list is nil, an error occured
            //Show alert
            let alertController = UIAlertController(title: NSLocalizedString("Something went wrong", comment: "Error alert title"), message: NSLocalizedString("An error occured when fetching the devices, please try again.", comment: "Error alert message"), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Go Back", comment:""), style: UIAlertAction.Style.default,handler: {action in
                //Go back to SearchViewController
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
            //Assign devices
            self.devices = fetchedDevices
        
            //Update the UI
            self.updateUI(with: fetchedDevices)
        }
    }
    
    private func updateUI(with fetchedDevices:[Device]?){
            //If device list is empty, default placeholder will be shown
            if !self.devices.isEmpty{
                //Hide the empty tableview placeholder
                self.emptyListPlaceHolderIsShown = false
                self.tableView.separatorStyle = .singleLine
                //Reload the table and hide the placeholder automatically
                self.tableView.reloadData()
            }else{
                //The empty tableview placeholder may be shown when necessary
                self.emptyListPlaceHolderIsShown = true
                self.tableView.separatorStyle = .none
                //Make the placeholder check if it should be shown (it should)
                self.tableView.reloadEmptyDataSet()
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

//Table view
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
        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = DeviceRealmController.instance.isFavoritised(device: device) ? "⭐️" : ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}

//Empty dataset
extension DevicesListTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 30, weight: .heavy)]
        return NSAttributedString(string: NSLocalizedString("Nothing found", comment: "Empty dataset placeholder title"), attributes:attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)]
        return NSAttributedString(string: NSLocalizedString("Try another device or brand name", comment: "Empty dataset placeholder description"), attributes:attributes)
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return emptyListPlaceHolderIsShown
    }
    
}
