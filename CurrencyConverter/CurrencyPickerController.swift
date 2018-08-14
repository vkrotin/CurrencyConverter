//
//  CurrencyPickerController.swift
//  CurrencyConverter
//
//  Created by vkrotin on 10.08.2018.
//  Copyright © 2018 vkrotin. All rights reserved.
//

import UIKit

protocol CurrencyPickerDelegate : class {
    func currencyPickerSelected(sender: Currency, bMode: CurrencyMode)
}



class CurrencyPickerController: UIViewController {
    // MARK: Initialize
    
    @IBOutlet weak var itemTitle: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var modalBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: CurrencyPickerDelegate?
    
    var currency:Currency?
    var buttonMode:CurrencyMode?
    
    var initialTouchPoint = CGPoint(x: 0,y: 0)
    var intitialConstraint:CGFloat = 0
    let initialAlpha:CGFloat = 0.3
    
    var currencyArray:[Currency]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intitialConstraint = modalBottomConstraint.constant;
        currency?.ratio = 1
        
        showModalView(false, false)
        
        itemTitle.title = currency?.fullName
        
        guard let indexRow = currencyArray?.index(of: currency!) else{
            return
        }
        pickerView.selectRow(indexRow, inComponent: 0, animated: false)   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showModalView(true, true)
    }
    
  
    //MARK: Actions
    
    @IBAction func closeAction(_ sender: Any) {
        showModalView(false, true)
    }
    
    @IBAction func applyAction(_ sender: Any) {
        guard let row = pickerView?.selectedRow(inComponent: 0),
            let object = currencyArray?[row] else {
            return
        }
        
        self.delegate?.currencyPickerSelected(sender: object, bMode: buttonMode!)
        showModalView(false, true)
    }
    
    @IBAction func changeGestureAction(_ sender: UIPanGestureRecognizer) {
        gestureAnimation(sender)
    }
}

extension CurrencyPickerController{

    //MARK: Animation
    
    func gestureAnimation(_ sender: UIPanGestureRecognizer){
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                let deltaY = touchPoint.y - initialTouchPoint.y
                modalBottomConstraint.constant = -deltaY
                self.view.layoutIfNeeded()
                
                let alpha = (initialAlpha * modalView.frame.origin.y - deltaY) / modalView.frame.origin.y
                self.view.backgroundColor = UIColor.init(white: 0.0, alpha: alpha)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            showModalView(touchPoint.y - initialTouchPoint.y < modalView.bounds.height/3.0, true)
        }
    }
    
    func showModalView(_ isShowView:Bool, _ animation:Bool) {
        modalBottomConstraint.constant = isShowView ? 0 : -modalView.bounds.height
        if (animation == false){
            self.view.backgroundColor = UIColor.init(white: 0.0, alpha:isShowView ? self.initialAlpha : 0.0)
            self.view.layoutIfNeeded()
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor.init(white: 0.0, alpha:isShowView ? self.initialAlpha : 0.0)
            self.view.layoutIfNeeded()
        }, completion: { (complite:Bool) in
            if isShowView == true{
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
}


extension CurrencyPickerController : UIPickerViewDataSource, UIPickerViewDelegate{

    //MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray!.count
    }
    
    //MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return currencyArray![row].fullName
    }
}
