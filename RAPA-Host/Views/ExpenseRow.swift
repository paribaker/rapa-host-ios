//
//  ExpenseRow.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/8/24.
//

import SwiftUI

/// Name in bold
/// date bellow it in gray
/// copany on the bottom left
/// amount on the right
/// Navigation that opens sheet

struct ExpenseRow: View {
    
    @State var expense: ExpenseShape?
    @State var showDetailSheet = false
    var body: some View {
    
        VStack{
            if let expense {
               
                    
                    VStack(alignment: .leading) {
                        
                        Text(expense.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(expense.expenseDate)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            Text(expense.organization?.uuidString ?? "")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(expense.amountCurrency) \(expense.amount)")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                        showDetailSheet = true
                    }.sheet(isPresented: $showDetailSheet){
                        ExpenseSheet(expense: expense)
                    }

            }else {
                EmptyView()
            }

        }.padding(.horizontal, 10).clipShape(RoundedRectangle(cornerRadius: 20.0))
        
    }
}

#Preview {
    ExpenseRow()
}
