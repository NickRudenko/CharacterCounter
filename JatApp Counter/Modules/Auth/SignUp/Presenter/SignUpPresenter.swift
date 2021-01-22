//
//  SignUpPresenter.swift
//  JatApp Counter
//
//  Created by Mykola Rudenko on 22.01.2021.
//

import Foundation
import UIKit

protocol SignUpViewProtocol: class {
    func showSignUpResult(alert: UIAlertController?)
}

protocol SignUpViewPresenterProtocol: class {
    init(view: SignUpViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func createAccount(name: String?, email: String?, password: String?)
    func switchRoot()
}

class SignUpPresenter: SignUpViewPresenterProtocol {
    weak var view: SignUpViewProtocol?
    let router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    
    
    required init(view: SignUpViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func createAccount(name: String?, email: String?, password: String?) {
        if name != nil && email != nil && password != nil {
            networkService.authRequest(name: name!, password: password!, email: email!, action: .signup) { (result) in
                DispatchQueue.main.async {
                    var isSuccess: Bool
                    
                    switch result {
                    case .success(let isAuthorized):
                        isSuccess = isAuthorized
                        
                    case .failure(let error):
                        print("error signUp: \(error.localizedDescription)")
                        isSuccess = false
                    }
                    
                    self.view?.showSignUpResult(alert: isSuccess ? nil : self.createErrorAlert())
                }
            }
        } else {
            view?.showSignUpResult(alert: self.createErrorAlert())
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
    
    func switchRoot() {
        router?.switchRoot(for: true)
    }
    
}
