//
//  Phone.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
struct Phone {
    var DeviceName:String;
    var Brand:String;
    
    var description: String {
        return "Phone: \(DeviceName), Brand: \(Brand)"
}
    static func loadSamplePhones() -> [Phone]{
        let dummyPhones: [Phone] = [
            Phone(DeviceName: "Mi A1", Brand: "Xiaomi"),
            Phone(DeviceName: "OnePlus 5T", Brand: "OnePLus")
        ]
        return dummyPhones
    }

}
