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
        static let searchByModelSegue = "SearchByModel"
    }
    
    @IBOutlet weak var searchValueTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchValueTextField.clearButtonMode = UITextField.ViewMode.whileEditing

        //searchValueTextField.layer.borderWidth = 1.0
        //searchValueTextField.layer.borderColor = UIColor.red.cgColor
    }
    
    @IBAction func searchByBrandButtonClicked(_ sender: Any) {
        //TODO add foutcontrole
        performSegue(withIdentifier: PropertyKeys.searchByBrandSegue, sender: self)
    }
    
    
    @IBAction func searchByModelButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: PropertyKeys.searchByModelSegue, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let phonesListTableViewController = segue.destination as? PhonesListTableViewController else{return}
                    phonesListTableViewController.searchValue = searchValueTextField.text!
        if segue.identifier == PropertyKeys.searchByBrandSegue{
            phonesListTableViewController.searchType = SearchType.SearchByBrand
        }else if segue.identifier == PropertyKeys.searchByModelSegue{
            phonesListTableViewController.searchType = SearchType.SearchByModel
        }
    }
    

}
