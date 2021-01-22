//
//  SandboxText.swift
//  JatApp Counter
//
//  Created by Mykola Rudenko on 20.01.2021.
//

import Foundation

struct SandboxText: Codable {
    let success: Bool
    let data: String?
    let errors: [SandboxError]?
}

struct SandboxError: Codable {
    let field: String
    let name: String
    let message: String
    let code: Int
    let status: Int
}


//MARK: - SandboxText JSON Example

 // JSON example with status code 200
 /*
{
  "success": true,
  "data": "string"
}
 */


 // JSON example with status code 401
 /*
 {
   "success": false,
   "data": {},
   "errors": [
     {
       "name": "Unauthorized",
       "message": "Your request was made with invalid credentials.",
       "code": 0,
       "status": 401
     }
   ]
 }
 */

