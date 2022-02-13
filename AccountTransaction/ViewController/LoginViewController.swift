//
//  LoginViewController.swift
//  AccountTransaction
//
//  Created by Maria Angelina on 18/01/22.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    // MARK: - @IBOutlet(s)
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Override Function(s)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Function(s)
    func requestLogin(username: String, password: String) {
        let parameters: Parameters = [
            "username": username,
            "password": password
        ]
        
        Service.request(httpMethod: .post, pathUrl: Constant.Path.login, parameters: parameters, success: { json in
            guard let userData = json.decode(mapper: User.self) else { return }
            self.goToUserScreen(user: userData)
        }, failure: { error in
            Toast.shared.showMessage(error.description, title: "Error", duration: 2, type: .error)
        })
    }
    
    func goToUserScreen(user: User) {
        let userVC = UserViewController()
        userVC.user = user
        navigationController?.pushViewController(userVC, animated: true)
    }
    
    func goToRegisterScreen() {
        let registerVC = RegisterViewController()
        registerVC.successRegisterClosure = {
            Toast.shared.showMessage("Register Success", title: "Success", duration: 2, type: .success)
        }
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    // MARK: - @IBAction(s)
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !(username.isEmpty), let password = passwordTextField.text, !(password.isEmpty) else {
            Toast.shared.showMessage("Username / Password can't be empty!", title: "Error", duration: 2, type: .error)
            return
        }
        
        requestLogin(username: username, password: password)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        goToRegisterScreen()
    }
}

