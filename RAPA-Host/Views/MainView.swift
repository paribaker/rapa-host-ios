//
//  MainView.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/7/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var session: SessionManager
    @StateObject var expenseVM: ExpenseViewModel = ExpenseViewModel()
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ExpensesView().environmentObject(expenseVM)) {
                    Text("Expenses")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                NavigationLink(destination: ReservationsView()) {
                    Text("Reservations")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            Button("Logout") {
                session.logOut()
                }
            }
            .navigationTitle("Main Menu")
        }
        
        
    }
}

#Preview {
    MainView()
}
