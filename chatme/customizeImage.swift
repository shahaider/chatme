//
//  customizeImage.swift
//  chatme
//
//  Created by Syed Shahrukh Haider on 25/08/2017.
//  Copyright © 2017 Syed Shahrukh Haider. All rights reserved.
//

import UIKit

@IBDesignable class customizeImage: UIImageView {
    
    @IBInspectable var cornerRadius : CGFloat = 0{
    
    didSet{
        layer.cornerRadius = cornerRadius
        }
    
    }
    
    
    @IBInspectable var borderWidth : CGFloat = 0{
    
        didSet{
        
        layer.borderWidth = borderWidth
        
        }
    
    }
    
    @IBInspectable var borderColor : UIColor = .clear {
        
        didSet{
            layer.borderColor = borderColor.cgColor
            
        }
        
    }
}
