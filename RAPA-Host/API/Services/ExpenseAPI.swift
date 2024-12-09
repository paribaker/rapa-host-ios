//
//  ExpenseApi.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/8/24.
//

import Foundation

class ExpenseApi {
    let expensesUri = "expenses/expense-group/"
    private let client = ApiService(baseUrl: BASE_URL )
    
    
    private var getAuthHeader: [String: String]? {
        guard let token = UserDefaults.standard.userAccount?.token else {
            return nil
        }
        return ["Authroization": "token \(token)"]
        
    }
    
    
    func listExpenses(params: [String: Any] = [:], completion: @escaping (_ success: Bool, _ message: String, _ response: PaginatedRes<ExpenseShape>?) -> Void) {
        let header:[String: Any] = getAuthHeader ?? [:]
        
        self.client.requestGet(uri: self.expensesUri, header: header ) { (response:PaginatedRes<ExpenseShape>?, error) in
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
    
    func retreiveExpense(id: UUID, completion: @escaping (_ success: Bool, _ message: String, _ response: UserShape?) -> Void) {
        let header:[String: Any] = getAuthHeader ?? [:]
        let endpoint = "\(self.expensesUri)\(id)"
        
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
