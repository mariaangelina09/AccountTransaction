//
//  RegisterViewController.swift
//  AccountTransaction
//
//  Created by Maria Angelina on 18/01/22.
//

import Alamofire
import UIKit

class RegisterViewController: UIViewController {
    // MARK: - @IBOutlet(s)
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // MARK: - Variable(s)
    var successRegisterClosure: (() -> Void)?
    
    // MARK: - Override Function(s)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Function(s)
    func requestRegister(username: String, password: String) {
        let parameters: Parameters = [
            "username": username,
            "password": password
        ]
        
        Service.request(httpMethod: .post, pathUrl: Constant.Path.register, parameters: parameters, success: { json in
            self.successRegisterClosure?()
            self.navigationController?.popViewController(animated: true)
        }, failure: { error in
            Toast.shared.showMessage(error.description, title: "Error", duration: 2, type: .error)
        })
    }
    
    // MARK: - @IBAction(s)
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !(usernameTextField.text?.isEmpty)!, let password = passwordTextField.text, !(passwordTextField.text?.isEmpty)! else {
            Toast.shared.showMessage("Username / Password can't be empty!", title: "Error", duration: 2, type: .error)
            return
        }
        
        guard passwordTextField.text == confirmPasswordTextField.text else {
            Toast.shared.showMessage("Password and Confirm Password must be matched!", title: "Error", duration: 2, type: .error)
            return
        }
        
        requestRegister(username: username, password: password)
    }
}
