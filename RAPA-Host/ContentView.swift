//
//  ContentView.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 11/30/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: SessionManager
    var body: some View {
        ZStack {
            if sessionManager.isLoggedIn {
                MainView()
            } else {
                LoginView()
            }
        }.padding(.horizontal, 10)

    }
}





#Preview {
    ContentView()
        .environmentObject(SessionManager.shared)
}
