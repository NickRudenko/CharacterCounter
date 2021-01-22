//
//  ViewController.swift
//  JatApp Counter
//
//  Created by Mykola Rudenko on 20.01.2021.
//

import UIKit

class LoginVC: UIViewController {
    
    //user info text field
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    var presenter: LoginViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func login() {
        spiner.isHidden = false
        presenter.login(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        login()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        presenter.goToSignUp()
    }
}

 
extension LoginVC: LoginViewProtocol {
    
    func showLoginResult(alert: UIAlertController?) {
        spiner.isHidden = true
        
        if let errorAlert = alert {
            present(errorAlert, animated: true, completion: nil)
        } else {
            presenter.switchRoot()
        }
    }
    
    func showLoginResult(success: Bool) {
        print("show login result from vc")
    }
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTextField.becomeFirstResponder()
            
        case 1:
            view.endEditing(true)
            login()
            
        default:
            return false
        }
        
        return false
    }
}
