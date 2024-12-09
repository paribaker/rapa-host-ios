//
//  SearchFilterToolbar.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/7/24.
//

import SwiftUI


struct SearchBar: View {
    @Binding var searchTerm: String
    @Binding var showFilters: Bool
    var body: some View {
        HStack {
            TextField("Search ...", text: $searchTerm)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            if searchTerm.count > 0 {
                 Button(action: {
                     self.searchTerm = ""
                 }) {
                     Image(systemName: "multiply.circle.fill")
                         .foregroundColor(.gray)
                         .padding(.trailing, 8)
                 }
             }
            Button(action: {
                // Action for filter button
                self.showFilters = !showFilters
            }) {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
            }
            
        }
    }
}

struct SearchFilterToolbar: View {
    @State var searchTerm: String = ""
    @State  var showFilters = false
    
    var body: some View {
        ZStack {
            SearchBar(searchTerm: $searchTerm, showFilters: $showFilters).padding(.bottom,10)
        }
        .sheet(isPresented: $showFilters) {
            VStack {
                Spacer()
                SearchBar(searchTerm: $searchTerm, showFilters: $showFilters)
           
            }.presentationDetents([.medium])
        }
        
    }
}

#Preview {
    SearchFilterToolbar().environmentObject(SessionManager.shared)
}
