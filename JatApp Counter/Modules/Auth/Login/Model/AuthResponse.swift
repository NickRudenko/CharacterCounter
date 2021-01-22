//
//  AuthResponse.swift
//  JatApp Counter
//
//  Created by Mykola Rudenko on 22.01.2021.
//

import Foundation

struct AuthResponse: Codable {
    let success: Bool
    let data: AuthResponseData?
    let errors: [AuthError]?
    
}

struct AuthResponseData: Codable {
    let uid: Int
    let name: String
    let email: String
    let access_token: String
}

struct AuthError: Codable, Error {
    let name: String
    let message: String
    let code: Int
    let status: Int
}

enum AuthAction {
    case login
    case logout
    case signup
}

//"errors": [
//    {
//      "name": "string",
//      "message": "string",
//      "code": 0,
//      "status": 0
//    }
//  ]

//{
//  "success": true,
//  "data": {
//    "uid": 0,
//    "name": "string",
//    "email": "string",
//    "access_token": "string",
//    "role": 1,
//    "status": 1,
//    "created_at": 0,
//    "updated_at": 0
//  }
//}
