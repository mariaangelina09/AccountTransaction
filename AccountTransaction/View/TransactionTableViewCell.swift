//
//  TransactionTableViewCell.swift
//  AccountTransaction
//
//  Created by Maria Angelina on 19/01/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    // MARK: - @IBOutlet(s)
    @IBOutlet weak var accountHolderLabel: UILabel!
    @IBOutlet weak var accountNoLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // MARK: - Override Function(s)
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Function(s)
    func setupData(transaction: Transaction) {
        accountHolderLabel.text = transaction.sender.accountHolder
        accountNoLabel.text = transaction.sender.accountNo
        
        amountLabel.text = transaction.transactionType == TransactionType.received.rawValue ? transaction.amount.currency : "- \(transaction.amount.currency)"
        amountLabel.textColor = transaction.transactionType == TransactionType.received.rawValue ? .darkGreen : .black
    }
}
