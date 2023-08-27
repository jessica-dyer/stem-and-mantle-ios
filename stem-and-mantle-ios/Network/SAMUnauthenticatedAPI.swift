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
        let body = "grant_type=&username=jessica%40gmail.com&password=password&scope=&client_id=&client_secret="
        let data = body.data(using: .utf8)! //Never use an !
        Network.post(urlString, httpBody: data) { (data: Data?, response: HTTPURLResponse?, error: Error?) in
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
            }
            
            print("foo")
        }
    }
}

