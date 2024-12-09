//
//  Extension+View.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/7/24.
//

import SwiftUI
struct ModalHeightModifier: ViewModifier {
    var height: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(height: height)
    }
}

extension View {
    func modalHeight(_ height: CGFloat) -> some View {
        self.modifier(ModalHeightModifier(height: height))
    }
}
