//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by vkrotin on 10.08.2018.
//  Copyright © 2018 vkrotin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Parameters
    
    @IBOutlet weak var fromButton: CurrencyButton!
    @IBOutlet weak var toButton: CurrencyButton!
    @IBOutlet weak var rateLabel: UILabel!
    
    let currencyService = CurrencyService()

    
    //MARK: Initialize

    override func viewDidLoad() {
        super.viewDidLoad()

        
        fromButton.buttonText = currencyService.inputCurrency.shortName
        toButton.buttonText = currencyService.outputCurrency.shortName
        rateLabel.text = currencyService.rateText
        
        toButton.currencyText = currencyService.update(input: fromButton.getCurrencyText())
      
        ProgressView.showProgress(view: self.view)
        currencyService.getAllCurrencies({[weak self] error in
            ProgressView.hideProgress(view: self?.view)
            guard let err = error else{
                return
            }
            let allert = UIAlertController.messageAlertController(title: "Warning", message: err.localizedDescription)
            self?.present(allert, animated: true, completion: nil)
        })
    }

    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currencyList",
            let control = segue.destination as? CurrencyPickerController {
            //control.delegate = self
            control.currencyArray = currencyService.currencies
            
            guard let button = sender as? CurrencyButton,
                let mode = button.currencyMode else{
                    return
            }
            
            control.currBox = CurrBox.init(currencyService.currency(mode), mode)
            control.listenerBox = Box(nil)
            control.listenerBox?.bind{[weak self] box in
                guard let gBox = box else{
                    return
                }
                
                ProgressView.showProgress(view: self?.view)
                self?.setControllText(shortName: gBox.shortName, type: gBox.buttonMode!)
                self?.currencyService.currencyMode = gBox.buttonMode!
                self?.currencyService.getOutputCurrencyRatio(newCurrency: gBox.currency, completion: {[weak self] error in
                    ProgressView.hideProgress(view: self?.view)
                    guard let sself = self else{
                        return
                    }
                    guard let err = error else{
                        sself.rateLabel.text = sself.currencyService.rateText
                        sself.toButton.currencyText = sself.currencyService.update(input: sself.fromButton.getCurrencyText())
                        return
                    }
                    sself.setControllText(shortName: nil, type: gBox.buttonMode!)
                    
                    let allert = UIAlertController.messageAlertController(title: "Warning", message: err.description)
                    sself.present(allert, animated: true, completion: nil)
                })
            }
        }
    }
}


//MARK: CyrrencyButton delegate

extension ViewController : CurrencyButtonDelegate{
    
    func currencyChangeText(sender: CurrencyButton, text: String) {
        guard let mode = sender.currencyMode else{
            return
        }
        switch mode {
        case .inputCurrencyChanging:
            self.toButton.currencyText = currencyService.update(input: text)
            break
        case .outputCurrencyChanging:
        self.fromButton.currencyText = currencyService.update(output: text)
            break
        }
    }
    
    func currencyClearText(sender: CurrencyButton) {
        guard let mode = sender.currencyMode else{
            return
        }
        switch mode {
        case .inputCurrencyChanging:
            self.toButton.currencyText = currencyService.update(input: "")
            break
        case .outputCurrencyChanging:
            self.fromButton.currencyText = currencyService.update(output: "")
            break
        }
    }
    
    
    func currencyButtonTouch(sender: CurrencyButton) {
        performSegue(withIdentifier: "currencyList", sender: sender)
    }
    
    //MARK: action and methods
    
    @IBAction func tapOnView(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    private func setControllText(shortName:String?, type:CurrencyMode){
        switch type {
        case .inputCurrencyChanging:
            guard let name = shortName else{
                self.fromButton.buttonText = self.currencyService.inputCurrency.shortName
                return
            }
            self.fromButton.buttonText = name
            break
        case .outputCurrencyChanging:
            guard let name = shortName else{
                self.toButton.buttonText = self.currencyService.outputCurrency.shortName
                return
            }
            self.toButton.buttonText = name
            break
        }
    }
}

