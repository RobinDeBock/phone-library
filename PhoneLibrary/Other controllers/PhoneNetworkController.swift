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
    private let limit = 10
    
    //Execute the URLSession datatask with the complete URL
    private func executeUrlSessionDataTask(with url:URL, completion: @escaping ([Phone]?) -> Void){
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
    
    func fetchPhonesByBrand(_ brand:String, completion: @escaping([Phone]?) -> Void) {
        //Adding path to base URL
        let url = baseURL.appendingPathComponent("getlatest")
        
        //Define the query
        let query: [String: String] = [
            "token": token,
            "brand": brand,
            "limit": String(limit)
        ]
        
        //Adding the queries to the URL
        guard let completeUrl = url.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        //Callback function to fetch phones with the complete URL
        executeUrlSessionDataTask(with: completeUrl){(phones) in
            completion(phones)
        }
}
    
    func fetchPhonesByName(_ name:String, completion: @escaping([Phone]?) -> Void) {
        //Adding path to base URL
        let url = baseURL.appendingPathComponent("getdevice")

        //Define the query
        let query: [String: String] = [
            "token": token,
            "device": name
        ]
        
        //Adding the queries to the URL
        guard let completeUrl = url.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        //Callback function to fetch phones with the complete URL
        executeUrlSessionDataTask(with: completeUrl){(phones) in
            completion(phones)
        }
    }
    
    
}

