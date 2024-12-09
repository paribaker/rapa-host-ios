//
//  UserAPI.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/7/24.
//

import Foundation

class UserApi {
    let login = "login/"
    let users = "users/"
    let profile = "profiles/"
    private let client = ApiService(baseUrl: BASE_URL )
    
    
    private var getAuthHeader: [String: String]? {
        guard let token = UserDefaults.standard.userAccount?.token else {
            return nil
        }
        return ["Authroization": "token \(token)"]
        
    }
    
    
    func login(body: LoginShape, completion: @escaping (_ success: Bool, _ message: String, _ response: UserShape?) -> Void) {
        let header: [String: Any?] = [:]
        self.client.requestPost(uri: self.login,body: body, header: header as [String : Any]) { (response: UserShape?, error) in
            if let error{
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription, nil)
                }
            }else{
                DispatchQueue.main.async {
                    completion(true, "", response)
                }
            }
        }
        
    }
    
    func retreiveUser(id: UUID, completion: @escaping (_ success: Bool, _ message: String, _ response: UserShape?) -> Void) {
        let header:[String: Any] = getAuthHeader ?? [:]
        let endpoint = "\(self.users)\(id)"
        
        self.client.requestGet(uri: endpoint, header: header ) { (response: UserShape?, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(true, "", response)
                }
            }
        }
    }

    
}
