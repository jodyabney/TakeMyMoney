//
//  CardHolder.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 5/2/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import Foundation

struct CardHolder {
    private var string: String

    init(_ string: String) throws {
        try Validations.cardHolder(string)
        self.string = string
    }

    func cardHolder() -> String {
        return string
    }
}
