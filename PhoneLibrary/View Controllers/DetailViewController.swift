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
    
    //Hardcoded amount of columns in the collectionView in portait mode
    let columnAmount = 3
    let maxItemWidth:CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Assign dictionaries to seperate objects for accessibility in code
        mainSpecs = device.mainSpecs()
        additionalSpecs = device.additionalSpecCategoriesAndValues()
        //Tab bar configuration
        deviceName.title = device.name
        //TableView configuration
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Detect screen rotation, subscribe to screen rotation observable
        NotificationCenter.default.addObserver(self, selector: #selector(screenRotation), name: UIDevice.orientationDidChangeNotification, object: nil)
        //Update collection view size once already
        configureCollectionViewLayout()
        //Check if device is already in favorites
        let isFavoritised = DeviceRealmController.instance.isFavoritised(device: device)
        updateAddToFavoritesButton(isFavorite: isFavoritised)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Unsubscribe from screen rotation observable
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func screenRotation(){
        //CollectionView configuration
        configureCollectionViewLayout()
    }
    
    private func configureCollectionViewLayout(){
        //Screen orientation code was based on a source:http://lab.dejaworks.com/ios-swift-detecting-device-rotation/
        //But that was depricated, so I fiddled around with the available options until this came out
        //It's safe to say this is my original code ©
        //Check if current orientation is of a kind we support

        /*guard UIDevice.current.orientation == UIDeviceOrientation.portrait
            || UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
            || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight else {
                return
        }*/
        
        //Get the calculated itemWidth
        let itemWidth = calculateCollectionViewItemSize()
        
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //Item is a square
        collectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            //Collection view has: horizontal scroll direction, do scroll

        }else{//Portrait
            //Collection view has: vertical scroll direction, no scroll
            collectionViewLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
            collectionView.isScrollEnabled = false
            
            let amountOfRows = ceil(Double(mainSpecs.count) / Double(columnAmount))
            collectionViewHeight.constant = itemWidth * CGFloat(amountOfRows)
        }
        
    }

    private func calculateCollectionViewItemSize() -> CGFloat{
        //Also based on SOURCE: https://www.youtube.com/watch?v=2-nxXXQyVuE , although at this point it's becoming quite unique
        //We calculate the itemWidth based on the smallest value, so that's always the width of the device should it be in portrait mode
        let screenWidthPortrait =  min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        
        var itemWidth:CGFloat
        
        //SOURCE: https://www.youtube.com/watch?v=2-nxXXQyVuE
        //-*-*-*-*-*-
        itemWidth = screenWidthPortrait / CGFloat(columnAmount)
        //-*-*-*-*-*-
        //To support large devices we put in a maximum value
        itemWidth = (itemWidth <= maxItemWidth) ? itemWidth : maxItemWidth
        return itemWidth
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
