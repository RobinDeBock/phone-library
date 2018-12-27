//
//  DeviceRealmController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 21/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
import RealmSwift

class DeviceRealmController{
    //Singleton pattern
    static var instance:DeviceRealmController = DeviceRealmController()
    
    var devices: Results<Device>!
    private var realm: Realm?
    
    private init(){
        //If something goes wrong in initialisation, the CRUD functions will handle it themselves
        realm = try? Realm()
        guard let realm = realm else{return}
        //location of the local DB
        print("Realm file location: \(realm.configuration.fileURL!)")
        //load stored devices
        if let realmDevices = try? Realm().objects(Device.self){
            devices = realmDevices
        }else{
            //empty out all saved devices
            try! realm.write {
                realm.deleteAll()
            }
        }
    }
    
    func isFavoritised(device:Device) -> Bool{
       return devices.first(where: {$0.name == device.name}) != nil
    }
    
    func add(favorite device:Device) -> Bool{
        do{
            guard let realm = realm else{
                print("ERROR: Realm was not instantiated")
                return false}
            try realm.write{
                let copy = device.copy() as! Device
                realm.add(copy)
                print("Saved to Realm: " + device.description)
            }
             return true
        }catch let error{
            print(error.localizedDescription)
            return false
        }
    }
    
    func removeByIndex(index:Int) -> Bool{
        guard index >= 0 && index < devices.count else {return false}
        return remove(favorite: devices[index])
    }
    
    func remove(favorite device:Device) -> Bool{
        do{
            guard let realm = realm else{
                print("ERROR: Realm was not instantiated")
                return false}
            //find device in realm list
            guard let realmDevice = devices.first(where: {$0.name == device.name}) else{
                print("ERROR: could not find device: '\(device.description)' in realm list")
                return false
            }
            try realm.write{
                print("Deleting from Realm: " + realmDevice.description)
                realm.delete(realmDevice)
            }
            return true
        }catch let error{
            print(error.localizedDescription)
            return false
        }
    }
    
}
