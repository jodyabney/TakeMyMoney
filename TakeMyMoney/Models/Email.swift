//
//  Email.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 5/2/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//


import Foundation

struct Email {
    private var string: String

    init(_ string: String) throws {
        try Validations.email(string)
        self.string = string
    }

    func address() -> String {
        return string
    }
}
