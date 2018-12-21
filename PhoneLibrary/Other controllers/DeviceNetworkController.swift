//
//  DeviceNetworkController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
class DeviceNetworkController {
    
    static let instance:DeviceNetworkController = DeviceNetworkController()
    
    private let baseURL = URL(string: "https://fonoapi.freshpixl.com/v1/")!
    private let token = "90847b79ba574f0e0dc81a27d48f21e1016bbac53dee41c7"
    private let limit = 2
    
    //Execute the URLSession datatask with the complete URL
    private func executeUrlSessionDataTask(with url:URL, completion: @escaping ([Device]?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Check for error
            guard error == nil else{
                //print the error and return nill
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            
            //Check if data is an empty 2-dimensional array (aka Json="[[]]")
            //This requires a very specific amount of steps, wich can all throw an error
            //Only if all requirements are met (aka no errors) we know there is an empty array
            do{
                let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let dataArray = parsedData as! [[Any]]
                if dataArray.isEmpty{
                    //return an empty list
                    completion([])
                    return
                }
            }catch _{}
                let jsonDecoder = JSONDecoder()
                if let data = data, let devices = try? jsonDecoder.decode([Device].self, from: data){
                    completion(devices)
                }
                else {
                    print("Data was not correctly serialized")
                    completion(nil)
                    return
            }

        }
        task.resume()
    }
    
    func fetchDevicesByBrand(_ brand:String, completion: @escaping([Device]?) -> Void) {
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
        executeUrlSessionDataTask(with: completeUrl){(devices) in
            completion(devices)
        }
}
    
    func fetchDevicesByName(_ name:String, completion: @escaping([Device]?) -> Void) {
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
        executeUrlSessionDataTask(with: completeUrl){(devices) in
            completion(devices)
        }
    }
    
    
}

