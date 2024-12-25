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
    let organizations = "organizations/"
    private let client = ApiService(baseUrl: BASE_URL )
    
    
    private var getAuthHeader: [String: String]? {
        guard let token = UserDefaults.standard.userAccount?.token else {
            return nil
        }
        return ["Authorization": "token \(token)"]
        
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
    
    func retreiveUser(id: String, completion: @escaping (_ success: Bool, _ message: String, _ response: UserShape?) -> Void) {
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
    func listUsers(params: [String: Any] = [:], completion: @escaping (_ success: Bool, _ message: String, _ response: PaginatedRes<UserShape>?) -> Void){
        let header:[String: Any] = getAuthHeader ?? [:]
        let endpoint = "\(self.users)"
        self.client.requestGet(uri: endpoint, header: header ) { (response:PaginatedRes<UserShape>?, error) in
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
    
    func listOrgs(params: [String: Any] = [:], completion: @escaping (_ success: Bool, _ message: String, _ response: PaginatedRes<OrgShape>?) -> Void){
        let header:[String: Any] = getAuthHeader ?? [:]
        self.client.requestGet(uri: self.organizations, header: header ) { (response:PaginatedRes<OrgShape>?, error) in
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
