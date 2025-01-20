//
//  ExpensesViewModel.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/12/24.
//

import Combine
import Foundation
import SwiftUI
import PhotosUI

enum CurrencyOptions: String, CaseIterable {
    case USD
    case COP
}

class ExpenseViewModel: ObservableObject {
    @Published var loadingExpenses: Bool = false
    @Published var expenses: [ExpenseShape] = []
    @Published var page: Int = 1
    @Published var error = ""
    @Published var showErrorModal: Bool = false
    @Published var showCreateExpense: Bool = false
    @Published var name = ""
    @Published var orgs: [OrgShape] = []
    @Published var users: [UserShape] = []
    @Published var reports: [ReportShape] = []
    @Published var expenseCats: [[String]] = []
    @Published var expenseCashFlowTypes: [[String]] = []
    @Published var showFilePicker: Bool = false
    @Published var selectedFiles: [URL] = []
    @Published var showDocumentTypeOptions: Bool = false
    @Published var showImagePicker: Bool = false
    @Published var selectedImages: [PhotosPickerItem] = [] {
        didSet {
            loadImages(selectedImages)
        }
    }
    @Published var expenseForm =  CreateExpenseForm()
    @Published var loadingCreateExpense: Bool = false
    @Published var showCreateExpenseSheet: Bool = false
    @Published var loadingCreateReceipt: Bool = false
    @Published var completedExpense: Bool = false
    @Published var completedReceipt: Bool = false
    
    var expenseApi = ExpenseApi()
    var userApi = UserApi()
    
    func getCurrencyFormatter(for currency: String) -> NumberFormatter {
        CurrencyFormatter.formatter(for: currency)
    }
    
    
    private func loadImages(_ images: [PhotosPickerItem]) {
        for image in images {
            
            image.loadTransferable(type: Data.self) { result in
                
                switch result {
                case .success(let data):
                    if let data = data, let fileType = image.supportedContentTypes.first?.preferredMIMEType {
                        
                        guard let fileExt = UTType(mimeType: fileType) else { return }
                        let name = image.itemIdentifier?.split(separator: "/").last.map(String.init) ?? UUID().uuidString
                        let ext = fileExt.preferredFilenameExtension ?? ".jgp"
                        let fileName = "\(name).\(ext)"
                        
                        
                        let fileShape = FileShape(name: fileName, fileType: fileType, data: data)
                        
                        
                        let receipt = CreateReceiptShape(asset: fileShape)
                        DispatchQueue.main.async {
                            self.expenseForm.newReceipts.append(receipt)
                        }
                        
                    }
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
            
        }
        
        
    }
    func listExpenses() {
        loadingExpenses = true
        expenseApi.listExpenses(params: ["page": page]) { success, message, data in
            if success {
                guard let data = data else { return }
                self.expenses = data.results!
            }else {
                self.error = message
                self.showErrorModal = true
            }
                self.loadingExpenses = false
            
        }
    }
    
    func deleteExpense(expenseId: String) {
        loadingExpenses = true
        let index = self.expenses.firstIndex(where: { $0.id == expenseId })
        if index == nil { return }
        expenseApi.deleteExpense(id: expenseId) { success, message in
            if success {
                self.expenses.remove(at: index!)
                
            }else {
                self.error = message
            }
            self.loadingExpenses = false
        }
    }
    
    func listOrgs() {
        userApi.listOrgs { success, message, data in
            if success {
                guard let data = data else { return }
                self.orgs = data.results!
            }else {
                self.error = message
            }
        }
    }
    
    func listUsers() {
        userApi.listUsers { success, message, data in
            if success {
                guard let data = data else { return }
                self.users = data.results!
            }else {
                self.error = message
            }
        }
    }
    
    func listReports() {
        expenseApi.listReports { success, message, data in
            if success {
                guard let data = data else { return }
                self.reports = data.results!
            }else {
                self.error = message
            }
        }
    }
    
    func listExpenseCategories() {
        expenseApi.listExpenseCategories { success, message, data in
            if success {
                guard let data = data else { return }
                self.expenseCats = data
            }else {
                self.error = message
            }
        }
    }
    
    func listCashFlowTypes() {
        expenseApi.listExpenseCashFlowTypes { success, message, data in
            if success {
                guard let data = data else { return }
                self.expenseCashFlowTypes = data
            }else {
                self.error = message
            }
        }
    }
    
    
    func createExpense() {
        loadingCreateReceipt = true
        if expenseForm.newReceipts.count > 0 {
            expenseApi.createReceipts(receipts: expenseForm.newReceipts){ success, message, data in
                
                self.expenseForm.receipts = data.map(\.self!)
            }
            
        }
        loadingCreateReceipt = false
        completedReceipt.toggle()
        loadingCreateExpense = true
        
        expenseApi.createExpense(expense: expenseForm.modelValue) { success, message, data in
            if success {
                guard let data = data else { return }
                self.expenses.append(data)
//                self.expenseForm = CreateExpenseForm()
                self.showCreateExpense.toggle()
                
            }else {
                self.error = message
                self.showErrorModal = true
            }
            self.loadingCreateExpense = false
            self.completedExpense.toggle()
        }
    }
    
    
    func loadExpenseForm(with expense: ExpenseShape? = nil) {
            expenseForm = CreateExpenseForm(expense: expense)
        
    }
    
    
}


func getFormattedDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}

class CreateExpenseForm: ObservableObject {
    @Published var name: String = ""
    @Published var amount: Double = 0
    @Published var amountCurrency: CurrencyOptions = .COP
    @Published var notes: String = ""
    @Published var isReimbursable: Bool = false
    @Published var expenseDate: Date = Date()
    @Published var isReimbursed: Bool = false
    @Published var organization: String? = nil
    @Published var receipts: [String]? = nil
    @Published var reimburseTo: String? = nil
    @Published var providedId: String = ""
    @Published var category: String? = nil
    @Published var cashFlowType: String? = nil
    @Published var report: String?
    @Published var newReceipts : [CreateReceiptShape] = []
    
