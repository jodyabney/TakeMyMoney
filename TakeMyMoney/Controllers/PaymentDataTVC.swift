//
//  PaymentDataTableViewController.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 4/30/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit

class PaymentDataTVC: UITableViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    
    var isEditingValidUntilDate: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    var selectedPaymentMethod: PaymentMethod = .payPal {
        didSet {
            switch selectedPaymentMethod {
            case .payPal:
                // reset all the card data and fields
                cardType = nil
                cardNumber = nil
                cardNumberText.text = nil
                cardNumberText.resignFirstResponder()
                validUntil = nil
                validUntilText.text = nil
                validUntilText.resignFirstResponder()
                cvv = nil
                cvvText.text = nil
                cvvText.resignFirstResponder()
                cardHolder = nil
                cardHolderText.text = nil
                cardNumberText.resignFirstResponder()
                saveCardData = false
                saveCardDataSwitch.isOn = false
                disableProceedButton()
            case .creditCard:
                // reset the PayPal data and fields
                paypalEmail = nil
                paypalEmailText.text = nil
                paypalEmailText.resignFirstResponder()
                paypalPassword = nil
                paypalPasswordText.text = nil
                paypalPasswordText.resignFirstResponder()
                disableProceedButton()
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    // PayPal rows
    let paypalEmailIndexPath = IndexPath(row: 5, section: 0)
    let paypalPasswordIndexPath = IndexPath(row: 6, section: 0)
    
    //PayPal entries
    var paypalEmail: String?
    var paypalPassword: String?
    
    // Credit Card rows
    let creditcardNumberIndexPath = IndexPath(row: 7, section: 0)
    let validUntilAndCVVLabelIndexPath = IndexPath(row: 8, section: 0)
    let validUntilAndCVVIndexPath = IndexPath(row: 9, section: 0)
    let datePickerIndexPath = IndexPath(row: 10, section: 0)
    let cardHolderLabelIndexPath = IndexPath(row: 11, section: 0)
    let cardHolderIndexPath = IndexPath(row: 12, section: 0)
    let saveCardDataIndexPath = IndexPath(row: 13, section: 0)
    
    // Credit Card entries
    var creditCard: CreditCard?
    var cardType: CreditCardType?
    var cardNumber: String? {
        didSet {
            updatePaymentLogoAndSetType()
        }
    }
    var maskedCardNumber: String? {
        get {
            return maskCardNumber(cardNumber!)
        }
    }
    var validUntil: String?
    var cvv: String?
    var cardHolder: String?
    var saveCardData: Bool = false
    
    
    //MARK: - IBOutlets
    
    // General
    @IBOutlet weak var paymentMethodControl: UISegmentedControl!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var proceedButton: RoundedButton!
    
    // PayPal
    @IBOutlet weak var paypalEmailText: UITextField!
    @IBOutlet weak var paypalPasswordText: UITextField!
    
    // PayPal Error Labels
    @IBOutlet weak var invalidPayPalEmailLabel: UILabel!
    @IBOutlet weak var missingPayPalPasswordLabel: UILabel!
    
    // Credit Card
    @IBOutlet weak var creditCardLogo: UIImageView!
    @IBOutlet weak var cardNumberText: UITextField!
    @IBOutlet weak var validUntilText: UITextField!
    @IBOutlet weak var validUntilMonthYearPicker: MonthYearPickerView!
    @IBOutlet weak var cvvText: UITextField!
    @IBOutlet weak var cardHolderText: UITextField!
    @IBOutlet weak var saveCardDataSwitch: UISwitch!
    
    // Credit Card Error Labels
    @IBOutlet weak var invalidCardNumberLabel: UILabel!
    @IBOutlet weak var invalidValidityDateLabel: UILabel!
    @IBOutlet weak var invalidCVVNumberLabel: UILabel!
    @IBOutlet weak var invalidCardHolderLabel: UILabel!
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the Payment Method Segmented Control Appearance
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        paymentMethodControl.setTitleTextAttributes(attributes, for: .selected)
        paymentMethodControl.setTitleTextAttributes(attributes, for: .normal)
        
        paymentTypeLabel.text = selectedPaymentMethod.rawValue
        
        // set TextField Delegates
        paypalEmailText.delegate = self
        paypalPasswordText.delegate = self
        cardNumberText.delegate = self
        cvvText.delegate = self
        cardHolderText.delegate = self
        validUntilText.delegate = self
        
        // set up the monthYearPicker
        validUntilMonthYearPicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            self.validUntilText.text = string
        }
        
        // hide all error labels
        invalidPayPalEmailLabel.isHidden = true
        missingPayPalPasswordLabel.isHidden = true
        invalidCardNumberLabel.isHidden = true
        invalidValidityDateLabel.isHidden = true
        invalidCVVNumberLabel.isHidden = true
        invalidCardHolderLabel.isHidden = true
        
        // ensure the proceed button is disabled initially
        disableProceedButton()
        
        // Register the view controller as observer of UITextField.textDidChangeNotification to use for determining if the Proceed button should be enabled
        NotificationCenter.default.addObserver(self, selector: #selector(validEntriesForPaymentMethod(_:)), name: UITextField.textDidChangeNotification, object: nil)

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Notification Handling

    @objc private func validEntriesForPaymentMethod(_ notification: Notification) {
        
        switch selectedPaymentMethod {
        case .payPal:
            if validPayPalEmail() && validPayPalPassword() {
                enableProceedButton()
            } else {
                disableProceedButton()
            }
        case .creditCard:
            if cardType != nil && cardType != CreditCardType.invalid &&
                validCardNumber() && validCardValidUntil() &&
                validCVV() && validCardHolder() {
                enableProceedButton()
            } else {
                disableProceedButton()
            }
        }
    }
    
    func enableProceedButton() {
        proceedButton.isEnabled = true
        proceedButton.backgroundColor = #colorLiteral(red: 0.352404952, green: 0.4601201415, blue: 0.9817141891, alpha: 1)
    }
    
    func disableProceedButton() {
        proceedButton.isEnabled = false
        proceedButton.backgroundColor = #colorLiteral(red: 0.6285626888, green: 0.6886372566, blue: 0.9536932111, alpha: 1)
    }
    
    
    //MARK: - Instance Methods
    
    func updatePaymentMethodView() {
        
        switch selectedPaymentMethod {
        case .payPal:
            paymentTypeLabel.text = selectedPaymentMethod.rawValue
        case .creditCard:
            paymentTypeLabel.text = selectedPaymentMethod.rawValue
        }
    }
    
    
    func updatePaymentLogoAndSetType() {
        guard let cardNumber = cardNumberText.text else { return }
        
        switch cardNumber.first {
        case "4": // Visa cards start with a 4
            creditCardLogo.image = UIImage(named: "icons8-visa-144.png")
            cardType = .visa
        case "3": // AMEX cards start with a 3
            creditCardLogo.image = UIImage(named: "icons8-american-express-144.png")
            cardType = .amex
        case "5": // Mastercards cards start with a 5
            creditCardLogo.image = UIImage(named: "icons8-mastercard-logo-144.png")
            cardType = .mastercard
        case "6": // Discover cards start with a 6
            creditCardLogo.image = UIImage(named: "icons8-discover-144.png")
            cardType = .discover
        default: // consider all other starting numbers to be invalid
            creditCardLogo.image = UIImage(systemName: "creditcard")
            cardType = .invalid
        }
    }
    
    // Validity Checks
    
    func validPayPalEmail() -> Bool {
        do {
            let _ = try Email(paypalEmailText.text!)
            paypalEmail = paypalPasswordText.text!
            return true
        } catch {
            paypalEmail = nil
            return false
        }
    }
    
    func validPayPalPassword() -> Bool {
        do {
            let _ = try Password(paypalPasswordText.text!)
            paypalPassword = paypalPasswordText.text!
            return true
        } catch {
            paypalPassword = nil
            return false
        }
    }
    
    func validCardHolder() -> Bool {
        do {
            let _ = try CardHolder(cardHolderText.text!)
            cardHolder = cardHolderText.text!
            return true
        } catch {
            cardHolder = nil
            return false
        }
    }
    
    func validCVV() -> Bool {
        guard cardType != nil, cardType != CreditCardType.invalid else { return false }
        
        // set the number of digits for the CVV based on the card type
        var numOfDigits = 0
        switch cardType {
        case .amex:
            numOfDigits = CreditCardCVVDigitCount.amex.rawValue
        default:
            numOfDigits = CreditCardCVVDigitCount.other.rawValue
        }
        
        do {
            let _ = try CardCVV(cvvText.text!, numOfDigits: numOfDigits)
            cvv = cvvText.text!
            return true
        } catch {
            cvv = nil
            return false
        }
    }
    
    func validCardNumber() -> Bool {
        guard cardType != nil, cardType != CreditCardType.invalid else { return false }
        
        // set the number of digits for the CVV based on the card type
        var numOfDigits = 0
        switch cardType {
        case .amex:
            numOfDigits = CreditCardDigitCount.amex.rawValue
        default:
            numOfDigits = CreditCardDigitCount.other.rawValue
        }
        // return true if we're already showing a masked card number since this
        // confirms the number was already valid
        if cardNumberText.text!.first == "*" {
            return true
        } else {
            // validate the card number in the textfield
            do {
                let _ = try CardNumber(cardNumberText.text!, numOfDigits: numOfDigits)
                cardNumber = cardNumberText.text!
                return true
            } catch {
                cardNumber = nil
                return false
            }
        }
    }
    
    func validCardValidUntil() -> Bool {
        do {
            let _ = try CardValidUntil(validUntilText.text!)
            validUntil = validUntilText.text!
            return true
        } catch {
            validUntil = nil
            return false
        }
    }
    
    func maskCardNumber(_ cardNum: String) -> String {
        var tempCardNum = cardNum
        var maskedCardNum = ""
        for i in 0..<cardNum.count {
            if i < cardNum.count - 4 {
                maskedCardNum.append("*")
                tempCardNum = String(tempCardNum.dropFirst())
            } else {
                maskedCardNum.append(tempCardNum.first!)
                tempCardNum = String(tempCardNum.dropFirst())
            }
        }
        return maskedCardNum
    }
    
    
    //MARK: - IBAction Methods
    
    @IBAction func paymentMethodChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedPaymentMethod = .payPal
            updatePaymentMethodView()
        } else {
            selectedPaymentMethod = .creditCard
            updatePaymentMethodView()
        }
    }
    
    @IBAction func saveCardDataValueChanged(_ sender: UISwitch) {
        saveCardData = sender.isOn
    }
    
    @IBAction func proceedButtonTapped(_ sender: UIButton) {
            
            print("selectedPaymentMethod: \(selectedPaymentMethod)")
            
            if selectedPaymentMethod == .payPal {
                print("paypalEmail: \(paypalEmail!)")
                print("paypalPassword: \(paypalPassword!)")
            } else {
                print("cardNumber: \(cardNumber!)")
                print("validUntil: \(validUntil!)")
                print("cvv: \(cvv!)")
                print("cardHolder: \(cardHolder!)")
                print("saveCardData: \(saveCardData)")
                print("maskedCardNumber:\(maskedCardNumber!)")
            }
        }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case datePickerIndexPath:
            if isEditingValidUntilDate == true {
                return validUntilMonthYearPicker.frame.height
            } else {
                return 0
            }
        case paypalEmailIndexPath:
            return determineRowHeight(for: .payPal)
        case paypalPasswordIndexPath:
            return determineRowHeight(for: .payPal)
        case creditcardNumberIndexPath:
            return determineRowHeight(for: .creditCard)
        case validUntilAndCVVLabelIndexPath:
            return determineRowHeight(for: .creditCard)
        case validUntilAndCVVIndexPath:
            return determineRowHeight(for: .creditCard)
        case cardHolderIndexPath:
            return determineRowHeight(for: .creditCard)
        case cardHolderLabelIndexPath:
            return determineRowHeight(for: .creditCard)
        case saveCardDataIndexPath:
            return determineRowHeight(for: .creditCard)
        default:
            return UITableView.automaticDimension
        }
    }
    
    func determineRowHeight(for method: PaymentMethod) -> CGFloat {
        if selectedPaymentMethod == method {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath == validUntilAndCVVIndexPath {
//            isEditingValidUntilDate = !isEditingValidUntilDate
//        }
//    }
    
    
    //MARK: - TextField Delegate Methods
    
        func textFieldDidBeginEditing(_ textField: UITextField) {
            switch textField {
            case validUntilText:
                isEditingValidUntilDate = true
            case cardNumberText:
                // put the unmasked card number back into the textfield
                if cardNumber != nil && cardNumberText.text!.isEmpty {
                    cardNumberText.text = cardNumber
                } else if cardNumber != nil {
                    cardNumberText.text = cardNumber
                }
            default:
                return
            }
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch selectedPaymentMethod {
        // perform checks on PayPal fields
        case .payPal:
            switch textField {
            case paypalEmailText:
                if !validPayPalEmail() {
                    // show a red border
                    textField.layer.borderWidth = 2.0
                    textField.layer.borderColor = UIColor.red.cgColor
                    // show the error label
                    invalidPayPalEmailLabel.isHidden = false
                } else {
                    // hide the border
                    textField.layer.borderWidth = 0.0
                    // hide the error label
                    invalidPayPalEmailLabel.isHidden = true
                }
                
            case paypalPasswordText:
                if !validPayPalPassword() {
                    // show a red border
                    textField.layer.borderWidth = 2.0
                    textField.layer.borderColor = UIColor.red.cgColor
                    // show the error label
                    missingPayPalPasswordLabel.isHidden = false
                } else {
                    // hide the border
                    textField.layer.borderWidth = 0.0
                    // hide the error label
                    missingPayPalPasswordLabel.isHidden = true
                }
            default:
                return
            }
            
        // perform checks on CreditCard fields
        case .creditCard:
            switch textField {
            case cardNumberText:
                updatePaymentLogoAndSetType()
                if cardType == CreditCardType.invalid || !validCardNumber() {
                    // show a red border
                    textField.layer.borderWidth = 2.0
                    textField.layer.borderColor = UIColor.red.cgColor
                    // show the error label
                    invalidCardNumberLabel.isHidden = false
                } else {
                    // hide the border
                    textField.layer.borderWidth = 0.0
                    // replace the card number in the textfield with the masked card number
                    cardNumberText.text = maskedCardNumber!
                    // hide the error label
                    invalidCardNumberLabel.isHidden = true
                }
                
            case validUntilText:
                if !validCardValidUntil() {
                    // show a red border
                    textField.layer.borderWidth = 2.0
                    textField.layer.borderColor = UIColor.red.cgColor
                    // show the error label
                    invalidValidityDateLabel.isHidden = false
                } else {
                    // hide the border
                    textField.layer.borderWidth = 0.0
                    // hide the error label
                    invalidValidityDateLabel.isHidden = true
                    // hide the date picker
                    isEditingValidUntilDate = false
                }
                
            case cvvText:
                if !validCVV() {
                    // show a red border
                    textField.layer.borderWidth = 2.0
                    textField.layer.borderColor = UIColor.red.cgColor
                    // show the error label
                    invalidCVVNumberLabel.isHidden = false
                } else {
                    // hide the border
                    textField.layer.borderWidth = 0.0
                    // hide the error label
                    invalidCVVNumberLabel.isHidden = true
                }
                
            case cardHolderText:
                if !validCardHolder() {
                    // show a red border
                    textField.layer.borderWidth = 2.0
                    textField.layer.borderColor = UIColor.red.cgColor
                    // show the error label
                    invalidCardHolderLabel.isHidden = false
                } else {
                    // hide the border
                    textField.layer.borderWidth = 0.0
                    // hide the error label
                    invalidCardHolderLabel.isHidden = true
                }
                
            default:
                return
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        switch textField {
        case cardNumberText:
            return allowOnlyDigits(string: string)
        case cvvText:
            return allowOnlyDigits(string: string)
        case cardHolderText:
            return allowOnlyLettersAndSpaces(string: string)
        default:
            return true
        }
    }
    
    
    private func allowOnlyDigits(string: String) -> Bool {
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
            // If incoming character is a decimalDigit, return true
            return true
        } else {
            // If a letter is detected, return false
            return false
        }
    }
    
    private func allowOnlyLettersAndSpaces(string: String) -> Bool {
        if CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: string)) || CharacterSet.whitespaces.isSuperset(of: CharacterSet(charactersIn: string)) {
            // If incoming character is a letter or space, return true
            return true
        } else {
            //if not letter or space, return false
            return false
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
