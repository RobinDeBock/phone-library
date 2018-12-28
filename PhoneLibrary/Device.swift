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
    @objc dynamic var batteryShort:String=""
    @objc dynamic var rearCamera:String=""
    @objc dynamic var frontCamera:String=""
    //TODO var internalMemory:Double=0
    //Additional specs
    //--Physical
    @objc dynamic var screenSize:String=""
    @objc dynamic var dimensions:String=""
    @objc dynamic var weight:String=""
    //--Release
    @objc dynamic var announcedDate:String=""
    @objc dynamic var releaseStatus:String=""
    //--Hardware
    @objc dynamic var gpu:String=""
    @objc dynamic var chipset:String=""
    @objc dynamic var headphoneJack:Bool=false
    @objc dynamic var usb:String=""
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
        var cpuValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.cpu) else {return ""}
            let regex = NSRegularExpression("[0-9]*\\.[0-9]* GHz")
            return regex.matches(stringValue)
        }
        self.cpu = cpuValue
        var screenResolutionValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.screenResolution) else {return ""}
            let regex = NSRegularExpression("[0-9]* x [0-9]*")
            return regex.matches(stringValue)
        }
        self.screenResolution = screenResolutionValue
        var ramValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.internalProp) else {return ""}
            let regex = NSRegularExpression("[0-9]* GB RAM")
            return regex.matches(stringValue).replacingOccurrences(of: "RAM", with: "")
            }
        self.ram = ramValue
        var batteryValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.batteryShort) else {return ""}
            let regex = NSRegularExpression("[0-9]* mAh")
            return regex.matches(stringValue)
        }
        self.batteryShort = batteryValue
        var primaryCameraValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.rearCamera) else {return ""}
            let regex = NSRegularExpression("[0-9]* MP")
            return regex.matches(stringValue)
        }
        self.rearCamera = primaryCameraValue
        var secondaryCameraValue:String {
            guard let stringValue = try? valueContainer.decode(String.self, forKey: CodingKeys.frontCamera) else {return ""}
            let regex = NSRegularExpression("[0-9]* MP")
            return regex.matches(stringValue)
        }
        self.frontCamera = secondaryCameraValue
        //Additional Specs
        self.screenSize = (try? valueContainer.decode(String.self, forKey: CodingKeys.screenSize)) ?? ""
        self.dimensions = (try? valueContainer.decode(String.self, forKey: CodingKeys.dimensions)) ?? ""
        self.weight = (try? valueContainer.decode(String.self, forKey: CodingKeys.weight)) ?? ""
        self.announcedDate = (try? valueContainer.decode(String.self, forKey: CodingKeys.announcedDate)) ?? ""
        self.releaseStatus = (try? valueContainer.decode(String.self, forKey: CodingKeys.releaseStatus)) ?? ""
        //**************
    }
    
    //--Json coding keys and enum value for other properties
    enum CodingKeys: String, CodingKey {
        case name = "DeviceName"
        case brand = "Brand"
        case cpu
        case screenResolution = "resolution"
        case internalProp = "internal"
        case batteryShort = "battery_c"
        case rearCamera = "primary_"
        case frontCamera = "secondary"
        //Additional specs
        case screenSize = "size"
        case dimensions
        case weight
        case announcedDate = "announced"
        case releaseStatus = "status"
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

//Main Specs
extension Device{
 
    //Not using coding keys, so we can split fields into multiple ones (e.g. batteryShort and the full battery text)
    //Also the images are named after these enum values
    enum MainSpecIdentifier:String{
        case cpu
        case screenResolution
        case ram
        case battery
        case rearCamera
        case frontCamera
    }
    //Define main specs with enum value so caller can handle it accordingly
    //Only not-empty values are added
    func mainSpecs() -> [MainDeviceSpec]{
        var result:[MainDeviceSpec] = []
        if !cpu.isEmpty {result.append(MainDeviceSpec(identifier: .cpu, name: "CPU", value:cpu))}
        if !screenResolution.isEmpty {result.append(MainDeviceSpec(identifier: .screenResolution, name: "Resolution", value:screenResolution))}
        if !ram.isEmpty {result.append(MainDeviceSpec(identifier: .ram, name: "RAM", value: ram))}
        if !batteryShort.isEmpty {result.append(MainDeviceSpec(identifier: .battery, name: "Battery", value: batteryShort))}
        if !rearCamera.isEmpty {result.append(MainDeviceSpec(identifier: .rearCamera, name: "Rear camera", value: rearCamera))}
        if !frontCamera.isEmpty {result.append(MainDeviceSpec(identifier: .frontCamera, name: "Front camera", value: frontCamera))}
        return result
    }
    
    func additionalSpecCategoriesAndValues() -> [DeviceSpecCategory]{
        var categories : [DeviceSpecCategory] = []
        //Release category
        var releaseCategory:[DeviceSpec] = []
        if !announcedDate.isEmpty{releaseCategory.append(DeviceSpec(name: "Announced", value: announcedDate))}
        if !releaseStatus.isEmpty{releaseCategory.append(DeviceSpec(name: "Status", value: releaseStatus))}
        if !releaseCategory.isEmpty{categories.append(DeviceSpecCategory(name:"Release", DeviceSpecs:releaseCategory))}
        //*****************
        //Physical category
        var physicalCategory:[DeviceSpec] = []
        if !screenSize.isEmpty{physicalCategory.append(DeviceSpec(name:"Screen size", value:screenSize))}
        if !dimensions.isEmpty{physicalCategory.append(DeviceSpec(name:"Dimensions", value:dimensions))}
        if !weight.isEmpty{physicalCategory.append(DeviceSpec(name:"Weight", value:weight))}
        if !physicalCategory.isEmpty{categories.append(DeviceSpecCategory(name:"Physical", DeviceSpecs:physicalCategory))}
        //*****************
        return categories
    }
}

//Deep Copy
extension Device:NSCopying{
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Device()
        copy.name = self.name
        copy.brand = self.brand
        copy.cpu = self.cpu
        copy.screenResolution = self.screenResolution
        copy.ram = self.ram
        copy.batteryShort = self.batteryShort
        copy.rearCamera = self.rearCamera
        copy.frontCamera = self.frontCamera
        copy.screenSize = self.screenSize
        copy.dimensions = self.dimensions
        copy.weight = self.weight
        copy.announcedDate = self.announcedDate
        copy.releaseStatus = self.releaseStatus
        copy.gpu = self.gpu
        copy.chipset = self.chipset
        copy.headphoneJack = self.headphoneJack
        copy.usb = self.usb
        copy.simType = self.simType
        copy.cardSlot = self.cardSlot
        copy.os = self.os
        return copy
    }
}

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

