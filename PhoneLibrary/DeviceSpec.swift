//
//  DeviceSpec.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 26/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
class DeviceSpec {
    var name:String
    var value:String
    
    init(name:String, value:String) {
        self.name = name
        self.value = value
    }
}

class MainDeviceSpec: DeviceSpec{
    var identifier: Device.MainSpecIdentifier
    init(identifier:Device.MainSpecIdentifier, name:String, value:String) {
        self.identifier = identifier
        super.init(name: name, value: value)
    }
}
