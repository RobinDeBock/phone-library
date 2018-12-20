//
//  Phone.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
struct Phone {
    var deviceName:String;
    var brand:String;
    
    var description: String {
        return "Phone: \(deviceName), Brand: \(brand)"
}
    static func loadSamplePhones() -> [Phone]{
        let dummyPhones: [Phone] = [
            Phone(deviceName: "Mi A1", brand: "Xiaomi"),
            Phone(deviceName: "OnePlus 5T", brand: "OnePLus")
        ]
        return dummyPhones
    }
    
}

extension Phone:Codable{
    
    enum CodingKeys: String, CodingKey {
        case deviceName = "DeviceName"
        case brand = "Brand"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy:CodingKeys.self)
        self.deviceName = try valueContainer.decode(String.self, forKey: CodingKeys.deviceName)
        self.brand = try valueContainer.decode(String.self, forKey: CodingKeys.brand)
    }
    
}
