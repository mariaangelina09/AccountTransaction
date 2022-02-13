//
//  TransactionHeaderTableViewCell.swift
//  AccountTransaction
//
//  Created by Maria Angelina on 19/01/22.
//

import UIKit

class TransactionHeaderTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    // MARK: - @IBOutlet(s)
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Override Function(s)
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Function(s)
    func setupData(date: String) {
        dateLabel.text = date
    }
}
