//
//  ExpensesViewModel.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/12/24.
//

import Combine
import Foundation
import SwiftUI

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

    var expenseApi = ExpenseApi()
    var userApi = UserApi()
    
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
    
}



class CreateExpenseForm: ObservableObject {
    @Published var name: String = ""
    @Published var amount: Double = 0
    @Published var amountCurrency: CurrencyOptions = .COP
    @Published var notes: String = ""
    @Published var isReimbursable: Bool = false
    @Published var expenseDate: Date = Date()
    @Published var isReimbursed: Bool = false
    @Published var organization: UUID? = nil
    @Published var receipts: [UUID]? = nil
    @Published var reimburseTo: UUID? = nil
    @Published var providedId: String = ""
    @Published var category: String? = nil
    @Published var cashFlowType: String? = nil
    @Published var report: UUID?
    
    
    var currencyFormatter: NumberFormatter {
        CurrencyFormatter.formatter(for: amountCurrency.rawValue)
    }
    
    
}
