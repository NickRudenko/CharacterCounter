//
//  Router.swift
//  JatApp Counter
//
//  Created by Mykola Rudenko on 22.01.2021.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func goToSignUp()
    func popToRoot()
    func switchRoot(for authorized: Bool)
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            let isUserAuthorized = UserDefaults.standard.bool(forKey: "isAuthorized")
            var rootVC: UIViewController
            
            if isUserAuthorized {
                guard let loginViewController = assemblyBuilder?.createCounterModule(router: self) else { return }
                rootVC = loginViewController
            } else {
                guard let loginViewController = assemblyBuilder?.createLoginModule(router: self) else { return }
                rootVC = loginViewController
            }
           
            navigationController.viewControllers = [rootVC]
        }
    }
    
    func goToSignUp() {
        if let navigationController = navigationController {
            guard let signUpViewController = assemblyBuilder?.createSignUpModule(router: self) else { return }
            navigationController.pushViewController(signUpViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func switchRoot(for authorized: Bool) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let sceneDeleagte = scene?.delegate as? SceneDelegate else { return }

        var newInitController: UIViewController?
        if authorized {
            newInitController = assemblyBuilder?.createCounterModule(router: self)
        } else {
            newInitController = assemblyBuilder?.createLoginModule(router: self)
        }
        
        guard let newController = newInitController else {return}
        navigationController?.viewControllers = [newController]
    }
    
}