    init(expense: ExpenseShape? = nil) {
        guard let expense = expense else { return }
        self.name = expense.name
        self.amount = Double(expense.amount)!
        self.amountCurrency = CurrencyOptions(rawValue: expense.amountCurrency)!
        self.notes = expense.notes ?? ""
        self.isReimbursable = expense.isReimbursable
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:expense.expenseDate)!
        self.expenseDate = date
        self.organization = expense.organization
        self.receipts = expense.receipts
        self.newReceipts = []
        self.reimburseTo = expense.reimburseTo
        self.providedId = expense.providedId ?? ""
        self.category = expense.category
        self.cashFlowType = expense.cashFlowType
        self.report = expense.report
        
        
        
        
    }
    
    
    var modelValue: CreateExpenseShape {
        .init(name: self.name, amount: String(format: "%.2f", self.amount), amountCurrency: self.amountCurrency.rawValue, isReimbursed: self.isReimbursed, notes: self.notes, isReimbursable: self.isReimbursable, expenseDate: getFormattedDate(date: self.expenseDate), organization: self.organization, receipts: self.receipts, reimburseTo: self.reimburseTo, providedId: self.providedId, category: self.category, cashFlowType: self.cashFlowType, report: report)
        
        
    }
    
    var value: [String:Any?] {
        [
            "name": self.name,
            "amount": String(format: "%.2f", self.amount),
            "amountCurrency": self.amountCurrency.rawValue,
            "isReimbursed": self.isReimbursed,
            "notes": self.notes,
            "isReimbursable": self.isReimbursable,
            "expenseDate": getFormattedDate(date: self.expenseDate),
            "organization": self.organization,
            "receipts": self.receipts,
            "reimburseTo": self.reimburseTo,
            "providedId": self.providedId,
            "category": self.category,
            "cashFlowType": self.cashFlowType,
            "report": self.report
        ]
        
        
    }
    
    func printValue() {
        do {
            let json = try JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted])
            if let string = String(data: json, encoding: .utf8) {
                print(string)
            }
        }catch {
            print("Failed")
        }
        
    }
    
    
    
    var isValid: Bool {
        name.count > 0 && organization != nil && cashFlowType != nil
    }
    
    
}
