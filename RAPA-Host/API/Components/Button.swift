//
//  Button.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/26/24.
//

import SwiftUI
struct CustomButton: View {
    var text: String
    var icon: Image?
    @Binding var isLoading: Bool
    var clicked: (() -> Void) = {} /// use closure for callback
    
    init(text: String, icon: Image? = nil, isLoading: Binding<Bool> = .constant(false), clicked: @escaping (() -> Void) = {}) {
        self.text = text
        self.icon = icon
        self._isLoading = isLoading
        self.clicked = clicked
    }

    var body: some View {
        Button {
            clicked()
        } label: {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                HStack {
                    if icon != nil {
                        icon
                    }
                    Text(text)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.bordered)
        .controlSize(.large)

    }
}


#Preview {
    CustomButton(text: "Click me",icon: Image(systemName: "person.fill"), isLoading: .constant(true)){
        print("here")
    }
}
