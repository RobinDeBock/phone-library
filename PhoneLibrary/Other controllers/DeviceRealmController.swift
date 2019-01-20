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
    
    //observable: notify when any changes are made to the favorites
    static let devicesUpdatedNotification = Notification.Name("DeviceRealmController.devicesUpdated")
    //observable: notify when changes are made to newly added devices
    static let newlyAddedDevicesAmountUpdatedNotification = Notification.Name("DeviceRealmController.newlyAddedDevicesAmountUpdated")
    
    private var realm: Realm?
    
    private var realmDevices: Results<Device>?
    
    //Public readonly property to handle nil array of realmDevices
    //Return a copy of realm objects so there is no outside access to realm objects
    var devices:[Device]{
        get{
            guard let realmDevices = realmDevices else{return []}
            return realmDevices.deepCopy()
        }
    }
    
    //Store string because the full device objects are stored anyways
    private var newlyAddedDeviceNames:[String] = []
    
    var newlyAddedDevices:[Device]{
        get{
            guard let realmDevices = realmDevices else{return []}
            let newyAddedRealmDevices =  realmDevices.filter{self.newlyAddedDeviceNames.contains($0.name)}
            //return copy
            return newyAddedRealmDevices.deepCopy()
        }
    }
    
    //keep track how many new devices are added
    private var newlyAddedDevicesCounter:Int = 0{
        didSet{
            if newlyAddedDevicesCounter < 0 {
                newlyAddedDevicesCounter = 0
            }
            NotificationCenter.default.post(name: DeviceRealmController.newlyAddedDevicesAmountUpdatedNotification, object: nil)
        }
    }
    //public getter
    var newlyAddedDevicesAmount:Int{
        get{
            return newlyAddedDevicesCounter
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
    
    func resetNewDevicesCounter(){
        newlyAddedDevicesCounter = 0
    }
    
    private func tryToAddToNewlyAddedDevices(_ device:Device){
        //Check if not already present (must be by name because objects differ)
        if newlyAddedDeviceNames.first(where:{$0 == device.name}) == nil{
            newlyAddedDeviceNames.append(device.name)
            newlyAddedDevicesCounter += 1
        }
    }
    
    private func tryToRemoveFromNewlyAddedDevices(_ device:Device){
        //Check if present
        if let index = newlyAddedDeviceNames.firstIndex(where: {$0 == device.name}){
            newlyAddedDeviceNames.remove(at: index)
            newlyAddedDevicesCounter -= 1
        }
    }
    
    func isFavoritised(device:Device) -> Bool{
        //In case local Realm database was emptied
        guard let realmDevices = realmDevices, !realmDevices.isEmpty else{return false}
        return realmDevices.first(where: {$0.name == device.name}) != nil
    }
    
    func add(favorite device:Device) -> Bool{
        do{
            guard let realm = realm, let realmDevices = realmDevices else{
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
        //Check index is valid
        guard let realmDevices = realmDevices, index >= 0 && index < realmDevices.count else {return false}
        return remove(favorite: realmDevices[index].copy() as! Device)
    }
    
    func remove(favorite device:Device) -> Bool{
        do{
            guard let realm = realm, let realmDevices = realmDevices else{
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
