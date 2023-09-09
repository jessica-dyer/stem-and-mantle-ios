//
//  SAMApp.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation
import SwiftUI

class SAMApp: ObservableObject {
    let api: SAMUnauthenticatedAPI
    @Published var user: User? {
        didSet {
            if let user = self.user {
                PantryLog.log("Signed in for user: \(user.accountAccessData.userName)")
                saveUserAccessData()
            } else {
                PantryLog.log("User has signed out.")
                SAMPersistentStore.eraseAllUserData()
            }
        }
    }
    
    init() {
        self.api = SAMUnauthenticatedAPI(host: .local)
        
        NotificationCenter.default.addObserver(forName: SAMAuthenticatedAPI.authenticationExpiredNotification, object: nil, queue: .main) {(_) in
            self.signOut()
        }
        
        NotificationCenter.default.addObserver(forName: SAMAuthenticatedAPI.authenticationTokenUpdatedNotification, object: nil, queue: .main) {(notification) in
            if let tokenData = notification.userInfo?["tokenObject"] as? SAMTokenData {
                if self.user != nil {
                    self.user!.accountAccessData.tokenData = tokenData
                    self.user!.api.userData.tokenData = tokenData
                }
            }
        }
    }
    
    func signInFor(_ user: User) {
        DispatchQueue.main.async {
            self.user = user
        }
    }
    
    func signOut() {
        self.user = nil
    }
    
    func saveUserAccessData() {
        if let user = self.user {
            SAMPersistentStore.forUserAccountAccess.save(user.accountAccessData)
        }
    }
    
    func loadSavedUserIfExists() {
        if let savedAccount =
            SAMPersistentStore.forUserAccountAccess.load() {
            PantryLog.log("Saved user data exists for \(savedAccount.userName), loading that now")
            if self.api.host == savedAccount.host {
                let user = User(userData: savedAccount)
                user.loadSavedData()
                self.user = user
            } else {
                PantryLog.log("Auto logging out. Host changed.")
            }
            
        }
    }
}
