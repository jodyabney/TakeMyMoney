//
//  PaymentMethodSegmentedControl.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 5/6/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit

@IBDesignable // make displayable in Interface Builder
class PaymentMethodSegmentedControl: UISegmentedControl {

    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    func customizeView() {
        // set up the Payment Method Segmented Control Appearance
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        setTitleTextAttributes(attributes, for: .selected)
        setTitleTextAttributes(attributes, for: .normal)
    }
}
