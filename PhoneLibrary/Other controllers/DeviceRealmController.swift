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
    private let realm: Realm?
    
    private init(){
        //If something goes wrong in initialisation, the CRUD functions will handle it themselves
        realm = try? Realm()
        guard let realm = realm else{return}
        //location of the local DB
        print("realm file location", realm.configuration.fileURL!)
        //load stored devices
        devices = try! Realm().objects(Device.self)
    }
    
    func add(favorite device:Device) -> Bool{
        do{
            guard let realm = realm else{
                print("Realm was not instantiated")
                return false}
            try realm.write{
                realm.add(device)
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
                print("Realm was not instantiated")
                return false}
            try realm.write{
                print("Deleting from Realm: " + device.description)
                realm.delete(device)
            }
            return true
        }catch let error{
            print(error.localizedDescription)
            return false
        }
    }
    
}