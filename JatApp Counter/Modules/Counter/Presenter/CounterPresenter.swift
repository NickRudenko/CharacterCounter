//
//  CounterPresenter.swift
//  JatApp Counter
//
//  Created by Mykola Rudenko on 22.01.2021.
//

import Foundation
import UIKit

protocol CounterViewProtocol: class {
    
    func showText(sandboxText: SandboxText)
    func showLoadError(alert: UIAlertController)
}

protocol CounterViewPresenterProtocol {
    init(view: CounterViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    var countsArr: [Dictionary<Character, UInt>.Element] { get set }
    func loadText()
    func logout()
}

class CounterPresenter: CounterViewPresenterProtocol {
    
    weak var view: CounterViewProtocol?
    let router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    
    var countsArr: [Dictionary<Character, UInt>.Element]
    
    required init(view: CounterViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        countsArr = []
    }
    
    func loadText() {
        networkService.getText { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let text):
                    if text != nil {
                        self.countCharacters(inputText: text?.data ?? "")
                        self.view?.showText(sandboxText: text!)
                    } else {
                        self.view?.showLoadError(alert: self.createErrorAlert())
                    }
                    
                case .failure(let error):
                    print("get tet error: \(error.localizedDescription)")
                    self.view?.showLoadError(alert: self.createErrorAlert())
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
    
    func logout() {
        networkService.authRequest(name: "", password: "", email: "", action: .logout) { (result) in
            DispatchQueue.main.async {

            switch result {
            case .success(let isLogedOut):
                if isLogedOut {
                    self.router?.switchRoot(for: false)
                }
                
            case .failure(let error):
                print("logout error: \(error.localizedDescription)")
            }
            }
        }
    }
    
    func countCharacters(inputText: String) {
        var newCounts: [Character : UInt] = [:]
        inputText.forEach {
            if newCounts[$0] == nil {
                newCounts[$0] = 1
            } else {
                newCounts[$0]! += 1
            }
        }
        countsArr = Array(newCounts).sorted(by: {return $0.value > $1.value })
    }
    
}
