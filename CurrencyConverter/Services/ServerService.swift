//
//  ServerService.swift
//  CurrencyConverter
//
//  Created by vkrotin on 13.08.2018.
//  Copyright © 2018 vkrotin. All rights reserved.
//

import Foundation

class ServerService : StorageService{
    
    static let sharedService = ServerService()
    
    func getRequestForType(type: CUrl, completion: @escaping (Any?, Error?) -> Swift.Void){
        getJSON(URL: type.getURL(), completion: { (dict, error) in
            if type == CUrl.allCurrencies{
                self.saveAllCurrencies(with: dict!, completion: completion)
            }else{
                completion(dict, error)
            }
        })
    }
    
    // MARK: - Private methods
    
    private func getJSON(URL: URL, completion: @escaping ([String: Any]?, Error?) -> Swift.Void) {
        let dataTask = URLSession.shared.dataTask(with: URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                //print("Error to load: \(String(describing: error?.localizedDescription))")
                completion(nil, error)
                return
            }
            
            if let dataResponse = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [String: AnyObject]
                    //print("json: \(json), error: \(String(describing: error))")
                    completion(json, nil)
                    return
                    
                } catch let error as NSError {
                    //print("Failed to load: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        })
        dataTask.resume()
    }
    
}

