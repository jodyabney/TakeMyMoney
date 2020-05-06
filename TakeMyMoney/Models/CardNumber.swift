//
//  CardNumber.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 5/2/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import Foundation

struct CardNumber {
    private var string: String
    private var numOfDigits: Int

    init(_ string: String, numOfDigits: Int) throws {
        try Validations.cardNumber(string, numOfDigits: numOfDigits)
        self.string = string
        self.numOfDigits = numOfDigits
    }

    func cardNumber() -> String {
        return string
    }
}
