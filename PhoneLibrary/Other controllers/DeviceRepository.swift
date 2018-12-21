//
//  DeviceController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
class DeviceRepository{
    
    static let instance = DeviceRepository();
    
    private let networkController:DeviceNetworkController
    
    private init(){
        networkController = DeviceNetworkController()
    }
    
    func fetchDevicesByBrand(_ brand:String, completion: @escaping ([Device]?) -> Void){
        networkController.fetchDevicesByBrand(brand) { (phones) in
            completion(phones)
        }
    }
    
    func fetchDevicesByName(_ name:String, completion: @escaping ([Device]?) -> Void){
        networkController.fetchDevicesByName(name){ (phones) in
            completion(phones)
        }
    }
}

