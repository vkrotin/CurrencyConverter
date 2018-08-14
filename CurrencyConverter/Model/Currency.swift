//
//  Currency.swift
//  CurrencyConverter
//
//  Created by vkrotin on 12.08.2018.
//  Copyright © 2018 vkrotin. All rights reserved.
//

import UIKit

class Currency: Codable,  Equatable{
    let shortName: String
    let fullName: String
    let symbol : String
    var ratio: Double

    
    init(_ fullName: String, _ shortName: String, _ symbol: String, _ ratio: Double) {
        self.fullName = fullName
        self.shortName = shortName
        self.ratio = ratio
        self.symbol = symbol
    }
    
    static func defaultCurrency1() -> Currency {
        let currency = self.init("United States Dollar", "USD", "$", 1)
        return currency
    }
    
    static func defaultCurrency2() -> Currency {
        let currency = self.init("Euro", "EUR", "€", 0.87)
        return currency
    }
    
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.fullName == rhs.fullName && lhs.shortName == rhs.shortName && lhs.ratio == rhs.ratio
    }
}
