//
//  ProgressView.swift
//  CurrencyConverter
//
//  Created by vkrotin on 14.08.2018.
//  Copyright © 2018 vkrotin. All rights reserved.
//

import UIKit

class ProgressView: XibView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override var nibName : String {
        get {return "ProgressView"}
        set {}
    }
    
    static func showProgress(view toView:UIView){
        let pView = ProgressView.init(frame: toView.frame)
        pView.activityIndicator.startAnimating()
        toView.addSubview(pView)
        toView.bringSubview(toFront: pView)
    }
    
    static func hideProgress(view toView:UIView){
        guard let pView = ProgressInView(forView: toView) else{
            return
        }
        
        pView.activityIndicator.stopAnimating()
        pView.removeFromSuperview()
    }
    
    private static func ProgressInView(forView view:UIView) -> ProgressView?{
        let enumirator = view.subviews.reversed()
        for v in enumirator{
            if v.isKind(of: self){
                return v as? ProgressView
            }
        }
        return nil
    }

}
