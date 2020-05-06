//
//  PaymentConfirmationTVC.swift
//  TakeMyMoney
//
//  Created by Jody Abney on 5/1/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit

class PaymentConfirmationTVC: UITableViewController {

    //MARK: - Properties
    
    var selectedPaymentMethod: PaymentMethod?
    var paypalInfo: PayPal?
    var creditCardInfo: CreditCard?
    var promoCode: String?

    //MARK: - IBOutlets
    @IBOutlet weak var viewForImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var paymentInfoView: UIView!
    @IBOutlet weak var paymentLogo: UIImageView!
    @IBOutlet weak var paymentHolderLabel: UILabel!
    @IBOutlet weak var paymentAccountLabel: UILabel!
    @IBOutlet weak var promoCodeText: UITextField!
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
        
        imageView.layer.cornerRadius = 10
        paymentInfoView.layer.cornerRadius = 10
        
        updateView()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    //MARK: - Instance Methods
    
    func updateView() {
        guard let selectedPaymentMethod = selectedPaymentMethod else {
            return
        }
        
        switch selectedPaymentMethod {
        case .payPal:
            guard let paypalInfo = paypalInfo else {
                return }
            paymentLogo.image = UIImage(named: "icons8-paypal-144.png")
            paymentHolderLabel.text = paypalInfo.email
            paymentAccountLabel.text = nil
        case .creditCard:
            guard let card = creditCardInfo else {
                return }
            paymentLogo.image = UIImage(named: card.logo)
            paymentHolderLabel.text = card.holder
            paymentAccountLabel.text = card.maskedNumber
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    
    //MARK: - IBActions
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController()
        alert.title = "Purchase Not Completed"
        alert.message = "Your payment has failed."
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    
}
