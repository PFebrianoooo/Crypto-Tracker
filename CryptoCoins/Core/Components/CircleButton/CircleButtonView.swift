//
//  CircleButtonView.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 16/04/24.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundStyle(Color.theme.background)
            )
            .shadow(
                color: Color.theme.accent.opacity(0.65),
                radius: 10, x: 0.0, y: 0.0
            )
            .padding()
            
    }
}

#Preview {
    CircleButtonView(iconName: "heart.fill")
        .preferredColorScheme(.light)
}

#Preview {
    CircleButtonView(iconName: "chevron.right")
        .preferredColorScheme(.dark)
}
