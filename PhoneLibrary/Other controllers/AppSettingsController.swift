//
//  AppSettingsController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/01/2019.
//  Copyright © 2019 Robin De Bock. All rights reserved.
//

import Foundation
class AppSettingsController{
    //Singleton pattern
    static var instance:AppSettingsController = AppSettingsController()
    
    struct SettingsBundleKeys {
        static let API_KEY = "api_key"
        static let USE_DUMMY_DATA = "dummy_data"
    }
    
    var networkApiKey:String{
        get{
           return UserDefaults.standard.object(forKey: SettingsBundleKeys.API_KEY) as? String ?? ""
        }
    }
    
    var dummyDataEnabled:Bool{
        get{
            return UserDefaults.standard.object(forKey: SettingsBundleKeys.USE_DUMMY_DATA) as? Bool ?? false
        }
    }
    
}
