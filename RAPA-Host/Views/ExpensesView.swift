//
//  ExpensesView.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/7/24.
//

import SwiftUI


struct ExpensesView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.expenses, id: \.self) { expense in
                        ExpenseRow(expense: expense).environmentObject(viewModel)
                    }
                }
            }
            Spacer()
            SearchFilterToolbar()
        }.padding(.horizontal, 10).onAppear{
            viewModel.listExpenses()
        }.sheet(isPresented: $viewModel.showErrorModal) {
            VStack {
                Text("Login Failed")
                    .font(.headline)
                    .padding()
                Text(viewModel.error)
                    .padding()
                Button("Dismiss") {
                    viewModel.showErrorModal = false
                }
                .padding()
            }.presentationDetents([.medium])
        }.sheet(isPresented: $viewModel.showCreateExpense){
            ZStack {
                VStack {
                    
                    CreateExpenseView()

                }
            }
        }.navigationBarItems(trailing: Button(action: {
            viewModel.showCreateExpense.toggle()
        }) {
            Image(systemName: "plus")
                .imageScale(.large)
        })

    }
}

#Preview {
    ExpensesView().environmentObject(ExpenseViewModel())
}


