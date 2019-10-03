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
            
            guard let result = dict else{
                completion(nil, error)
                return
            }
            
            if type == CUrl.allCurrencies{
                self.saveAllCurrencies(with: result, completion: completion)
            }else{
                completion(result, error)
            }
        })
    }
    
    // MARK: - Private methods
    
    private func getJSON(URL: URL, completion: @escaping ([String: Any]?, Error?) -> Swift.Void) {
        let dataTask = URLSession.shared.dataTask(with: URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completion(nil, error)
                return
            }
            
            guard let dataResponce = data else{
                completion(nil, error)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: dataResponce, options: []) as! [String: AnyObject]
                if let errorString = json["error"], let errorCode = json["status"] as? Int {
                    let error = NSError(domain: "me", code: errorCode, userInfo: [NSLocalizedDescriptionKey : errorString])
                    completion(nil, error)
                }
                completion(json, nil)
                return
            } catch let error as NSError {
                completion(nil, error)
            }
        })
        dataTask.resume()
    }
    
}

