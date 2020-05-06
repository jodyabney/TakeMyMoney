//
//  CardValidUntil.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 5/3/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import Foundation

struct CardValidUntil {
    private var string: String

    init(_ string: String) throws {
        try Validations.cardValidUntil(string)
        self.string = string
    }

    func cardValidUntil() -> String {
        return string
    }
}
