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

class Device:Object, Decodable {
    @objc dynamic var name:String=""
    @objc dynamic var brand:String=""
    //Main specs
    @objc dynamic var cpu:String=""
    @objc dynamic var screenResolution:String=""
    @objc dynamic var ram:String=""
    //var internalMemory:Double=0
    @objc dynamic var battery:String=""
    @objc dynamic var secondaryCamera:String=""
    //Additional specs
    //--Release
    @objc dynamic var announcedDate:String=""
    @objc dynamic var releaseStatus:String=""
    //--Physical
    @objc dynamic var screenSize:String=""
    @objc dynamic var dimensions:String=""
    @objc dynamic var weight:Double=0
    //--Hardware
    @objc dynamic var gpu:String=""
    @objc dynamic var chipset:String=""
    @objc dynamic var headphoneJack:Bool=false
    @objc dynamic var usb:String=""
    @objc dynamic var primaryCamera:String=""
    @objc dynamic var simType:String=""
    @objc dynamic var cardSlot:String=""
    //--Software
    @objc dynamic var os:String=""
    
    convenience init(name: String, brand:String) {
        self.init()
        self.name = name
        self.brand = brand
    }
    
   override var description: String {
        return "Device: \(name), Brand: \(brand)"
    }
    
    //Codable
    //--Codable constructor (can't be put in extension)
    required init(from decoder: Decoder) throws {
        super.init()
        let valueContainer = try decoder.container(keyedBy:CodingKeys.self)
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.brand = try valueContainer.decode(String.self, forKey: CodingKeys.brand)
        self.cpu = (try? valueContainer.decode(String.self, forKey: CodingKeys.cpu)) ?? ""
        self.screenResolution = (try? valueContainer.decode(String.self, forKey: CodingKeys.screenResolution)) ?? ""
        var ramVal:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.internalProp) else {return ""}
            let regex = NSRegularExpression("[0-9]* GB RAM")
            return regex.matches(stringValue)
            }
        self.ram = ramVal
        //self.batteryProp = (try? valueContainer.decode(String.self, forKey: CodingKeys.batteryProp)) ?? ""
        self.secondaryCamera = (try? valueContainer.decode(String.self, forKey: CodingKeys.secondaryCamera)) ?? ""
    }
    
    //--Json coding keys
    enum CodingKeys: String, CodingKey {
        case name = "DeviceName"
        case brand = "Brand"
        case cpu
        case screenResolution = "resolution"
        case internalProp = "internal"
        case batteryProp = "battery"
        case secondaryCamera = "secondary"
    }
    //**************
    
    
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
    //**************
    
}

extension Device{
    //
    
    
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

