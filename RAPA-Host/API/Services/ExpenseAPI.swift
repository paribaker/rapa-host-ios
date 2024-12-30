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
    let receiptsUri = "expenses/receipts/"
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
    
    func uploadReceipt(fileName: String, receiptData: Data, fileType: String, completion: @escaping (_ response: ReceiptShape?, _ error: Error?) -> Void) {
        var url = URL(string: BASE_URL)
        url?.appendPathComponent(receiptsUri)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.setValue("token \(UserDefaults.standard.userAccount?.token ?? "")", forHTTPHeaderField: "Authorization")
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"asset\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(fileType)\r\n\r\n".data(using: .utf8)!)
        body.append(receiptData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body as Data
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response {
                print("Response: \(response)")
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200 || httpResponse?.statusCode == 201 {
                    print("Success")
                    let decoder = JSONDecoder()
                    do {
                        let receipt = try decoder.decode(ReceiptShape.self, from: data!)
                        completion(receipt, nil)
                    }catch{
                        let message = String(data: data!, encoding: .utf8)!
                        completion(nil, error)
                    }
                    
                    
                }
            }
            
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
                return
            }
            
        }
        task.resume()
    }
    
    func createReceipts(receipts: [CreateReceiptShape], completion: @escaping (_ success: Bool, _ message: String, _ data: [String?] ) -> Void) {
        var header:[String: Any] = getAuthHeader ?? [:]
        header["Content-Type"] = ContentType.multipart.rawValue
        let dispatchGroup = DispatchGroup()
        var successIds: [String?] = []
        for receipt in receipts {
            dispatchGroup.enter()
            self.uploadReceipt(fileName: receipt.asset.name, receiptData: receipt.asset.data, fileType: receipt.asset.fileType) { (data: ReceiptShape?, error: Error?) in
                if let error {
                    print("Error uploading receipt: \(error)")
                    dispatchGroup.leave()
                    return
                }else{
                    successIds = successIds+[data?.id]
                }
                
                dispatchGroup.leave()
            }
            
        }
        
        dispatchGroup.notify(queue: .main) {
            let message = "Uploaded \(successIds.count) of \(receipts.count) receipts successfully."
            
            completion(true, message, successIds)
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
