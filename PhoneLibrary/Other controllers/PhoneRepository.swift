//
//  PhoneController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
class PhoneRepository{
    
    static let instance = PhoneRepository();
    
    private let networkController:PhoneNetworkController
    
    private init(){
        networkController = PhoneNetworkController()
    }
    
    func fetchPhonesByBrand(_ brand:String, completion: @escaping ([Phone]?) -> Void){
        networkController.fetchPhonesByBrand(brand) { (phones) in
            completion(phones)
        }
    }
    
    func fetchPhonesByName(_:String, completion: @escaping ([Phone]?) -> Void){
        var phones :[Phone] = Phone.loadSamplePhones()
        phones.append(contentsOf: Phone.loadSamplePhones())
        completion(phones)
    }
}

