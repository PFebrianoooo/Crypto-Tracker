//
//  Color.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 16/04/24.
//  theme colors

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
    static let launchScreen = LauncscreenTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColors")
    let red = Color("RedColors")
    let secondaryText = Color("SecondaryTextColor")
    let thirdText = Color("ThirdTextColor")
}

struct LauncscreenTheme{
    let accent = Color("LaunchscreenAccentColor")
    let Background = Color("LaunchscreenColor")
}
