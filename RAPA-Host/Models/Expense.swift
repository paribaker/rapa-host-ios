//
//  Expense.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/8/24.
//

import Foundation


public struct OrganizationShape: Hashable, Codable {
    public var id: UUID
    public var name: String?
}
public struct ReportShape: Hashable, Codable {
    public var id: UUID
    public var name: String?
    public var organization: UUID?
    public var organizationRef: OrganizationShape?
    public var expenses: [UUID]?
}

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
    public var organizationRef: OrganizationShape?
    public var receipts: [UUID]?
    public var reimburseTo: UUID?
    public var reimburseToRef: UserShape?
    public var providedId: String?
    public var category: String?
    public var cashFlowType: String?
    public var receiptsRef: [ReceiptShape]?
    public var report: UUID?
    public var reportRef: ReportShape?

}


public struct ReceiptShape: Hashable, Codable {
    public var id: UUID?
    public var name: String?
    public var asset: String?
    public var expense: String?
    public var expenseRef: ExpenseShape?
    
    public var assetUrl: URL? {
        guard let asset else { return nil }
        return URL(string: asset)
    }
}




public struct CreateExpenseShape: Hashable, Codable {
    public var name: String
    public var amount: String
    public var amountCurrency: String
    public var isReimbursed: Bool
    public var notes: String?
    public var isReimbursable: Bool
    public var expenseDate: String
    public var organization: UUID?
    public var receipts: [UUID]?
    public var reimburseTo: UUID?
    public var providedId: String?
    public var category: String?
    public var cashFlowType: String?
    public var report: UUID?
}
