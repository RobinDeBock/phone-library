//
//  Device.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Device:Object, Codable {
    @objc dynamic var name:String="";
    @objc dynamic var brand:String="";
    
    convenience init(name: String, brand:String) {
        self.init()
        self.name = name;
        self.brand = brand;
    }
    
   override var description: String {
        return "Device: \(name), Brand: \(brand)"
    }
    
    //Realm constructors (can't be put in extension)
    required init() {
        super.init()
    }
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    //Codable (can't be put in extension)
    required init(from decoder: Decoder) throws {
        super.init()
        let valueContainer = try decoder.container(keyedBy:CodingKeys.self)
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.brand = try valueContainer.decode(String.self, forKey: CodingKeys.brand)
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "DeviceName"
        case brand = "Brand"
    }
    
}

//Realm
extension Device{
    //Dummy data
    static func loadSampleDevices() -> [Device]{
        let dummyDevices: [Device] = [
            Device(name: "Mi A1", brand: "Xiaomi"),
            Device(name: "OnePlus 5T", brand: "OnePLus"),
            Device(name: "Peerpad", brand: "Peer"),
            Device(name: "S8", brand: "Samsung")
        ]
        return dummyDevices
    }
}

