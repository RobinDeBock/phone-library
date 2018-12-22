//
//  BaseTabBarViewController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 22/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {
        @IBInspectable var defaultIndex: Int = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            selectedIndex = defaultIndex
        }
        
    // SOURCE:https://stackoverflow.com/questions/13136699/setting-the-default-tab-when-using-storyboards

}
