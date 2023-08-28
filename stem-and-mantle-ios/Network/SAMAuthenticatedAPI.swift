//
//  SAMAuthenticatedAPI.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

class SAMAuthenticatedAPI {
    static let authenticationExpiredNotification = NSNotification.Name(rawValue:"authenticationExpiredNotification")
    
    let userData: UserAccountAccessData
    init(userData: UserAccountAccessData) {
        self.userData = userData
    }
    
    private var refreshingAuthInProgress = false
    private func checkForAndHandleAuthError(_ maybeAuthError: Error?) {
        guard !refreshingAuthInProgress else {
            return
        }
        
        if let networkError = maybeAuthError as? NetworkError,
           case .httpStatusCodeError(let statusCode, _) = networkError,
           statusCode == 401
        {
            // TODO: Refresh token stuff goes here.
            PantryLog.log("We are logging user out because of an auth error.")
            NotificationCenter.default.post(name:  SAMAuthenticatedAPI.authenticationExpiredNotification, object: nil)
        }
    }
    
    func getUserData(completion: @escaping( (Result<UserInfo, Error>) -> Void )) {
        let urlString = self.userData.host.rawValue + "api/users/me"
        let headers = ["Authorization": "Bearer " +  self.userData.tokenData.accessToken]
        Network.getJsonObject(UserInfo.self, urlString, headers) { (userInfo, httpResponse, error) in
            self.checkForAndHandleAuthError(error)
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let userInfo = userInfo {
                completion(Result.success(userInfo))
            } else {
                completion(.failure(PantryError.nilResponseAndNoError))
            }
        }
    }
}
