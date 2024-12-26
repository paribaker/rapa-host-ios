//
//  SessionManager.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/1/24.
//

import SwiftUI

class SessionManager: ObservableObject {
    
    static let shared = SessionManager()
    
    private var userApi = UserApi()
    
    @Published var isLoggedIn: Bool {
        didSet {
            if isLoggedIn {
                UserDefaults.standard.set(token, forKey: "token")
            } else {
                UserDefaults.standard.removeObject(forKey: "token")
            }
        }
    }
    
    @Published var userAccount: UserShape? {
        didSet {
            if account != nil {
                UserDefaults.standard.userAccount = account
                
                
            }else {
                UserDefaults.standard.set(nil, forKey: "userAccount")
               
            }
        }
    }
    
    private var token: String? {
        didSet {
            isLoggedIn = token != nil
            if !isLoggedIn {
                userAccount = nil
                UserDefaults.standard.removeObject(forKey: "token")
            }
        }
    }
    private var account: UserShape? {
        didSet {
            userAccount = account ?? nil
            
        }
    }
    
    init() {
        self.token = UserDefaults.standard.string(forKey: "token")
        self.isLoggedIn = token != nil
        guard let _ = token, let userAcc = UserDefaults.standard.userAccount else {
            return
        }
        self.account = userAcc
    }
    
    func setToken(_ token: String) {
        self.token = token
    }
    
    func logIn(userAccount: UserShape) {
        self.account = userAccount
        guard let token =  userAccount.token ?? nil else {
            return
        }
        self.setToken(token)
    }
    
    // Method to log out the user
    func logOut() {
        self.account = nil
        self.token = nil
    }
    
    func refreshUser(){
        guard let account = account else {
            return
        }
        self.userApi.retreiveUser(id: account.id){ success, message, response in
            // for now we will just log errors
            if !success {
                print("An error occured we should fix")
                print("message", message)
                
            }
            guard let response = response else {
                return
            }
            self.logIn(userAccount: response)
            
            
        }
        
    }
}
