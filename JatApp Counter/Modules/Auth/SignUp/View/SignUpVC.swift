//
//  SignUpVC.swift
//  JatApp Counter
//
//  Created by Mykola Rudenko on 22.01.2021.
//

import UIKit

class SignUpVC: UIViewController {
    
    //user in
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    var presenter: SignUpViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func createTapped(_ sender: Any) {
        createAccount()
    }
    
    func createAccount() {
        spiner.isHidden = false
            self.presenter.createAccount(name: self.nameTextField.text, email: self.emailTextField.text, password: self.passwordTextField.text)
    }
}

extension SignUpVC: SignUpViewProtocol {
    
    func showSignUpResult(alert: UIAlertController?) {
            self.spiner.isHidden = true
            if let alertToShow = alert {
                self.present(alertToShow, animated: true, completion: nil)
            } else {
                self.presenter.switchRoot()
            }
    }
    
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            emailTextField.becomeFirstResponder()
            
        case 1:
            passwordTextField.becomeFirstResponder()
            
        case 2:
            view.endEditing(true)
            createAccount()
            
        default:
            return false
        }
        
        return false
    }
}
