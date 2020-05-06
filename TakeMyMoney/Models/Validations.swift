//
//  Validations.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 5/2/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import Foundation

enum EvaluateError: Error {
    case isEmpty
    case isNotValidEmailAddress
    case isNotValidEmailLength
    case isNotValidCardHolder
    case isNotValidLength
    case isNotValidCVV
    case isNotValidNumber
    case isNotValidUntilDate
}

struct Validations {
    
    // Private Properties
    
    private static let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
        + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    private static let cardHolderRegEx = "[A-Z][a-z]+ [A-Z][a-z]+"
    
    private static let cvvOther = "[0-9]{3}"
    private static let cvvAmex = "[0-9]{4}"
    
    private static let numberAmexRegEx = "[0-9]{15}"
    private static let numberOtherRegEx =  "[0-9]{16}"
    
    
    //MARK: - Public Methods

    public static func email(_ string: String) throws {
        if string.isEmpty == true {
            throw EvaluateError.isEmpty
        }

        if isValid(input: string,
                   regEx: emailRegEx,
                   predicateFormat: "SELF MATCHES[c] %@") == false {
            throw EvaluateError.isNotValidEmailAddress
        }

        if maxLengthEmail(emailAddress: string) == false {
            throw EvaluateError.isNotValidEmailLength
        }
    }
    
    public static func password(_ string: String) throws {
        if string.isEmpty == true {
            throw EvaluateError.isEmpty
        }
    }
    
    public static func cardHolder(_ string: String) throws {
        if string.isEmpty == true {
            throw EvaluateError.isEmpty
        }
        
        if isValid(input: string, regEx: cardHolderRegEx) == false {
            throw EvaluateError.isNotValidCardHolder
        }
        
        if maxLength(string: string) == false {
            throw EvaluateError.isNotValidLength
        }
    }
    
    public static func cardCVV(_ string: String, numOfDigits: Int) throws {
        if string.isEmpty == true {
            throw EvaluateError.isEmpty
        }
        
        switch numOfDigits {
        case CreditCardCVVDigitCount.other.rawValue:
            if isValid(input: string, regEx: cvvOther) == false {
                throw EvaluateError.isNotValidCVV
            }
        case CreditCardCVVDigitCount.amex.rawValue:
            if isValid(input: string, regEx: cvvAmex) == false {
                throw EvaluateError.isNotValidCVV
            }
        default:
            throw EvaluateError.isNotValidCVV
        }
        
        if exactLength(string: string, length: numOfDigits) == false {
            throw EvaluateError.isNotValidLength
        }
    }
    
    public static func cardNumber(_ string: String, numOfDigits: Int) throws {
        // empty field
        if string.isEmpty == true {
            throw EvaluateError.isEmpty
        }
        // contains digits only
        if digitsOnly(string: string) == false {
            throw EvaluateError.isNotValidNumber
        }
        // correct number of digits
        if exactLength(string: string, length: numOfDigits) == false {
            throw EvaluateError.isNotValidLength
        }
    }
    
    public static func cardValidUntil(_ string: String) throws {
        // empty field
        if string.isEmpty == true {
            throw EvaluateError.isEmpty
        }
        // validUntil Date is greater than or equal to the current month/year
        let dateComponents = Calendar.current.dateComponents([.month, .year], from: Date()) // current date
        let validUntil: [String.SubSequence] = string.split(separator: "/")
        if let year = Int(validUntil[1]), let month = Int(validUntil[0]) {
            // check for year less than current year
            if year < dateComponents.year! {
                throw EvaluateError.isNotValidUntilDate
                // check for year = current year and month less than current month
            } else if year == dateComponents.year! && month < dateComponents.month! {
                throw EvaluateError.isNotValidUntilDate
            }
        }
    }

    // MARK: - Private Methods
    
    private static func isValid(input: String, regEx: String, predicateFormat: String) -> Bool {
        return NSPredicate(format: predicateFormat, regEx).evaluate(with: input)
    }
    
    private static func isValid(input: String, regEx: String) -> Bool {
        return input.range(of: regEx, options: .regularExpression) != nil
    }

    private static func maxLengthEmail(emailAddress: String) -> Bool {
        // 64 chars before domain and total 80. '@' key is part of the domain.
        guard emailAddress.count <= 80 else {
            return false
        }

        guard let domainKey = emailAddress.firstIndex(of: "@") else { return false }

        return emailAddress[..<domainKey].count <= 64
    }
    
    private static func maxLength(string: String) -> Bool {
        // assumption of no more than 40-characters as a general requirement
        guard string.count <= 40 else { return false }
        
        return true
    }
    
    private static func exactLength(string: String, length: Int) -> Bool {
        guard string.count == length else { return false }
        
        return true
    }
    
    private static func digitsOnly(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
