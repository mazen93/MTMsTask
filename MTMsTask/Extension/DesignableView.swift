//
//  DesignableView.swift
//  SafarIn
//
//  Created by Mohamed Macbook on 5/9/21.
//

import Foundation
import UIKit
@IBDesignable
class DesignableView: UIView {
    
    
    @IBInspectable var cornerRadius:CGFloat=0
    @IBInspectable var shadowColor:UIColor?=UIColor.black
    @IBInspectable var borderColor: UIColor?=UIColor.black
    @IBInspectable var borderWidth: CGFloat = 0
    
    
    override func layoutSubviews() {
        layer.borderColor=borderColor?.cgColor
        layer.borderWidth=borderWidth
        layer.cornerRadius=cornerRadius
        layer.shadowColor=shadowColor?.cgColor
    
    
    
    }
    
}

