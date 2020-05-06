//
//  CardCVV.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 5/2/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import Foundation

struct CardCVV {
    private var string: String
    private var numOfDigits: Int

    init(_ string: String, numOfDigits: Int) throws {
        try Validations.cardCVV(string, numOfDigits: numOfDigits)
        self.string = string
        self.numOfDigits = numOfDigits
    }

    func cvv() -> String {
        return string
    }
}
