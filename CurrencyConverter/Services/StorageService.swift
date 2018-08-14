//
//  StorageService.swift
//  CurrencyConverter
//
//  Created by vkrotin on 13.08.2018.
//  Copyright © 2018 vkrotin. All rights reserved.
//

import Foundation

enum SaveType: String{
    case kSavedInputValue = "CC.savedInputValue"
    case kSavedInputCurrency = "CC.savedInputCurrency"
    case kSavedOutputCurrency = "CC.savedOutputCurrency"
}

class StorageService {
    
    func get(_ saveType: SaveType) -> Any? {
        var object:Any?
        
        switch saveType {
        case .kSavedInputValue:
            if UserDefaults.standard.object(forKey: saveType.rawValue) != nil {
                object = UserDefaults.standard.double(forKey: saveType.rawValue);
            }
            break
        case .kSavedInputCurrency, .kSavedOutputCurrency:
            if let data = UserDefaults.standard.value(forKey:saveType.rawValue) as? Data {
                object = try? PropertyListDecoder().decode(Currency.self, from: data)
            }
            break
        }
        return object
    }
        
    func set(_ value: Any, _ saveType: SaveType) {
        switch saveType {
        case .kSavedInputValue:
            guard let newValue = value as? Double else { return }
            UserDefaults.standard.set(newValue, forKey: saveType.rawValue)
            break
        case .kSavedInputCurrency, .kSavedOutputCurrency:
            guard let currency = value as? Currency else { return }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(currency), forKey:saveType.rawValue)
            break
        }
        UserDefaults.standard.synchronize()
    }
    
}

extension StorageService {
    
    func saveAllCurrencies(with dict: [String: Any], completion: @escaping ([Currency]?, CurrencyError?) -> Swift.Void) {
        var currencies = [Currency]()
        
        guard let dictResults = dict["results"] as? [String: [String: String]], dictResults.count > 0 else{
            completion(nil, CurrencyError(description: "Currencies' data format is wrong"))
            return
        }
        
        for (_, value) in dictResults {
            if let fullName = value["currencyName"], let shortName = value["id"], let symbol = value["currencySymbol"] {
                let currency = Currency(fullName, shortName, symbol, 1.0)
                currencies.append(currency)
            }
        }
        
        let sortArray = currencies.sorted(by: {c1, c2 in
            return c1.fullName < c2.fullName})
        
        completion(sortArray, nil)
    }
}
