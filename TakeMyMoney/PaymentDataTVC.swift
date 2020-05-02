//
//  PaymentDataTableViewController.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 4/30/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit

enum RowAction: Int {
    case hide = 0
    case show = 44
}

class PaymentDataTVC: UITableViewController {
    
    //MARK: - Properties
    
    var isEditingValidUntilDate: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    
    
    
    
    var selectedPaymentMethod: PaymentMethod = .payPal {
        didSet {
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
    var cardNumber: String?
    var validUntil: String?
    var cvv: String?
    var cardHolder: String?
    var saveCardData: Bool = false
    
    
    //MARK: - IBOutlets
    
    // General
    @IBOutlet weak var paymentMethodControl: UISegmentedControl!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    
    // PayPal
    @IBOutlet weak var paypalEmailText: UITextField!
    @IBOutlet weak var paypalPasswordText: UITextField!
    
    // Credit Card
    
    @IBOutlet weak var creditCardNumberText: UITextField!
    @IBOutlet weak var validUntilLabel: UILabel!
    @IBOutlet weak var validUntilDatePicker: UIDatePicker!
    @IBOutlet weak var cvvText: UITextField!
    @IBOutlet weak var cardHolderText: UITextField!
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the PaymentMethodControl Appearance
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        paymentMethodControl.setTitleTextAttributes(attributes, for: .selected)
        paymentMethodControl.setTitleTextAttributes(attributes, for: .normal)
        
        paymentTypeLabel.text = selectedPaymentMethod.rawValue
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updatePaymentMethodView() {
        
        switch selectedPaymentMethod {
        case .payPal:
            paymentTypeLabel.text = selectedPaymentMethod.rawValue
            
        case .creditCard:
            paymentTypeLabel.text = selectedPaymentMethod.rawValue
            
        }
    }
    
    func validEntries(for method: PaymentMethod) -> Bool {
        
        switch method {
        case .payPal:
            if let email = paypalEmailText.text, let password = paypalPasswordText.text {
                paypalEmail = email
                paypalPassword = password
                return true
            } else {
                return false
            }
        case .creditCard:
            if let cardNumber = creditCardNumberText.text, let validUntil = validUntilLabel.text, let cvv = cvvText.text, let cardHolder = cardHolderText.text {
                self.cardNumber = cardNumber
                self.validUntil = validUntil
                self.cvv = cvv
                self.cardHolder = cardHolder
                return true
            } else {
                return false
            }
        }
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
        guard validEntries(for: selectedPaymentMethod) else { return }
        
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
        }
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case datePickerIndexPath:
            if isEditingValidUntilDate == true {
                return validUntilDatePicker.frame.height
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == validUntilAndCVVIndexPath {
            isEditingValidUntilDate = !isEditingValidUntilDate
        }
    }
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
