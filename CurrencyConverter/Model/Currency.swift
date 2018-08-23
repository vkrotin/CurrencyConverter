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
        return Currency("United States Dollar", "USD", "$", 1)
    }
    
    static func defaultCurrency2() -> Currency {
        return Currency("Euro", "EUR", "€", 0.87)
    }
    
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.fullName == rhs.fullName && lhs.shortName == rhs.shortName && lhs.ratio == rhs.ratio
    }
}
