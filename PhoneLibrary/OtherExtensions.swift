//
//  Extensions.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation

extension URL{  
       func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map{ URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

//SOURCE: https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
//*-*-*-*-*-*-
extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}
//*-*-*-*-*-*-
extension NSRegularExpression {
    func matches(_ string: String) -> String {
        let completeStringRange = NSRange(location: 0, length: string.utf16.count)
        guard let range =  firstMatch(in: string, options: [], range: completeStringRange)?.range else {return ""}
        return String(string.dropFirst(range.lowerBound).prefix(range.upperBound - range.lowerBound) as Substring)
    }
}

extension Sequence where Iterator.Element == Device
{
    mutating func sort() -> [Device] {
        return self.sorted(by: {$0.name < $1.name})
    }
    
    func brandNames() -> [String] {
        var names : [String] = []
        self.forEach({names.append($0.brand)})
        return Array(Set(names))
    }
    func devicesByBrand(_ brand:String) ->[Device]{
        return self.filter({$0.brand == brand})
    }
    func devicesByBrandDict() -> [String:[Device]]{
        var devicesByBrandDict:[String:[Device]] = [:]
        self.forEach{device in
            if var deviceArray = devicesByBrandDict[device.brand]{
                deviceArray.append(device)
                devicesByBrandDict[device.brand] = deviceArray
            }else{//No array is present on key
                devicesByBrandDict[device.brand] = [device]
            }
        }
        return devicesByBrandDict
    }
}

