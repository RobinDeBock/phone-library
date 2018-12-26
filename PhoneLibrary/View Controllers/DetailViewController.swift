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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var device:Device!
    
    //Mainspecs for collection view
    var mainSpecs:[Device.MainSpecNames:String] = [:]
    
    //Additional specs for the tableview
    var additionalSpecs:[String:[DeviceSpec]] = [:]
    
    //Amount of columns in the collectionView
    let columnAmount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceName.title = device.name
        mainSpecs = device.mainSpecs()
        additionalSpecs = device.additionalSpecCategoriesAndValues()
        
        calculateCollectionViewItemSize()
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
        let mainSpecKey = Array(mainSpecs.keys)[indexPath.row]
        let imageName:String = mainSpecKey.rawValue + "_icon"
        cell.imageView.image = UIImage(named: imageName)
        //Set label text
        cell.titleLabel.text = mainSpecs[mainSpecKey]
        return cell
    }
}

extension DetailViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return additionalSpecs.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(additionalSpecs.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let additionalSpecKey = Array(additionalSpecs.keys)[section]
        return additionalSpecs[additionalSpecKey]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let additionalSpecKey = Array(additionalSpecs.keys)[indexPath.section]
        let deviceSpec = additionalSpecs[additionalSpecKey]![indexPath.row]
        cell.textLabel?.text = deviceSpec.name
        cell.detailTextLabel?.text = deviceSpec.value
        return cell
    }
}
