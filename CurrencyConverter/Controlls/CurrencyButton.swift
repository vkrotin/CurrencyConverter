//
//  CurrencyButton.swift
//  CurrencyConverter
//
//  Created by vkrotin on 10.08.2018.
//  Copyright © 2018 vkrotin. All rights reserved.
//

import UIKit

@objc protocol CurrencyButtonDelegate : class {
    func currencyButtonTouch(sender: CurrencyButton)
    func currencyChangeText(sender: CurrencyButton, text:String)
    func currencyClearText(sender: CurrencyButton)
}

@IBDesignable class CurrencyButton: XibView {
    //MARK: Intialize
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var currencyField: UITextField!
    @IBOutlet weak var delegate: CurrencyButtonDelegate?
    
    override var nibName : String {
        get {return "CurrencyButton"}
        set {}
    }
    
    override func prepareForInterfaceBuilder() {
        customInspectible()
    }
    
    override func awakeFromNib() {
        customInspectible()
    }
    
    private func customInspectible(){
        currencyField.text = currencyText
        button.setTitle(buttonText, for: .normal)
        
        layer.cornerRadius = cornerRaduis
        view.backgroundColor = backgroundButton
        currencyField.textColor = currencyColor
        button.setTitleColor(buttonTextColor, for: .normal)
    }
    
    
    //MARK: Inspectable
   
    var currencyMode: CurrencyMode?
    
    @IBInspectable var buttonType: Int = 0{
        didSet{
            currencyMode = CurrencyMode(rawValue: buttonType)!
        }
    }
    
    @IBInspectable var currencyText: String = "" {
        didSet{
            currencyField.text = currencyText
        }
    }

    @IBInspectable var buttonText: String = "USD" {
        didSet{
            button.setTitle(buttonText, for: .normal)
        }
    }
    
    @IBInspectable var cornerRaduis: CGFloat = 10 {
        didSet{
            layer.cornerRadius = cornerRaduis
        }
    }
    
    @IBInspectable var backgroundButton: UIColor = .white{
        didSet{
            view.backgroundColor = backgroundButton
        }
    }
    
    @IBInspectable var buttonTextColor: UIColor = .black{
        didSet{
            button.setTitleColor(buttonTextColor, for: .normal)
        }
    }
    
    @IBInspectable var currencyColor: UIColor = .black{
        didSet{
            currencyField.textColor = currencyColor
        }
    }
    
    //MARK: Actions
    
    func getCurrencyText() -> String {
        return currencyField.text ?? ""
    }
    
    @IBAction func currencyButtonTouch(button: UIButton) {
       // print("button touch")
        currencyField.resignFirstResponder()
        delegate?.currencyButtonTouch(sender: self)
        
    }
}

extension CurrencyButton : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == currencyField {
            if textField.availableAdding(string: string) {
                textField.addString(string)
                delegate?.currencyChangeText(sender: self, text: textField.text ?? "")
            }
            return false
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == currencyField {
            textField.clear()
            delegate?.currencyClearText(sender: self)
            return false
        }
        return true
    }
    
}
