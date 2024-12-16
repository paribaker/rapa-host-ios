//
//  CopyableText.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/11/24.
//

import SwiftUI

struct CopyableText: View {
    let text: String
    
    var body: some View {
        Text(text).lineLimit(1).truncationMode(.tail)
            .contextMenu {
                Button(action: {
                    UIPasteboard.general.string = text
                }) {
                    Text("Copy")
                    Image(systemName: "doc.on.doc")
                }
            }
    }
}

#Preview {
    CopyableText(text: "This is a copyable text.")
}
