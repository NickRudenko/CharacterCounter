//
//  LoginPresenterTest.swift
//  JatApp CounterTests
//
//  Created by Mykola Rudenko on 23.01.2021.
//

import XCTest
@testable import JatApp_Counter

class MockLoginView: LoginViewProtocol {
    func showLoginResult(alert: UIAlertController?) {
    }
}

class MockNetworkService: NetworkServiceProtocol {
    
    var text: SandboxText!
    
    init() {}
    
    convenience init(text: SandboxText) {
        self.init()
        self.text = text
    }
    
    func getText(comletion: @escaping (Result<SandboxText?, Error>) -> Void) {
        
        if let text = text {
            comletion(.success(text))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            comletion(.failure(error))
        }
    }
    
    func authRequest(name: String, password: String, email: String, action: AuthAction, completion: @escaping (Result<Bool, Error>) -> Void) {
        switch action {
        case .login:
            if password.isEmpty || email.isEmpty {
                let error = NSError(domain: "", code: 0, userInfo: nil)
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
            
        case .signup:
            if name.isEmpty || password.isEmpty || email.isEmpty {
                let error = NSError(domain: "", code: 0, userInfo: nil)
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
            
        case .logout:
            completion(.success(true))
        }
    }
    
}

class LoginPresenterTest: XCTestCase {
    
    var view: MockLoginView!
    var presenter: LoginViewPresenterProtocol!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
        

    override func setUpWithError() throws {
        let nc = UINavigationController()
        let assembly = AssemblyModuleBuilder()
        router = Router(navigationController: nc, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        view = nil
        networkService = nil
        presenter = nil
    }


    func testCheckNotEmptyData() {
        view = MockLoginView()
        networkService = MockNetworkService()
        presenter = LoginPresenter(view: view, networkService: networkService, router: router)
        
        //all data
        var isHaveFinalSuccessIfNotEmpty: Bool?
        networkService.authRequest(name: "foo", password: "123qwe", email: "fee", action: .login) { (result) in
            switch result {
            case .success(let isSuccess):
                isHaveFinalSuccessIfNotEmpty = isSuccess
                
            case .failure(_ ):
                isHaveFinalSuccessIfNotEmpty = false
            }
            
        XCTAssertTrue(isHaveFinalSuccessIfNotEmpty ?? false)
        }
        
        //no name
        var isSuccessIfNoName: Bool?
        networkService.authRequest(name: "", password: "123qwe", email: "fee", action: .login) { (result) in
            switch result {
            case .success(let isSuccess):
                isSuccessIfNoName = isSuccess
                
            case .failure(_ ):
                isSuccessIfNoName = false
            }
            
        XCTAssertTrue(isSuccessIfNoName ?? false)
        }
        
        //no password
        var isSuccessIfNoPassword: Bool?
        networkService.authRequest(name: "foo", password: "", email: "fee", action: .login) { (result) in
            switch result {
            case .success(let isSuccess):
                isSuccessIfNoPassword = isSuccess
                
            case .failure(_ ):
                isSuccessIfNoPassword = false
            }
            
        XCTAssertFalse(isSuccessIfNoPassword ?? true)
        }
        
        //no email
        var isSuccessIfNoEmail: Bool?
        networkService.authRequest(name: "foo", password: "123", email: "", action: .login) { (result) in
            switch result {
            case .success(let isSuccess):
                isSuccessIfNoEmail = isSuccess
                
            case .failure(_ ):
                isSuccessIfNoEmail = false
            }
            
            XCTAssertFalse(isSuccessIfNoEmail ?? true)
        }
        
    }
    
    
    

}
