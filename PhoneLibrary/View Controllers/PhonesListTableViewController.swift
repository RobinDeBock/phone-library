//
//  PhonesListTableViewController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit

class PhonesListTableViewController: UITableViewController {

    var searchValue: String?
    var searchType:SearchType?
    
    var phones:[Phone]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(searchValue!)
        print(searchType!)
        
        loadPhones()
    }
    
    //Fetch the phones depending on the search type
    private func loadPhones(){
        guard let searchValue = searchValue, let searchType = searchType else {return}
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        switch searchType {
        case SearchType.SearchByBrand:
                PhoneRepository.instance.fetchPhonesByBrand(searchValue){fetchedPhones in
                    self.updateUI(with: fetchedPhones)
            }
        case SearchType.SearchByModel:
            PhoneRepository.instance.fetchPhonesByName(searchValue){fetchedPhones in
                  self.updateUI(with: fetchedPhones)
                }
            }
        }
    
    
    private func updateUI(with fetchedPhones:[Phone]?){
    DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //if list is empty show warning and stuff
        if let fetchedPhones = fetchedPhones {
            print(fetchedPhones)
            self.phones = fetchedPhones
            self.tableView.reloadData()
            }
        }
    }

    //Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return phones.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell", for: indexPath)
        //get the right phone
        let phone = phones[indexPath.row]
        cell.textLabel?.text = phone.description
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

enum SearchType {
    case SearchByBrand
    case SearchByModel
}
