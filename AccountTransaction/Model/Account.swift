//
//  Account.swift
//  AccountTransaction
//
//  Created by Maria Angelina on 18/01/22.
//

import Foundation

enum TransactionType: String {
    case received = "received"
    case transferred = "transferred"
}

struct User: Codable {
    let username, accountNo, status, token: String?
}

struct Balance: Codable {
    let balance: Double
    let accountNo, status: String?
}

struct Transaction: Codable {
    let sender: TransactionSender
    let amount: Double
    let transactionDate, description, transactionType, transactionId: String?
}

struct TransactionSender: Codable {
    let accountNo, accountHolder : String?
}

struct Payee: Codable {
    let id, accountNo, name: String?
}
