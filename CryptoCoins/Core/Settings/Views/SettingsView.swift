//
//  SettingsView.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 25/04/24.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var showFullDescription: Bool = false
    @State private var showFullDescription2: Bool = false
    private let coinGeckoLink: URL? = URL(string: "https://www.coingecko.com")
    

    var body: some View {
        NavigationStack {
            ZStack {
                // background layer
                Color.theme.background
                    .ignoresSafeArea()
                
                // content layer
                List {
                    
                    aboutApplicationsAndDeveloperInfo
                    
                    aboutApiInformationsCoinGecko
                    
                }
                
            }
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XmarkButton()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

extension SettingsView {
    
    private var aboutApplicationsAndDeveloperInfo: some View {
        Section {
            VStack(alignment: .leading) {
                Image("Logo-Cropped")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .animation(.none, value: showFullDescription)
                
                Text("Crypto Tracker application is an application that can track market conditions in realtime 24 Hours.\n\nCan store number of coins you own and calcuate it in realtime with current price market.\n\nAnd the best to be able to saving your coins and very easy to use and user friendly")
                    .lineLimit(showFullDescription ? nil : 2)
                    .font(.callout)
                    .foregroundStyle(Color.theme.accent)
                
                Text(showFullDescription ? "Less." : "Read More.")
                    .font(.callout)
                    .foregroundStyle(Color.blue)
                    .onTapGesture {
                        withAnimation(Animation.linear) {
                            showFullDescription.toggle()
                        }
                    }
                    
            }
            
            NavigationLink("Developer Info") {
                AboutDeveloper()
            }
            .foregroundStyle(Color.theme.accent)
            
        } header: {
            Text("Application & Developer Info")
        }
        .listRowBackground(Color.theme.background.opacity(0.5))
    }
    
    private var aboutApiInformationsCoinGecko: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .animation(.none, value: showFullDescription2)
                
                Text("CoinGecko is the world’s largest independent cryptocurrency data aggregator with over 14,000+ different cryptoassets tracked across more than 1,000+ exchanges worldwide.\n\nCoinGecko provides a fundamental analysis of the crypto market. In addition to tracking price, volume and market capitalisation, CoinGecko tracks community growth, open-source code development, major events and on-chain metrics.")
                    .font(.callout)
                    .lineLimit(showFullDescription2 ? nil : 2)
                    .foregroundStyle(Color.theme.accent)
                
                Text(showFullDescription ? "Less." : "Read More.")
                    .font(.callout)
                    .foregroundStyle(Color.blue)
                    .onTapGesture {
                        withAnimation(Animation.linear) {
                            showFullDescription2.toggle()
                        }
                    }
            }
            
            if let url = coinGeckoLink {
                Link(destination: url) {
                    HStack {
                        Text("Api Information")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .imageScale(.small)
                            .opacity(0.25)
                    }
                    .contentShape(Rectangle())
                }
            }
            
        } header: {
            Text("Coin Gecko Info")
        }
        .listRowBackground(Color.theme.background.opacity(0.5))
    }
}
