//
//  PDFViewer.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/11/24.
//

import SwiftUI

struct PDFViewer: View {
    let url: URL
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            PDFKitView(url: url, isLoading: $isLoading)
            
            if isLoading {
                ActivityIndicator(isAnimating: $isLoading, style: .large)
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    PDFViewer(url: URL(string: "https://www.example.com/sample.pdf")!)
}
