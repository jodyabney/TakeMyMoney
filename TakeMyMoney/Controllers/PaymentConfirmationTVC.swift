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
    
    var promoCode: String?
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewForImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var paymentInfoView: UIView!
    @IBOutlet weak var paymentLogo: UIImageView!
    @IBOutlet weak var cardHolderLabel: UILabel!
    @IBOutlet weak var paymentInfoLabel: UILabel!
    @IBOutlet weak var promoCodeText: UITextField!
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 10
        paymentInfoView.layer.cornerRadius = 10
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    //MARK: - IBActions
    
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        
        let alert = UIAlertController()
        alert.title = "Problem with payment"
        alert.message = "Your payment has failed."
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source



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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
