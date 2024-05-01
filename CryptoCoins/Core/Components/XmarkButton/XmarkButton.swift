//
//  XmarkButton.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 21/04/24.
//

import SwiftUI

struct XmarkButton: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    
                Text("Back")
                    .font(.subheadline)
            }
            .foregroundStyle(Color.theme.accent)
        }
    }
}

#Preview {
    XmarkButton()
}
