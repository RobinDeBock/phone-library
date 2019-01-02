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
    
    static let devicesUpdatedNotification = Notification.Name("DeviceRealmController.devicesUpdated")
    static let newlyAddedDevicesAmountUpdatedNotification = Notification.Name("DeviceRealmController.newlyAddedDevicesAmountUpdated")
    
    private var realm: Realm?
    
    private var realmDevices: Results<Device>!
    
    //Store string because the full device objects are stored anyways
    private var newlyAddedDevices:[String] = []
    
    func resetNewDevicesCounter(){
        newlyAddedDevices = []
        NotificationCenter.default.post(name: DeviceRealmController.newlyAddedDevicesAmountUpdatedNotification, object: nil)
    }
    
    //public getter
    var newlyAddedDevicesAmount:Int{
        get{
            return newlyAddedDevices.count
        }
    }
    
    //Public readonly property to handle nil array of realmDevices
    //Return a copy of realm objects so every change to realm is done in this class with the correct objects
    var devices:[Device]{
        get{
            guard realmDevices != nil else{return []}
            var copiedRealmDevices : [Device] = []
            realmDevices.forEach{device in
                copiedRealmDevices.append(device.copy() as! Device)
            }
            return copiedRealmDevices
        }
    }
    
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
    
    private func tryToAddToNewlyAddedDevices(_ device:Device){
        //Check if not already present (must be by name because objects differ)
        if newlyAddedDevices.first(where:{$0 == device.name}) == nil{
            newlyAddedDevices.append(device.name)
            NotificationCenter.default.post(name: DeviceRealmController.newlyAddedDevicesAmountUpdatedNotification, object: nil)
        }
    }
    
    private func tryToRemoveFromNewlyAddedDevices(_ device:Device){
        //Check if present
        if let index = newlyAddedDevices.firstIndex(where: {$0 == device.name}){
            newlyAddedDevices.remove(at: index)
            NotificationCenter.default.post(name: DeviceRealmController.newlyAddedDevicesAmountUpdatedNotification, object: nil)
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
            
            //Storing a copy of our object so it can be deleted and re-added
            let copy = device.copy() as! Device
            try realm.write{
                realm.add(copy)
            }
            print("Saved to Realm: " + device.description)
            //Increment amount of new devices
            tryToAddToNewlyAddedDevices(device)
            //Notify observers
            NotificationCenter.default.post(name: DeviceRealmController.devicesUpdatedNotification, object: nil)
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
            print("Deleting from Realm: " + realmDevice.description)
            try realm.write{
                realm.delete(realmDevice)
            }
            //Lower amount of new devices
            tryToRemoveFromNewlyAddedDevices(device)
            //Notify observers
            NotificationCenter.default.post(name: DeviceRealmController.devicesUpdatedNotification, object: nil)
            return true
        }catch let error{
            print(error.localizedDescription)
            return false
        }
    }
    
}
