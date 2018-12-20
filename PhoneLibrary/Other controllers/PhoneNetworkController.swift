//
//  PhoneNetworkController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
class PhoneNetworkController {
    
    private let baseURL = URL(string: "https://fonoapi.freshpixl.com/v1/")!
    private let token = "1ba2a2bf8a17defe7646963cbaea9b45ec6ede3bc20e626f"
    private let limit = 20
    
    
    func fetchPhonesByBrand(_ brand:String, completion: @escaping([Phone]?) -> Void) {
        let query: [String: String] = [
            "token": token,
            "brand": brand,
            "limit": String(limit)
        ]

    let completeURL = baseURL.appendingPathComponent("getlatest")
        
    guard let url = completeURL.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            //print the error and return nill
            print(error!.localizedDescription)
            completion(nil)
            return
        } else {
            if let string = String(data: data!, encoding: .utf8) {print(string)}
            let jsonDecoder = JSONDecoder()
            if let data = data, let phones = try? jsonDecoder.decode([Phone].self, from: data) {
               completion(phones)
            }else {
                print("Either no data was returned, or data was not serialized.")
                completion(nil)
                return
            }
        }
        }
    task.resume()
}
    
    
}

