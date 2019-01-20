//
//  DeviceNetworkController.swift
//  PhoneLibrary
//
//  Created by Robin De Bock on 20/12/2018.
//  Copyright © 2018 Robin De Bock. All rights reserved.
//

import Foundation
import Alamofire
class DeviceNetworkController {
    
    static let instance:DeviceNetworkController = DeviceNetworkController()
    
    private let baseURL = URL(string: "https://fonoapi.freshpixl.com/v1/")!
    
    private struct PropertyKeys {
        static let DevicesByBrandPathComponent = "getlatest"
        static let DevicesByNamePathComponent = "getdevice"
    }
    
    enum NetworkError : Error {
        case InvalidApiKey
        case EmptyApiKey
    }
    
    //Check if internet connection is available
    var isConnected:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    //Execute the URLSession datatask with the complete URL
    private func executeUrlSessionDataTask(with url:URL, completion: @escaping ([Device]?, NetworkError?) -> Void){
        if !isConnected{
            //No internet connection
            print("ERROR: no internet connection")
            completion(nil, nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Check for error
            guard error == nil else{
                print(error!.localizedDescription)
                completion(nil, nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
    
            if let data = data, let devices = try? jsonDecoder.decode([Device].self, from: data){
                completion(devices, nil)
                return
            }
                
            //Something went wrong
            
            //Check if data is an empty 2-dimensional array (aka Json="[[]]")
            //Only if all requirements are met we know there is an empty array
            if let parsedData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments), let dataArray = parsedData as? [[Any]]{
                if dataArray.count == 1, dataArray[0].isEmpty{
                    //return an empty list
                    completion([], nil)
                    return
                }
            }
            
            if let data = data, let errorMessage = try? jsonDecoder.decode(ErrorResult.self, from: data){
                if errorMessage.message.contains("No Matching Results Found"){
                    completion([], nil)
                    return
                }
                if errorMessage.message.contains("Invalid or Blocked Token"){
                    completion(nil, NetworkError.InvalidApiKey)
                    return
                }
                //A different error message was sent
                print("ERROR: \(errorMessage.message)")
                completion(nil, nil)
                return
            }
            
            //Result sets were not empty, something went wrong in decoding
            print("ERROR: Data was not correctly serialized")
            completion(nil, nil)
            return
        }
        task.resume()
    }
    
    func fetchDevicesByBrand(_ brand:String, completion: @escaping([Device]?, NetworkError?) -> Void) {
        let token = AppSettingsController.instance.networkApiKey
        
        //Check API token
        guard !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else{
            //No api token specified
            completion(nil, NetworkError.EmptyApiKey)
            return
        }
        //Adding path to base URL
        let url = baseURL.appendingPathComponent(PropertyKeys.DevicesByBrandPathComponent)
        
        //Define the query
        let query: [String: String] = [
            "token": token,
            "brand": brand
        ]
        
        //Adding the queries to the URL
        guard let completeUrl = url.withQueries(query) else {
            completion(nil, nil)
            print("ERROR: Unable to build URL with supplied queries.")
            return
        }
        
        //Callback function to fetch phones with the complete URL
        executeUrlSessionDataTask(with: completeUrl){(devices, error) in
            completion(devices, error)
        }
}
    
    func fetchDevicesByName(_ name:String, completion: @escaping([Device]?, NetworkError?) -> Void) {
        let token = AppSettingsController.instance.networkApiKey
        
        //Check API token
        guard !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else{
            //No api token specified
            completion(nil, NetworkError.EmptyApiKey)
            return
        }
        
        //Adding path to base URL
        let url = baseURL.appendingPathComponent(PropertyKeys.DevicesByNamePathComponent)

        //Define the query
        let query: [String: String] = [
            "token": token,
            "device": name
        ]
        
        //Adding the queries to the URL
        guard let completeUrl = url.withQueries(query) else {
            completion(nil, nil)
            print("ERROR: Unable to build URL with supplied queries.")
            return
        }
        
        //Callback function to fetch phones with the complete URL
        executeUrlSessionDataTask(with: completeUrl){(devices, error) in
            completion(devices, error)
        }
    }
    
    
}

//ErrorResult class
extension DeviceNetworkController{
    class ErrorResult:Decodable{
        var status:String
        var message:String
        var innerException:String
        
        required init(from decoder: Decoder) throws {
            let valueContainer = try decoder.container(keyedBy:CodingKeys.self)
            self.status = (try? valueContainer.decode(String.self, forKey: CodingKeys.status)) ?? ""
            self.message = (try? valueContainer.decode(String.self, forKey: CodingKeys.message)) ?? ""
            self.innerException = (try? valueContainer.decode(String.self, forKey: CodingKeys.innerException)) ?? ""
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case message
            case innerException
        }
    }
}

