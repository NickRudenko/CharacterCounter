//
//  Builder.swift
//  JatApp Counter
//
//  Created by Mykola Rudenko on 21.01.2021.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createLoginModule(router: RouterProtocol) -> UIViewController
    func createSignUpModule(router: RouterProtocol) -> UIViewController
    func createCounterModule(router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func createLoginModule(router: RouterProtocol) -> UIViewController {
        let view = LoginVC()
        let networkService = NetworkService()
        let presenter = LoginPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createSignUpModule(router: RouterProtocol) -> UIViewController {
        let view = SignUpVC()
        let networkService = NetworkService()
        let presenter = SignUpPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createCounterModule(router: RouterProtocol) -> UIViewController {
        let view = CounterVC()
        let networkService = NetworkService()
        let presenter = CounterPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    
}
