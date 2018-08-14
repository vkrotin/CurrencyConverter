//
//  CUrl.swift
//  CurrencyConverter
//
//  Created by vkrotin on 13.08.2018.
//  Copyright © 2018 vkrotin. All rights reserved.
//

import Foundation

enum CUrl{
    case allCurrencies
    case ratioCurrency(String, String)
    
    func getString() -> String {
        switch self {
        case .allCurrencies:
            return "https://free.currencyconverterapi.com/api/v5/currencies"
        case .ratioCurrency(let inputKey, let outputKey):
            return "https://free.currencyconverterapi.com/api/v5/convert?compact=y&q=" + inputKey + "_" + outputKey
        }
    }
    
    func getURL() -> URL {
        return URL(string: self.getString())!
    }
    
    static func == (a: CUrl, b: CUrl) -> Bool {
        return a.getString() == b.getString()
    }
}
