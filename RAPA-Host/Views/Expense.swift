//
//  Expense.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/8/24.
//

import Foundation

public struct ExpenseShape: Hashable, Codable {
    public var id: UUID
    public var name: String
    public var amount: String
    public var amountCurrency: String
    public var notes: String?
    public var isReimbursable: Bool
    public var isReimbursed: Bool
    public var expenseDate: String
    public var organization: UUID?
    public var receipts: [UUID]?
    public var reimburseTo: UUID?
    public var providedId: String?
    public var category: String?
    public var cashFlowType: String?
    public var report: UUID?

}
