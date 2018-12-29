//
//  DetailViewController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 24/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController{
    @IBOutlet weak var deviceName: UINavigationItem!
    @IBOutlet weak var addToFavoritesBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var device:Device!
    
    //Mainspecs for collection view
    var mainSpecs:[MainDeviceSpec] = []
    
    //Additional specs for the tableview
    var additionalSpecs:[DeviceSpecCategory] = []
    
    //Amount of columns in the collectionView
    let columnAmount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Assign dictionaries to seperate objects for accessibility in code
        mainSpecs = device.mainSpecs()
        additionalSpecs = device.additionalSpecCategoriesAndValues()
        //Tab bar configuration
        deviceName.title = device.name
        //CollectionView configuration
        calculateCollectionViewItemSize()
        //TableView configuration
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isFavoritised = DeviceRealmController.instance.isFavoritised(device: device)
        updateAddToFavoritesButton(isFavorite: isFavoritised)
    }
    
    @IBAction func addToFavoritesButtonTapped(_ sender: Any) {
        switch DeviceRealmController.instance.isFavoritised(device: device) {
        case true: //device is favoritised
            //Remove from favorites
            if DeviceRealmController.instance.remove(favorite: device){
                updateAddToFavoritesButton(isFavorite: false)
            }else{
                //Error
                let alertController = UIAlertController(title: "Something went wrong", message: "An error occured when trying to remove the device from favorites. Please try again", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        case false:
            //Add to favorites
            if DeviceRealmController.instance.add(favorite: device){
                updateAddToFavoritesButton(isFavorite: true)
            }else{
                //Error
                let alertController = UIAlertController(title: "Something went wrong", message: "An error occured when trying to remove the device from favorites. Please try again", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //Update icon color to alert user if he can add to favorites
    private func updateAddToFavoritesButton(isFavorite:Bool){
        if isFavorite{
            UIView.animate(withDuration: 0.3) {
                let view = self.addToFavoritesBarButtonItem.value(forKey: "view") as? UIView
                view?.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
                view?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            addToFavoritesBarButtonItem.image = nil
            addToFavoritesBarButtonItem.title = "⭐️"
            addToFavoritesBarButtonItem.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)], for: UIControl.State.normal)
        }else{
            addToFavoritesBarButtonItem.image = UIImage(named: "addToFavorites_icon")
            addToFavoritesBarButtonItem.tintColor = .lightGray
            addToFavoritesBarButtonItem.title = nil
        }
    }
    
}

extension DetailViewController: UICollectionViewDataSource{
    private func calculateCollectionViewItemSize(){
        //SOURCE: https://www.youtube.com/watch?v=2-nxXXQyVuE
        //-*-*-*-*-*-
        let itemWidth = collectionView.frame.size.width / CGFloat(columnAmount)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //Item is a square
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        //-*-*-*-*-*-
        let amountOfRows = ceil(Double(mainSpecs.count) / Double(columnAmount))
        collectionViewHeight.constant = itemWidth * CGFloat(amountOfRows)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("There are \(mainSpecs.count) main specs")
        return mainSpecs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewSpecCell", for: indexPath) as! CollectionViewSpecCell
        //Set image
        let mainSpec = mainSpecs[indexPath.row]
        let imageName:String = mainSpec.identifier.rawValue + "_icon"
        cell.imageView.image = UIImage(named: imageName)
        //Set label text
        cell.titleLabel.text = mainSpec.name
        cell.valueLabel.text = mainSpec.value
        return cell
    }
}

extension DetailViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        print("There are \(additionalSpecs.count) additional spec categories")
        //amount of additional spec categories + our own custom one
        return additionalSpecs.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return additionalSpecs[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return additionalSpecs[section].DeviceSpecs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let deviceSpec = additionalSpecs[indexPath.section].DeviceSpecs[indexPath.row]
        cell.textLabel?.text = deviceSpec.name
        cell.detailTextLabel?.text = deviceSpec.value
        return cell
    }
}
