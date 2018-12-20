//
//  PhoneController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
class PhoneController{
    
    static let instance = PhoneController();
    
    private init(){
        
    }
    
    func fetchPhonesByBrand(_:String, completion: @escaping ([Phone]?) -> Void){
        let phones :[Phone] = Phone.loadSamplePhones()
        completion(phones)
    }
    
    func fetchPhonesByName(_:String, completion: @escaping ([Phone]?) -> Void){
        var phones :[Phone] = Phone.loadSamplePhones()
        phones.append(contentsOf: Phone.loadSamplePhones())
        completion(phones)
    }
}

