//
//  UIAlertControllerExtension.swift
//  CurrencyConverter
//
//  Created by vkrotin on 17.08.2018.
//  Copyright © 2018 vkrotin. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController{
    
    class func messageAlertController(title : String, message : String) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(action)
        return alertController
    }
}
