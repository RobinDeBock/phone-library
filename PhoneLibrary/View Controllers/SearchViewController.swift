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
        static let searchByBrandSegue = "SearchByBrand"
        static let searchByNameSegue = "SearchByName"
    }
    
    @IBOutlet weak var searchValueTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchValueTextField.clearButtonMode = UITextField.ViewMode.whileEditing

        //searchValueTextField.layer.borderWidth = 1.0
        //searchValueTextField.layer.borderColor = UIColor.red.cgColor
    }
    /*    @IBAction func textEditingChanged(_ sender:UITextField ){
     updateSaveButtonState()
     }
     
     private func updateSaveButtonState(){
     let symbolText = symbolTextField.text ?? ""
     let nameText = nameTextField.text ?? ""
     let descriptionText = descriptionTextField.text ?? ""
     let usageText = usageTextField.text ?? ""
     saveButton.isEnabled = !symbolText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty && !usageText.isEmpty
     }*/
    
    @IBAction func searchByBrandButtonClicked(_ sender: Any) {
        //TODO add foutcontrole
        performSegue(withIdentifier: PropertyKeys.searchByBrandSegue, sender: self)
    }
    
    
    @IBAction func searchByModelButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: PropertyKeys.searchByNameSegue, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let devicesListTableViewController = segue.destination as? DevicesListTableViewController else{return}
                    devicesListTableViewController.searchValue = searchValueTextField.text!
        if segue.identifier == PropertyKeys.searchByBrandSegue{
            devicesListTableViewController.searchType = SearchType.SearchByBrand
        }else if segue.identifier == PropertyKeys.searchByNameSegue{
            devicesListTableViewController.searchType = SearchType.SearchByName
        }
    }
    

}
