//
//  SAMUnauthenticatedAPI.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

enum SAMAPIHost: String, Codable {
    case local = "http://127.0.0.1:8000/"
    case prod = "https://stem-and-mantle-090764c508e6.herokuapp.com/"
}

class SAMUnauthenticatedAPI {
    let host: SAMAPIHost
    
    init(host: SAMAPIHost) {
        self.host = host
    }
    
    typealias SignInCompletionHandler = ( _ result: Result<UserAccountAccessData, Error>) -> (Void)
    
    func signIn(username: String, password: String, completion: @escaping(SignInCompletionHandler)) {
        let urlString = self.host.rawValue + "login"
        let body = "grant_type=&username=\(username)&password=\(password)&scope=&client_id=&client_secret="
        guard let bodyUrlEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let data = bodyUrlEncoded.data(using: .utf8) else {
            completion(.failure(SAMError.dataEncodingFailed(message: "from SignIn"))
            )
            return
        }
        
        Network.callJsonEndpoint(httpMethod: .POST, urlString, httpBody: data, expectingResponseType: SAMTokenData.self) { (tokenData, rawData, httpResponse, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let tokenData = tokenData {
                let accessData = UserAccountAccessData(host: self.host, tokenData: tokenData, userName: username)
                completion(Result.success(accessData))
            } else {
                print("Weird, both tokenData & error are nil?")
                completion(.failure(PantryError.nilResponseAndNoError))
            }
        }
    }
}

