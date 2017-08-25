//
//  cardView.swift
//  cardviewTable
//
//  Created by Syed Shahrukh Haider on 06/07/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit

@IBDesignable class cardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var shadowoffSetWidth: CGFloat = 0
    @IBInspectable var shadowoffSetHeight: CGFloat = 5
    @IBInspectable  var shadowColor : UIColor = UIColor.black
    @IBInspectable var shadowOpacity : CGFloat = 0
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowOffset = CGSize(width: shadowoffSetWidth, height: shadowoffSetHeight)
        layer.shadowColor = shadowColor.cgColor
        
        var shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
        
        
        
    }
}
