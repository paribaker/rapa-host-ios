//
//  ExpenseApi.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/8/24.
//

import Foundation

class ExpenseApi {
    let expensesUri = "expenses/expense-group/"
    let reportsUri = "expenses/expense-report/"
    let expenseCategoryUri = "expenses/category-options/"
    let expenseCashflowTypeUri = "expenses/cash-flow-type/"
    private let client = ApiService(baseUrl: BASE_URL )
    
    
    private var getAuthHeader: [String: String]? {
        guard let token = UserDefaults.standard.userAccount?.token else {
            return nil
        }
        return ["Authorization": "token \(token)"]
        
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
    
    func retreiveExpense(id: String, completion: @escaping (_ success: Bool, _ message: String, _ response: UserShape?) -> Void) {
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
    
    func createExpense(expense: CreateExpenseShape, completion: @escaping (_ success: Bool, _ message: String, _ response: ExpenseShape?) -> Void) {
        let header:[String: Any] = getAuthHeader ?? [:]
        
        self.client.requestPost(uri: self.expensesUri, body: expense, header: header) { (response: ExpenseShape?, error) in
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

    func listReports(params: [String: Any] = [:], completion: @escaping (_ success: Bool, _ message: String, _ response: PaginatedRes<ReportShape>?) -> Void) {
        let header:[String: Any] = getAuthHeader ?? [:]
        self.client.requestGet(uri: self.reportsUri, header: header) { (response: PaginatedRes<ReportShape>?, error) in
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
    
    func listExpenseCategories(params: [String: Any] = [:], completion: @escaping (_ success: Bool, _ message: String, _ response: [[String]]?) -> Void) {
        let header:[String: Any] = getAuthHeader ?? [:]
        
        self.client.requestGet(uri: self.expenseCategoryUri, header: header) { (response: [[String]]?, error) in
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
    
    func listExpenseCashFlowTypes(params: [String: Any] = [:], completion: @escaping (_ success: Bool, _ message: String, _ response: [[String]]?) -> Void) {
        let header:[String: Any] = getAuthHeader ?? [:]
        self.client.requestGet(uri: self.expenseCashflowTypeUri, header: header){ (response: [[String]]?, error) in
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
