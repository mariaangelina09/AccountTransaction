//
//  TransferViewController.swift
//  AccountTransaction
//
//  Created by Maria Angelina on 19/01/22.
//

import Alamofire
import DropDown
import UIKit

class TransferViewController: UIViewController {
    // MARK: - @IBOutlet(s)
    @IBOutlet weak var payeeTextField: UITextField!
    @IBOutlet weak var payeeBottomAnchorView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Variable(s)
    private let dropDown = DropDown()
    private var payeeDataSource = [String]()
    private var selectedPayee: Int = 0
    
    var token: String = ""
    
    var payees: [Payee] = [] {
        didSet {
            payeeDataSource.removeAll()
            payeeDataSource = payees.map { $0.name ?? "" }
        }
    }
    
    // MARK: - Override Function(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
    }
    
    func setupData() {
        guard !payeeDataSource.isEmpty else { return }
        
        payeeTextField.text = payeeDataSource[selectedPayee]
    }
    
    // MARK: - Function(s)
    private func requestTransfer(amount: Int, description: String) {
        guard !token.isEmpty else {
            Toast.shared.showMessage("Token Invalid", title: "Error", duration: 2, type: .error)
            return
        }
        
        let parameters: Parameters = [
            "receipientAccountNo": payees[selectedPayee].accountNo,
            "amount": amount,
            "description": description
        ]
        
        Service.request(httpMethod: .post, pathUrl: Constant.Path.transfer, parameters: parameters, token: token, success: { json in
            print(json)
        }, failure: { error in
            Toast.shared.showMessage(error.description, title: "Error", duration: 2, type: .error)
        })
    }
    
    // MARK: - @IBAction(s)
    @IBAction func selectPayeeButtonTapped(_ sender: Any) {
        dropDown.backgroundColor = .white
        dropDown.anchorView = payeeBottomAnchorView
        dropDown.dataSource = payeeDataSource
        dropDown.textColor = .black
        dropDown.selectedTextColor = .white
        dropDown.selectionBackgroundColor = .gray
        dropDown.backgroundColor = .white
        dropDown.selectRow(selectedPayee)
        
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.selectedPayee = index
            self?.payeeTextField.text = item
        }
        
        dropDown.show()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func transferButtonTapped(_ sender: Any) {
        guard let amount = amountTextField.text, !(amount.isEmpty), let amountValue = Int(amount) else {
            Toast.shared.showMessage("Amount should be numberic and can't be empty!", title: "Error", duration: 2, type: .error)
            return
        }
        
        requestTransfer(amount: amountValue, description: descriptionTextView.text ?? "")
    }
}
