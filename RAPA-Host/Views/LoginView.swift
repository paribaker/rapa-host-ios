//
//  LoginView.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 11/30/24.
//

import SwiftUI
import Combine

struct LoginView: View {
  
    @StateObject var viewModel: LoginViewModel = LoginViewModel()
    @EnvironmentObject var sessionManager: SessionManager
    
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
        Text("Login")
            .font(.largeTitle)
            .padding(.bottom, 60)

        TextField("Enter your email", text: $viewModel.email)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .textFieldStyle(.roundedBorder)
        
        SecureField("Enter your pasword", text: $viewModel.password)
        .textFieldStyle(.roundedBorder)
        .padding(.bottom, 30)

      Button {
          print("here")
          viewModel.login{ user in
              sessionManager.logIn(userAccount: user)
          }
      } label: {
        Text("Log In")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.bordered)
      .controlSize(.large)
    }
      
    .padding(30)
    .sheet(isPresented: $viewModel.showLoginErrorModal) {
        VStack {
            Text("Login Failed")
                .font(.headline)
                .padding()
            Text(viewModel.error!)
                .padding()
            Button("Dismiss") {
                viewModel.showLoginErrorModal = false
            }
            .padding()
        }.presentationDetents([.medium])
    }
  }

}

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String? = nil
    @Published var showLoginErrorModal: Bool = false
    
    
    let userApi = UserApi()
    
    func login(completion: @escaping ( UserShape)-> Void){
        self.userApi.login(body: LoginShape(email:email, password:password)) { success, message, data in
            if !success {
                self.error = message
                self.showLoginErrorModal = true
            }
            
            guard let data = data else{
                return
            }
            completion(data)
            
        
            
        }
    }
    
    
    
}
#Preview {
    var loginViewModel = LoginViewModel()
    LoginView(viewModel: loginViewModel )
}
