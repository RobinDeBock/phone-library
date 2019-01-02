//
//  SearchViewController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    struct PropertyKeys {
        static let searchByBrandSegue = "searchByBrand"
        static let searchByNameSegue = "searchByName"
    }
    
    @IBOutlet weak var searchValueTextField: UITextField!
    @IBOutlet weak var searchByBrandButton: UIButton!
    @IBOutlet weak var searchByNameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Layout of search buttons configuration
        searchByBrandButton.tintColor = .white
        searchByBrandButton.layer.cornerRadius = 5.0
        
        searchByNameButton.tintColor = .white
        searchByNameButton.layer.cornerRadius = 5.0
        
        updateSearchButtonStates()
        
        //SOURCE: https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        //(Had to do some debugging of my own and code code combining)
        //*-*-*-*-*-*-*-
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    //*-*-*-*-*-*-*-
    
    
    @IBAction func searchValueTextEditingChanged(_ sender: Any) {
        updateSearchButtonStates()
    }
    
    private func updateSearchButtonStates(){
        let searchValue = (searchValueTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let isValidInput:Bool = !searchValue.isEmpty && searchValue.count < 20
        //Fade into different button state visual
        UIView.animate(withDuration: 0.3) {
            if isValidInput {
                self.searchByBrandButton.backgroundColor = .blue
                self.searchByNameButton.backgroundColor = .blue
            }else{
                self.searchByBrandButton.backgroundColor = .lightGray
                self.searchByNameButton.backgroundColor = .lightGray
            }
        }
        self.searchByBrandButton.isEnabled = isValidInput
        self.searchByNameButton.isEnabled = isValidInput
    }
    
    @IBAction func searchByBrandButtonClicked(_ sender: Any) {
        performSearch(withIdentifier: PropertyKeys.searchByBrandSegue)
    }
    
    
    @IBAction func searchByModelButtonClicked(_ sender: Any) {
        performSearch(withIdentifier: PropertyKeys.searchByNameSegue)
    }
    
    private func performSearch(withIdentifier segue:String){
        if DeviceNetworkController.instance.isConnected{
            performSegue(withIdentifier: segue, sender: self)
        }else{
            //No internet connection, show alert
            let alertController = UIAlertController(title: NSLocalizedString("No internet connection", comment: "Alert title"), message: NSLocalizedString("Make sure your device is connected to the internet.", comment: "Alert message"), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Hide alert"), style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let devicesListTableViewController = segue.destination as? DevicesListTableViewController else{return}
                    devicesListTableViewController.searchValue = searchValueTextField.text!
        if segue.identifier == PropertyKeys.searchByBrandSegue{
            devicesListTableViewController.searchType = DevicesListTableViewController.SearchType.SearchByBrand
        }else if segue.identifier == PropertyKeys.searchByNameSegue{
            devicesListTableViewController.searchType = DevicesListTableViewController.SearchType.SearchByName
        }
    }
    

}
