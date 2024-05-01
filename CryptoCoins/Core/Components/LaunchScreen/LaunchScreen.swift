//
//  LaunchScreen.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 25/04/24.
//

import SwiftUI

struct LaunchScreen: View {
    
    @State private var loop: Int = 0
    @State private var loadingText: [String] = "Loading".map{String($0)}
    @State private var showLoading: Bool = false
    @State private var counter: Int = 0
    private let timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
    
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.launchScreen.Background
                .ignoresSafeArea()
            
            Image("Logo-Cropped")
                .resizable()
                .frame(width: 150, height: 150)
            
            ZStack {
                if showLoading {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices, id: \.self) { indices in
                            Text(loadingText[indices])
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.white)
                                .offset(y: counter == indices ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.opacity.animation(.easeIn))
                }
            }
            .offset(y: 100)
        }
        .onAppear(perform: {
            showLoading.toggle()
        })
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()) {
                let index = loadingText.count - 1
                
                if counter == index {
                    counter = 0
                    loop += 1
                    
                    if loop > 3 {
                        showLaunchView = false
                    }
                }else {
                    counter += 1
                }
            }
        })
    }
}

#Preview {
    LaunchScreen(showLaunchView: .constant(true))
        .preferredColorScheme(.dark)
}
