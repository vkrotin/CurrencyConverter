//
//  CurrBox.swift
//  CurrencyConverter
//
//  Created by vkrotin on 21.08.2018.
//  Copyright © 2018 vkrotin. All rights reserved.
//

import Foundation


struct CurrBox {
    
    var currency:Currency?
    var buttonMode:CurrencyMode?
    
    init(_ currency:Currency, _ mode:CurrencyMode) {
        self.currency = currency
        self.buttonMode = mode
    }

    var fullName: String {
        get{
            guard let name = currency?.fullName else{
                return ""
            }
            return name
        }
        set{}
    }
    
    var shortName: String {
        get{
            guard let name = currency?.shortName else{
                return ""
            }
            return name
        }
        set{}
    }
    
}
