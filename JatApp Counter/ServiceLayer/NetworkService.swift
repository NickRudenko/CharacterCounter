//
//  NetworkService.swift
//  JatApp Counter
//
//  Created by Mykola Rudenko on 20.01.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    //Sandbox
    func getText(comletion: @escaping (Result<SandboxText?, Error>) -> Void)
    
    //Auth
    func authRequest(name: String, password: String, email: String, action: AuthAction, completion: @escaping (Result<Bool, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    static var isAuthorised = false
    
    let apiUrl = "https://apiecho.cf/"
    
    enum requestSection: String {
        //Sandbox
        case getText = "api/get/text/"
        
        //Auth
        case login = "api/login/"
        case logout = "api/logout/"
        case signup = "api/signup/"
        
    }
    
    var headers: [String : String] {
        let accessToken = KeychainWrapper.standard.string(forKey: "token") ?? ""
        
        if accessToken.isEmpty {
            return [
                "Content-Type":"application/json",
            ]
        } else {
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type":"application/json",
            ]
        }
    }
    
    func authRequest(name: String, password: String, email: String, action: AuthAction, completion: @escaping (Result<Bool, Error>) -> Void) {

        
        let parameters: [String : String]?
        switch action {
        case .login:
            parameters = ["email" : email, "password" : password]

        case .logout:
            parameters = nil

        case .signup:
            parameters = ["name" : name, "email" : email, "password" : password]
            
        }
            
        var sectionString = ""
        switch action {
        case .login:
            sectionString = requestSection.login.rawValue
            
        case .logout:
            sectionString = requestSection.logout.rawValue
            
        case .signup:
            sectionString = requestSection.signup.rawValue
            
        }

        //create the url with NSURL
        guard let url = URL(string: apiUrl + sectionString) else {return}

        //create the session object
        let session = URLSession.shared

        //create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            print(error.localizedDescription)
            completion(.failure(error))
        }

        //HTTP Headers
        request.allHTTPHeaderFields = headers

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            


            guard error == nil else {
                completion(.failure(error!))
                return
            }

            if action == .logout {
                KeychainWrapper.standard.removeObject(forKey: "token")
                UserDefaults.standard.setValue(false, forKey: "isAuthorized")
                completion(.success(true))
            } else {
                guard let data = data else {
                    completion(.failure(error!))
                    return
                }

                do {
                    let authResp = try JSONDecoder().decode(AuthResponse.self, from: data)
                    
                    if let authData = authResp.data {
                        UserDefaults.standard.setValue(true, forKey: "isAuthorized")
                        KeychainWrapper.standard.set(authData.access_token, forKey: "token")
                        completion(.success(true))
                    } else {
                        if let errors = authResp.errors, !errors.isEmpty {
                            completion(.failure(errors[0]))
                        } else {
                            completion(.success(false))
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        })

        task.resume()
    }
    
    func getText(comletion: @escaping (Result<SandboxText?, Error>) -> Void) {

        //create the url with NSURL
        guard let url = URL(string: apiUrl + requestSection.getText.rawValue) else {return}

        //create the session object
        let session = URLSession.shared

        //create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //set http method as GET

        //HTTP Headers
        request.allHTTPHeaderFields = headers

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                comletion(.failure(error!))
                return
            }
            
            guard let data = data else {
                comletion(.success(nil))
                return
            }
            
            do {
                let obj = try JSONDecoder().decode(SandboxText.self, from: data)
                comletion(.success(obj))
                
            } catch let error {
                print(error.localizedDescription)
                comletion(.failure(error))
            }
            
        })

        task.resume()
    }
    
}

