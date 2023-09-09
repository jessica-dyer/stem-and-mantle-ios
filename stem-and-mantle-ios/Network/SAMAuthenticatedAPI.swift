//
//  SAMAuthenticatedAPI.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

class SAMAuthenticatedAPI {
    static let authenticationExpiredNotification = NSNotification.Name(rawValue:"authenticationExpiredNotification")
    
    static let authenticationTokenUpdatedNotification = NSNotification.Name(rawValue:"authenticationTokenUpdatedNotification")
    
    var userData: UserAccountAccessData
    init(userData: UserAccountAccessData) {
        self.userData = userData
    }
    
    private var refreshingAuthInProgress = false
    private func checkForAndHandleAuthError(_ maybeAuthError: Error?, doIfRetrying: @escaping( () -> Void )) {
        guard !refreshingAuthInProgress else {
            return
        }
        
        if let networkError = maybeAuthError as? NetworkError,
           case .httpStatusCodeError(let statusCode, _) = networkError,
           statusCode == 403
        {
            PantryLog.log("We have encountered an auth error, going to attempt to use the refresh token.")
            self.refreshAuthToken(refreshToken: self.userData.tokenData.refreshToken) { (result: Result<SAMTokenData, Error>) in
                switch result {
                case .success(let tokenData):
                    PantryLog.log("We have refreshed the auth credentials using the refresh token.")
                    NotificationCenter.default.post(name:  SAMAuthenticatedAPI.authenticationTokenUpdatedNotification, object: nil, userInfo: ["tokenObject": tokenData])
                    doIfRetrying()
                case .failure(let error):
                    PantryLog.log("Tried to use the refresh token, but received an error: " + getWhyString(forError: error))
                    PantryLog.log("We are logging user out because of an auth error.")
                    NotificationCenter.default.post(name:  SAMAuthenticatedAPI.authenticationExpiredNotification, object: nil)
                }
            }
            
        }
    }
    
    typealias RefreshTokenResponseHandler = (Result<SAMTokenData, Error>) -> Void
    
    // Even though this is in authenticated API, does not
    // need an auth token.
    func refreshAuthToken(refreshToken: String, completion: @escaping(RefreshTokenResponseHandler)) {
        
        let urlString = self.userData.host.rawValue + "api/refresh-auth?refresh_token=" + refreshToken
        
        Network.getJsonObject(SAMTokenData.self, urlString) { (tokenData, httpResponse, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let tokenData = tokenData {
                completion(Result.success(tokenData))
            } else {
                completion(.failure(PantryError.nilResponseAndNoError))
            }
        }
    }
    
    func getUserData(completion: @escaping( (Result<UserInfo, Error>) -> Void )) {
        let urlString = self.userData.host.rawValue + "api/users/me"
        let headers = ["Authorization": "Bearer " +  self.userData.tokenData.accessToken]
        Network.getJsonObject(UserInfo.self, urlString, headers) { (userInfo, httpResponse, error) in
            self.checkForAndHandleAuthError(error) {
                self.getUserData(completion: completion)
            }
            
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
    
    func getTrainingSessions(completion: @escaping( (Result<TrainingSessionListWrapper, Error>) -> Void )) {
        let urlString = self.userData.host.rawValue + "api/training-sessions"
        let headers = ["Authorization": "Bearer " +  self.userData.tokenData.accessToken]
        Network.getJsonObject(TrainingSessionListWrapper.self, urlString, headers) { (userInfo, httpResponse, error) in
            self.checkForAndHandleAuthError(error) {
                self.getTrainingSessions(completion: completion)
            }
            
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
