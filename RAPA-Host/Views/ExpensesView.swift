//
//  ExpensesView.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/7/24.
//

import SwiftUI


struct ExpensesView: View {
    @StateObject var viewModel: ExpenseViewModel = ExpenseViewModel()
    
    var body: some View {
        
        
        VStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.expenses, id: \.self) { expense in
                        ExpenseRow(expense: expense)
                    }
                }
            }
            Spacer()
            SearchFilterToolbar()
        }.padding(.horizontal, 10).background(Color.gray).onAppear{
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
        }

    }
}

#Preview {
    ExpensesView()
}


class ExpenseViewModel: ObservableObject {
    @Published var expenses: [ExpenseShape] = []
    @Published var page: Int = 1
    @Published var error = ""
    @Published var showErrorModal: Bool = false
    var expenseApi = ExpenseApi()
    
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
    
    
    
}
