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
    
    //Hardcoded configurations for collectionView in portait mode
    let minItemWidth:CGFloat = 110
    let maxItemWidth:CGFloat = 150
    let preferredPortretColumnAmount = 3
    let maxRowsPortretMode = 2
    
    var columnAmount = 3
    var collectionViewHeightValue:CGFloat = 0
    
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
        updateAddToFavoritesButton(isFavorite: isFavoritised, animation: false)
    }
    
    override func viewDidLayoutSubviews() {
        //Updating constraints doesn't work inside viewWillAppear
        collectionViewHeight.constant = collectionViewHeightValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Show the scroll indicator momentarily
        collectionView.flashScrollIndicators()
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
        //Device orientation doesn't show what orientation the screen is in when it's lying flat
        let isPortrait = UIScreen.main.bounds.width < UIScreen.main.bounds.height

        //Configure scroll
        collectionView.isScrollEnabled = true
        
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        //Get the calculated itemWidth
        let itemWidth = calculateCollectionViewItemSize()
        //Item is a square
        collectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        //calculate amount of rows necessary
        var amountOfRows:Int
        if isPortrait{
           amountOfRows = Int(ceil(CGFloat(mainSpecs.count) / CGFloat(columnAmount)))
            //Check if amountOfRows does not exceed max amount of rows
            amountOfRows = amountOfRows <= maxRowsPortretMode ? amountOfRows : maxRowsPortretMode
        }else{
            //portrait has only one row
            amountOfRows = 1
        }
        //Check if height of the collection view does not exceed more than half of the screen
        if itemWidth * CGFloat(amountOfRows) >= UIScreen.main.bounds.height/2{
            //Limit to one row
            amountOfRows = 1
        }
        //Store value for when screen is first shown and update the constraint here
        collectionViewHeightValue = itemWidth * CGFloat(amountOfRows)
        collectionViewHeight.constant = collectionViewHeightValue
    }

    private func calculateCollectionViewItemSize() -> CGFloat{
        //We calculate the itemWidth based on the smallest value, so that's always the width of the device should it be in portrait mode
        //This way the icons won't resize on mobile rotation
        let screenWidthPortrait =  min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        
        var itemWidth:CGFloat
        columnAmount = preferredPortretColumnAmount
        
        //SOURCE: https://www.youtube.com/watch?v=2-nxXXQyVuE
        //-*-*-*-*-*-
        itemWidth = screenWidthPortrait / CGFloat(columnAmount)
        //-*-*-*-*-*-

        //If the itemWidth is smaller than our minimum, we recalculate the columnAmount with our minValue
        //Likewise for maxValue
        if itemWidth < minItemWidth {
            columnAmount = Int(floor(collectionView.frame.width / minItemWidth))
            itemWidth = collectionView.frame.width / CGFloat(columnAmount)
        }else if itemWidth > maxItemWidth{
            columnAmount = Int(ceil(collectionView.frame.width / maxItemWidth))
            itemWidth = collectionView.frame.width / CGFloat(columnAmount)
        }
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
                let alertController = UIAlertController(title: NSLocalizedString("Something went wrong", comment: "Error alert title"), message: NSLocalizedString("An error occured when trying to remove the device from favorites. Please try again", comment: "Error alert message"), preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Hide alert"), style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        case false:
            //Add to favorites
            if DeviceRealmController.instance.add(favorite: device){
                updateAddToFavoritesButton(isFavorite: true)
            }else{
                //Error
                let alertController = UIAlertController(title: NSLocalizedString("Something went wrong", comment: "Error alert title"), message: NSLocalizedString("An error occured when trying to add the device to favorites. Please try again", comment: "Error alert message"), preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Hide alert"), style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //Update icon color to alert user if he can add to favorites
    private func updateAddToFavoritesButton(isFavorite:Bool, animation:Bool = true){
        switch isFavorite{
        case true:
            let view = self.addToFavoritesBarButtonItem.value(forKey: "view") as? UIView
            if animation{
                UIView.animate(withDuration: 0.3) {
                    view?.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
                    view?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }}
                addToFavoritesBarButtonItem.image = nil
                addToFavoritesBarButtonItem.title = "⭐️"
                addToFavoritesBarButtonItem.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)], for: UIControl.State.normal)
        case false:
            addToFavoritesBarButtonItem.image = UIImage(named: "addToFavorites_icon")
            addToFavoritesBarButtonItem.tintColor = .lightGray
            addToFavoritesBarButtonItem.title = nil
        }
    }
    
}

extension DetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        //amount of additional spec categories
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
