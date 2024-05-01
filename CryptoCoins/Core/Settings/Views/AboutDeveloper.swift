//
//  AboutUsView.swift
//  WasteBank
//
//  Created by Putra Pebriano Nurba on 30/03/24.
//

import SwiftUI

struct AboutDeveloper: View {
    
    private let instagramProfile: URL? = URL(string: "https://www.instagram.com/p.febrianoo_/")
    private let gitProfile: URL? = URL(string: "https://github.com/PFebrianoooo")
    
    var body: some View {
        ScrollView(.vertical) {
            
            profileImage
            
            briefSummary
            
            linkAndAdditionalResources
            
        }
        .scrollIndicators(.hidden)
        .navigationTitle("About Developer")
        .background(Color.theme.background)
    }
}

#Preview {
    NavigationStack {
        AboutDeveloper()
    }
}

extension AboutDeveloper {
    
    private var profileImage: some View {
        Image("CreatorPhoto")
            .resizable()
            .scaledToFill()
            .frame(width: 160, height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.theme.accent, lineWidth: 1.0)
            }
    }
    
    private var briefSummary: some View {
        VStack {
            Text("Bagaimana Crypto Tracker Dibuat")
                .font(.headline)
                .padding(.top)
                .fontWeight(.medium)
                .foregroundStyle(Color.theme.accent)
            
            Text("  Crypto Tracker dimulai ketika pada bulan April, saya Putra Pebriano Nurba selaku pembuat aplikasi merasa bosan ketika berada dirumah.\n\n  Akhirnya ada inisiasi atau fikiran untuk membuat aplikasi saja. Dimulai dari pencarian api dan mencari resource lain.\n\n Apresiasi buat channel youtube Swiftful Thinking yang membuat saya jago untuk membuat aplikasi yang dimana saya belum membayangkan sebelumnya kalo saya bisa juga untuk membuat aplikasi.\n\n Sehat-sehat deh buat perjuangan.")
                .font(.system(size: 13))
                .fontWeight(.regular)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .foregroundStyle(Color.theme.thirdText)
        }
    }
    
    private var linkAndAdditionalResources: some View {
        VStack {
            HStack {
                Text("Kenalan lebih lanjut yuk".capitalized)
                    .font(.headline)
                    .padding(.top, 30)
                    .fontWeight(.medium)
                    .padding(.leading, 20)
                    .foregroundStyle(Color.theme.accent)
                
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.caption)
                        .foregroundStyle(Color.theme.accent)
                    
                    Text("putrapebriano27@gmail.com".description)
                        .font(.subheadline)
                        .foregroundStyle(Color.theme.thirdText)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Divider()
            
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Instagram")
                            .font(.caption)
                            .foregroundStyle(Color.theme.accent)
                        
                        if let instagramProfile {
                            Link(destination: instagramProfile, label: {
                                Text("Klik Disini")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.theme.thirdText)
                            })
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Git Hub")
                            .font(.caption)
                            .foregroundStyle(Color.theme.accent)
                        
                        if let gitProfile {
                            Link(destination: gitProfile, label: {
                                Text("Klik Disini")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.theme.thirdText)
                            })
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Salam Hangat")
                        .font(.caption)
                        .foregroundStyle(Color.theme.accent)
                    
                    Text("Putra Pebriano Nurba Developer Team")
                        .font(.subheadline)
                        .foregroundStyle(Color.theme.thirdText)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

        }
    }
    
}

