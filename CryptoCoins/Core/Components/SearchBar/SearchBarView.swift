//
//  SearchBarView.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 19/04/24.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchTxt: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchTxt.isEmpty ? Color.theme.secondaryText : Color.theme.accent
                )
            
            TextField("Search by name or symbol", text: $searchTxt)
                .foregroundStyle(Color.theme.accent)
                .autocorrectionDisabled(true)
                .overlay(alignment: .trailing) {
                    if !searchTxt.isEmpty {
                        Image(systemName: "xmark.circle.fill")
                            .padding()
                            .offset(x: 10)
                            .foregroundStyle(Color.theme.accent)
                            .onTapGesture {
                                UIApplication.shared.endEditing()
                                searchTxt = ""
                            }
                    }
                }
                .submitLabel(.search)
            
        }
        .font(.headline)
        .padding(.all, 10)
        .background(RoundedRectangle(cornerRadius: 25).fill(Color.theme.background))
        .shadow(color: Color.theme.accent.opacity(0.45), radius: 10, x: 0.0, y: 0.0)
        .padding()
    }
}

#Preview {
    SearchBarView(searchTxt: .constant(""))
        .preferredColorScheme(.light)
}

#Preview {
    SearchBarView(searchTxt: .constant(""))
    .preferredColorScheme(.dark)
}
