//
//  Expense.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/8/24.
//

import Foundation


public struct FileShape: Hashable, Codable {
    public var name: String
    public var fileType: String
    public var data: Data

}

public struct OrganizationShape: Hashable, Codable {
    public var id: String
    public var name: String?
}
public struct ReportShape: Hashable, Codable {
    public var id: String
    public var name: String?
    public var organization: String?
    public var organizationRef: OrganizationShape?
    public var expenses: [String]?
}

public struct ExpenseShape: Hashable, Codable {
    public var id: String
    public var name: String
    public var amount: String
    public var amountCurrency: String
    public var notes: String?
    public var isReimbursable: Bool
    public var isReimbursed: Bool
    public var expenseDate: String
    public var organization: String?
    public var organizationRef: OrganizationShape?
    public var receipts: [String]?
    public var reimburseTo: String?
    public var reimburseToRef: UserShape?
    public var providedId: String?
    public var category: String?
    public var cashFlowType: String?
    public var receiptsRef: [ReceiptShape]?
    public var report: String?
    public var reportRef: ReportShape?

}


public struct ReceiptShape: Hashable, Codable {
    public var id: String?
    public var name: String?
    public var asset: String?
    public var expense: String?
    public var expenseRef: ExpenseShape?
    
    public var assetUrl: URL? {
        guard let asset else { return nil }
        return URL(string: asset)
    }
}

public struct CreateReceiptShape: Hashable, Codable {
    public var asset: FileShape
    
}



public struct CreateExpenseShape: Hashable, Codable {
    public var name: String
    public var amount: String
    public var amountCurrency: String
    public var isReimbursed: Bool
    public var notes: String?
    public var isReimbursable: Bool
    public var expenseDate: String
    public var organization: String?
    public var receipts: [String]?
    public var reimburseTo: String?
    public var providedId: String?
    public var category: String?
    public var cashFlowType: String?
    public var report: String?
}


let sampleExpenseData: ExpenseShape = ExpenseShape(id: "1", name: "Test Expense", amount: "100",amountCurrency: "COP", notes: "test", isReimbursable: false, isReimbursed: false, expenseDate: "2024-11-30", organization: nil, organizationRef: nil, receipts: [], reimburseTo: nil, reimburseToRef: nil, providedId: "randomId", category: "expense", cashFlowType: "outflow", report: nil, reportRef: nil )
