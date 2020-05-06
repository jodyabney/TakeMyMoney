//
//  Password.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 5/2/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import Foundation

struct Password {
    private var string: String

    init(_ string: String) throws {
        try Validations.password(string)
        self.string = string
    }

    func password() -> String {
        return string
    }
}
