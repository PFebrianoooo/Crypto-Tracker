//
//  CircleButtonAnimation.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 16/04/24.
//

import SwiftUI

struct CircleButtonAnimation: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 4.5)
            .scale(animate  ? 1.0 : 0)
            .opacity(animate ? 0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none, value: animate)
            .frame(width: 75, height: 75)
            .foregroundStyle(Color.theme.accent)
    }
}

#Preview {
    CircleButtonAnimation(animate: .constant(false))
        .frame(width: 100, height: 100)
        .foregroundStyle(Color.theme.red)
}
