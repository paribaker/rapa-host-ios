//
//  ExpenseSheet.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/9/24.
//

import SwiftUI
import PDFKit


struct ExpenseDetails: View {
    @State var expense: ExpenseShape

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center){
                Text("\(expense.name)").font(.title)
                
            }.frame(maxWidth: .infinity, alignment: .center).multilineTextAlignment(  .center)
            HStack {
                Text(expense.organizationRef?.name ?? "")
                Spacer()
                Text("\(expense.expenseDate)")
            }
            VStack {
                Text(CurrencyFormatter.format(amount: Double(expense.amount) ?? 0.0, currencyCode: expense.amountCurrency)).font(.largeTitle)
            }.frame(maxWidth: .infinity)
            
                VStack {
                    Text(
                        expense.notes ?? ""
                    )
                    .lineLimit(5)
                      .frame(maxWidth: .infinity, alignment: .leading)
                }.frame(maxWidth: .infinity)
        

            ReceiptView(receipts: expense.receiptsRef ?? [])
            
            HStack {
                Label(expense.category ?? "", systemImage: expense.cashFlowType?.uppercased() == OUTFLOW_STRING.uppercased() ? "arrow.right" : "arrow.left").foregroundStyle(expense.cashFlowType?.uppercased() == OUTFLOW_STRING.uppercased() ? .red : .green)
                Spacer()
                Label("", systemImage: "document")
                Text(expense.reportRef?.name ?? "").textCase(.uppercase)
            }
            if expense.isReimbursable {
                HStack {
                    Label(REIMBURSABLE_STRING, systemImage: "tag")
                    Text(expense.reimburseToRef?.email ?? "")
                    if expense.isReimbursed {
                        Image(systemName: "checkmark").foregroundStyle(.green).frame(width:5, height:5).padding(.leading, 5)
                    }else{
                        Image(systemName: "xmark").foregroundStyle(.red).frame(width:5, height:5).padding(.leading, 5)
                    }
                    
                }

            }
            
            HStack {
                CopyableText(text: expense.providedId ?? "")
            }
            

            
        }.padding(.horizontal, 20).padding(.vertical, 10)
    }
}

struct ReceiptView: View {
    @State var receipts: [ReceiptShape] = []
    @State private var currentIndex: Int = 0
    var body: some View {
        
        ReceiptsDisplayView(currentIndex: $currentIndex, receipts: $receipts)
        
    }
}


struct ExpenseSheet: View {
    
    @State var expense: ExpenseShape?
    var body: some View {
        if let expense {
            VStack {
                ExpenseDetails(expense: expense)
            }
        }else {
            EmptyView()
        }
    }
    
}

#Preview {
    let sampleOrg = OrganizationShape(id: UUID(), name: "Sample Org")
    let sampleExpense = ExpenseShape(id: UUID(), name: "Some Expense", amount: "100.00", amountCurrency: "COP", notes: "Sample Notes", isReimbursable: true, isReimbursed: true, expenseDate: "12-20-2024", organization: nil, organizationRef: sampleOrg, receipts: nil)
    ExpenseSheet(expense: sampleExpense)
}
