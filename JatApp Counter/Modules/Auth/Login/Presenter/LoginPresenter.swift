//
//  LoginPresenter.swift
//  JatApp Counter
//
//  Created by Mykola Rudenko on 21.01.2021.
//

import Foundation
import UIKit

protocol LoginViewProtocol: class {
    func showLoginResult(alert: UIAlertController?)
}

protocol LoginViewPresenterProtocol: class {
    init(view: LoginViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func login(email: String?, password: String?)
    func goToSignUp()
    func switchRoot()
}

class LoginPresenter: LoginViewPresenterProtocol {
    
    weak var view: LoginViewProtocol?
    let router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    
    required init(view: LoginViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func login(email: String?, password: String?) {
        
        //check password
        guard let enteredPassword = password, !enteredPassword.isEmpty else {
            view?.showLoginResult(alert: createErrorAlert())
            return
        }
        
        //check email
        guard let enteredEmail = email, !enteredEmail.isEmpty else {
            view?.showLoginResult(alert: createErrorAlert())
            return
        }
        
        networkService.authRequest(name: "", password: enteredPassword, email: enteredEmail, action: .login) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let isAuthorized):
                    if isAuthorized {
                        self.view?.showLoginResult(alert: nil)
                    } else {
                        self.view?.showLoginResult(alert: self.createErrorAlert())
                    }
                    
                    
                case .failure(let error):
                    print("login erorr: \(error.localizedDescription)")
                    self.view?.showLoginResult(alert: self.createErrorAlert())
                }
            }
        }
    }
    
    func createErrorAlert() -> UIAlertController {
        // Create new Alert
        let alert = UIAlertController(title: "Ooops!", message: "Something went wrong!", preferredStyle: .alert)
         
         // Create OK button with action handler
         let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             print("Ok button tapped")
          })
         
         //Add OK button to a dialog message
         alert.addAction(ok)
         
        return alert
    }
    
    func goToSignUp() {
        router?.goToSignUp()
    }
    
    func switchRoot() {
        router?.switchRoot(for: true)
    }
    
}
