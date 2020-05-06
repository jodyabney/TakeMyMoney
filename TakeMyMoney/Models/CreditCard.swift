//
//  CreditCard.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 5/2/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import Foundation

enum CreditCardType {
    case amex
    case discover
    case mastercard
    case visa
    case invalid
}

enum CreditCardDigitCount: Int {
    case amex = 15
    case other = 16
}

enum CreditCardDigitPattern: String {
    case amex = "465"
    case other = "4444"
}

enum CreditCardCVVDigitCount: Int {
    case amex = 4
    case other = 3
}

enum CreditCardLogo: String {
    case amex = "icons8-american-express-144.png"
    case discover = "icons8-discover-144.png"
    case mastercard = "icons8-mastercard-144.png"
    case visa = "icons8-visa-144.png"
}

struct CreditCard {
    var type: CreditCardType
    var number: String
    var validUntil: String
    var cvv: String
    var holder: String
    
}
