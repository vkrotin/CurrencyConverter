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
        let key = "61535f282ade201fdaab"
        switch self {
        case .allCurrencies:
            return "\(getServerUrl())/currencies?apiKey=\(key)"
        case .ratioCurrency(let inputKey, let outputKey):
            return "\(getServerUrl())/convert?compact=y&q=\(inputKey)_\(outputKey)&apiKey=\(key)"
        }
    }
    
    func getURL() -> URL {
        return URL(string: self.getString())!
    }
    
    static func == (a: CUrl, b: CUrl) -> Bool {
        return a.getString() == b.getString()
    }
    
    func getServerUrl() -> String {
        return "https://free.currconv.com/api/v7"
    }
}
