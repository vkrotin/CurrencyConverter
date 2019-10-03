//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by vkrotin on 13.08.2018.
//  Copyright © 2018 vkrotin. All rights reserved.
//

import Foundation

enum CurrencyMode : Int {
    case inputCurrencyChanging = 1
    case outputCurrencyChanging = 2
    
}

struct CurrencyError : Error {
    let description : String
    var localizedDesc: String {
        return NSLocalizedString(description, comment: "")
    }
}

class CurrencyService{
    
    private let storageService = StorageService()
    private let serverService = ServerService()
    
    var currencies = [Currency]()
    var currencyNames = [String]()
    var currencyMode: CurrencyMode?
    
    init() {
        inputValue = storageService.get(.kSavedInputValue) as? Double ?? 100
        inputCurrency = storageService.get(.kSavedInputCurrency) as? Currency ?? Currency.defaultCurrency1()
        outputCurrency = storageService.get(.kSavedOutputCurrency) as? Currency ?? Currency.defaultCurrency2()
    }
    
    var inputValue: Double {
        didSet {
            if (oldValue != inputValue) {
                storageService.set(inputValue, .kSavedInputValue)
            }
        }
    }
    var outputValue: Double {
        get {
            var value = inputValue
            value *= outputCurrency.ratio
            return value
        }
    }
    
    func currency(_ mode: CurrencyMode) -> Currency {
        switch mode{
        case .inputCurrencyChanging:
            return inputCurrency
            
        case .outputCurrencyChanging:
            return outputCurrency
        }
    }
    
    
    var inputCurrency: Currency {
        didSet {
            if (oldValue != inputCurrency) {
                storageService.set(inputCurrency, .kSavedInputCurrency)
            }
        }
    }
    var outputCurrency: Currency {
        didSet {
            if (oldValue != outputCurrency) {
                storageService.set(outputCurrency, .kSavedOutputCurrency)
            }
        }
    }
    
    var rateText: String {
        get {
            return "1 \(inputCurrency.shortName) = \(outputCurrency.ratio) \(outputCurrency.shortName)"
        }
    }
    
    func update(output:String) -> String  {
        if output == ""{
            return ""
        }
        let buf = Double(output)! / outputCurrency.ratio
        return String(Double(round(100*buf)/100))
    }
    
    func update(input:String) -> String  {
        if input == ""{
            return ""
        }
        let buf = Double(input)! * outputCurrency.ratio
        return String(Double(round(100*buf)/100))
    }
    
    
    
    //MARK: Server methods
    
    func getAllCurrencies(_ completion: @escaping (Error?) -> Swift.Void) {
        serverService.getRequestForType(type: .allCurrencies, completion: { [weak self] (object, error) in
            
            
            if let _error = error {
                DispatchQueue.main.async {
                    completion(_error)
                }
                return
            }
     
            guard let array = object as? [Currency] else{
                    DispatchQueue.main.async {
                        completion(error)
                    }
                self?.currencies = self?.serverService.get(.kSavedAllCurrency) as! [Currency]
                    return
            }
            self?.currencies = array
            
            DispatchQueue.main.async {
                completion(nil)
            }
        })
    }
    
    func getOutputCurrencyRatio(newCurrency: Currency?, completion: @escaping (CurrencyError?) -> Swift.Void) {
        var buffInputCSName = inputCurrency.shortName
        var buffOutputCSName = outputCurrency.shortName
        
        if let mode = self.currencyMode, let newCurrency = newCurrency {
            switch mode {
            case .inputCurrencyChanging:
                buffInputCSName = newCurrency.shortName
            case .outputCurrencyChanging:
                buffOutputCSName = newCurrency.shortName
            }
        }
        
        serverService.getRequestForType(type: .ratioCurrency(buffInputCSName, buffOutputCSName),
                                                      completion: {[weak self] (dict, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(CurrencyError(description: "Error in request ratio for currency"))
                }
                return
            }
            
            guard let sself = self,
                let dictResponse = dict as? [String : Any],
                let mode = sself.currencyMode,
                let newCurrency = newCurrency else{
                    DispatchQueue.main.async {
                        completion(CurrencyError(description: "Error in modificate currance"))
                    }
                    return
            }
            
            switch mode {
            case .inputCurrencyChanging:
                sself.inputCurrency = newCurrency
            case .outputCurrencyChanging:
                sself.outputCurrency = newCurrency
            }
            
            let key = "\(sself.inputCurrency.shortName)_\(sself.outputCurrency.shortName)"
            
            guard let dictValue = dictResponse[key] as! [String: Double]?, dictValue.count > 0,
                let val = dictValue["val"] else{
                    DispatchQueue.main.async {
                        completion(CurrencyError(description: "Error in saving ratio for currency"))
                    }
                    return
            }
            sself.outputCurrency.ratio = val
            sself.storageService.set(sself.outputCurrency, .kSavedOutputCurrency)
                                                        
            DispatchQueue.main.async {
                completion(nil)
            }
        })
    }
    
}
