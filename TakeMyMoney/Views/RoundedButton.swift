//
//  CircularButton.swift
//  CoolCalc
//
//  Created by Jody Abney on 4/17/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit

@IBDesignable // make displayable in Interface Builder
class RoundedButton: UIButton {
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    func customizeView() {
        
        // round the corners and clip
        layer.cornerRadius = 25
        clipsToBounds = true

    }
    
}
