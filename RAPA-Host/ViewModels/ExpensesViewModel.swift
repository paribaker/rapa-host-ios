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
    @Published var selectedImage: PhotosPickerItem?
    @Published var expenseForm =  CreateExpenseForm()
    @Published var loadingCreateExpense: Bool = false

    var expenseApi = ExpenseApi()
    var userApi = UserApi()
    
    func getCurrencyFormatter(for currency: String) -> NumberFormatter {
        CurrencyFormatter.formatter(for: currency)
    }


    func listExpenses() {
        expenseApi.listExpenses(params: ["page": page]) { success, message, data in
            if success {
                guard let data = data else { return }
                self.expenses = data.results!
            }else {
                self.error = message
                self.showErrorModal = true
            }
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
    
func createExpense(expense: CreateExpenseShape) {
        loadingCreateExpense = true
        expenseApi.createExpense(expense: expense) { success, message, data in
            if success {
                guard let data = data else { return }
                self.expenses.append(data)
                
            }else {
                self.error = message
                self.showErrorModal = true
            }
            self.loadingCreateExpense = false
        }
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
    
    

    
    var value: CreateExpenseShape {
        .init(name: self.name, amount: String(format: "%.2f", self.amount), amountCurrency: self.amountCurrency.rawValue, isReimbursed: self.isReimbursed, notes: self.notes, isReimbursable: self.isReimbursable, expenseDate: getFormattedDate(date: self.expenseDate), organization: self.organization, receipts: self.receipts, reimburseTo: self.reimburseTo, providedId: self.providedId, category: self.category, cashFlowType: self.cashFlowType, report: report)
        
    }
    
    var isValid: Bool {
        name.count > 0 && organization != nil && cashFlowType != nil
    }
    
    
}
