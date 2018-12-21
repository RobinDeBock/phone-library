//
//  Device.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
struct Device {
    var name:String;
    var brand:String;
    
    var description: String {
        return "Device: \(name), Brand: \(brand)"
}
    static func loadSampleDevices() -> [Device]{
        let dummyDevices: [Device] = [
            Device(name: "Mi A1", brand: "Xiaomi"),
            Device(name: "OnePlus 5T", brand: "OnePLus")
        ]
        return dummyDevices
    }
    
}

extension Device:Codable{
    
    enum CodingKeys: String, CodingKey {
        case name = "DeviceName"
        case brand = "Brand"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy:CodingKeys.self)
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.brand = try valueContainer.decode(String.self, forKey: CodingKeys.brand)
    }
    
}
