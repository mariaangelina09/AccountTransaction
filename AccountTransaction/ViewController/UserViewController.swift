//
//  UserViewController.swift
//  AccountTransaction
//
//  Created by Maria Angelina on 18/01/22.
//

import UIKit

class UserViewController: UIViewController {
    // MARK: - @IBOutlet(s)
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var accountNoLabel: UILabel!
    @IBOutlet weak var accountHolderLabel: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!
    
    // MARK: - Variable(s)
    var user: User? {
        didSet {
            guard let user = user else { return }
            
            requestData(token: user.token ?? "")
        }
    }
    
    var transactionsDict: [String?: [Transaction]] = [:]
    var transactions: [Transaction] = []
    var payees: [Payee] = []
    
    // MARK: - Override Function(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupTableView()
    }
    
    // MARK: - Function(s)
    func setupData() {
        guard let user = user else { return }
        
        accountNoLabel.text = user.accountNo
        accountHolderLabel.text = user.username
    }
    
    func setupTableView() {
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.register(TransactionTableViewCell.self)
        transactionTableView.register(TransactionHeaderTableViewCell.self)
    }
    
    func requestData(token: String) {
        requestBalance(token: token)
        requestTransactions(token: token)
        requestPayees(token: token)
    }
    
    func requestBalance(token: String) {
        Service.request(httpMethod: .get, pathUrl: Constant.Path.balance, token: token, success: { json in
            guard let balanceData = json.decode(mapper: Balance.self) else { return }
            
            let balanceString = balanceData.balance.currencySG
            self.creditLabel.text = balanceString
        }, failure: { error in
            Toast.shared.showMessage(error.description, title: "Error", duration: 2, type: .error)
        })
    }
    
    func requestTransactions(token: String) {
        Service.request(httpMethod: .get, pathUrl: Constant.Path.transactions, token: token, success: { json in
            guard let transactionsData = json["data"].decode(mapper: [Transaction].self) else { return }
            
            self.transactions = []
            for transaction in transactionsData {
                self.transactions.append(Transaction(
                    sender: transaction.sender,
                    amount: transaction.amount,
                    transactionDate: transaction.transactionDate?.convertDateFormat(),
                    description: transaction.description,
                    transactionType: transaction.transactionType,
                    transactionId: transaction.transactionId))
            }
            
            self.updateTransaction()
        }, failure: { error in
            Toast.shared.showMessage(error.description, title: "Error", duration: 2, type: .error)
        })
    }
    
    func requestPayees(token: String) {
        Service.request(httpMethod: .get, pathUrl: Constant.Path.payees, token: token, success: { json in
            guard let payeesData = json["data"].decode(mapper: [Payee].self) else { return }
            self.payees = payeesData
        }, failure: { error in
            Toast.shared.showMessage(error.description, title: "Error", duration: 2, type: .error)
        })
    }
    
    func updateTransaction() {
        guard !transactions.isEmpty else { return }
        
        transactionsDict = Dictionary(grouping: transactions, by: { $0.transactionDate })
        transactionTableView.reloadData()
    }
    
    func goToTransferScreen() {
        let transferVC = TransferViewController()
        transferVC.payees = payees
        transferVC.token = user?.token ?? ""
        navigationController?.pushViewController(transferVC, animated: true)
    }
    
    // MARK: - @IBAction(s)
    @IBAction func transferButtonTapped(_ sender: Any) {
        goToTransferScreen()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(transactionsDict)[section].key
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHeaderTableViewCell") as! TransactionHeaderTableViewCell
        cell.setupData(date: Array(transactionsDict)[section].key ?? "")
        return cell
    }
}

// MARK: - UITableViewDataSource
extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(transactionsDict)[section].value.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TransactionTableViewCell
        cell.setupData(transaction: Array(transactionsDict)[indexPath.section].value[indexPath.row])
        return cell
    }
}
