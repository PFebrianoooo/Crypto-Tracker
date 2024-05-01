//
//  CryptoCoinsApp.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 16/04/24.
//

import SwiftUI

@main
struct CryptoCoinsApp: App {
    
    @StateObject private var homeVM = HomeViewModel()
    @State private var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UINavigationBar.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                }
                .environmentObject(homeVM)
                
                ZStack {
                    if showLaunchView {
                        LaunchScreen(showLaunchView: $showLaunchView)
                            .transition(AnyTransition.opacity)
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
