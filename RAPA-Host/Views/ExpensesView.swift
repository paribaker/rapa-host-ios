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
            if viewModel.loadingExpenses {
                ProgressView()
            }else {
                List {
                    ForEach(viewModel.expenses, id: \.self){ expense in
                        ExpenseRow(expense: expense).environmentObject(viewModel).swipeActions(edge: .trailing, allowsFullSwipe: false){
                            Button{
                                viewModel.loadExpenseForm(with: expense)
                                viewModel.showCreateExpense.toggle()
                            }label:{
                                Label("Edit", systemImage: "square.and.pencil")
                                
                                
                            }.tint(.blue)
                            Button{
                                
                            } label:{
                                Label("Share", systemImage: "square.and.arrow.up")
                            }.tint(.green)
                            

                            
                            
                        }.swipeActions(edge: .leading, allowsFullSwipe: true){
                            Button{
                                
                                
                                
                                viewModel.deleteExpense(expenseId: expense.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            
                            .tint(.red)
                            

                            
                            
                        }
                    }
//                    }.onDelete{ indexPath in
//
//                        let expense = viewModel.expenses[indexPath.first!]
//                        viewModel.deleteExpense(expenseId: expense.id)
//                        
//                    }
                }
            }
            
            Spacer()
            SearchFilterToolbar()
        }.padding(.horizontal, 10).onAppear{
            if !viewModel.loadingExpenses {
                viewModel.listExpenses()
            }
            
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
        }.sheet(isPresented: $viewModel.showCreateExpense,onDismiss: {
            print("dissmissed")
            viewModel.loadExpenseForm(with: nil)
        }){
            ZStack {
                VStack {
                    
                    CreateExpenseView().environmentObject(viewModel)
                    
                }.padding(.horizontal, 10)
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


