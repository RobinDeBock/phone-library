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
    
    private var realmDevices: Results<Device>!
    
    //Public readonly property to handle nil array of realmDevices
    var devices:[Device]{
        get{
            return realmDevices != nil ? Array(realmDevices) : []
        }
    }

    private var realm: Realm?
    
    private init(){
        //If something goes wrong in initialisation, the CRUD functions will handle it themselves
        realm = try? Realm()
        guard let realm = realm else{return}
        //location of the local DB
        print("Realm file location: \(realm.configuration.fileURL!)")
        //load stored devices
        if let fetchedRealmDevices = try? Realm().objects(Device.self){
            realmDevices = fetchedRealmDevices
        }else{
            //empty out all saved devices
            try! realm.write {
                realm.deleteAll()
            }
        }
    }
    
    func isFavoritised(device:Device) -> Bool{
        //In case local Realm database was emptied
        guard realmDevices != nil, !realmDevices.isEmpty else{return false}
        return realmDevices.first(where: {$0.name == device.name}) != nil
    }
    
    func add(favorite device:Device) -> Bool{
        do{
            guard let realm = realm else{
                print("ERROR: Realm was not instantiated")
                return false}
            //Check if device is already saved
            if realmDevices.first(where: {$0.name == device.name}) != nil {
                print("ERROR: Device already exists in Realm")
                return false}
            try realm.write{
                //Storing a copy of our object so it can be deleted and re-added
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
        guard index >= 0 && index < realmDevices.count else {return false}
        return remove(favorite: realmDevices[index])
    }
    
    func remove(favorite device:Device) -> Bool{
        do{
            guard let realm = realm else{
                print("ERROR: Realm was not instantiated")
                return false}
            //find device in realm list
            guard let realmDevice = realmDevices.first(where: {$0.name == device.name}) else{
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
