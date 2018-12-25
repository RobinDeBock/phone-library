//
//  DetailViewController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 24/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    //Hardcoded amount of collection view items
    let collectionViewItemAmount = 5
    //Amount of columns in the collectionView
    let columnAmount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SOURCE: https://www.youtube.com/watch?v=2-nxXXQyVuE
        //-*-*-*-*-*-
        let itemWidth = collectionView.frame.size.width / CGFloat(columnAmount)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //Item is a square
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        //-*-*-*-*-*-
        let amountOfRows = ceil(Double(collectionViewItemAmount) / Double(columnAmount))
        print(amountOfRows)
        collectionViewHeight.constant = itemWidth * CGFloat(amountOfRows)
    }
    
    //COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewItemAmount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewSpecCell", for: indexPath) as! CollectionViewSpecCell
        cell.titleLabel.text = "Testjee"
        return cell
    }
    //**************

    //TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = "Test"
        return cell
    }
    //**************

}
