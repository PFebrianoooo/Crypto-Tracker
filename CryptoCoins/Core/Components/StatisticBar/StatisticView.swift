//
//  StatisticView.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 19/04/24.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: ( stat.changePercentage ?? 0 ) >= 0 ? "chevron.up" : "chevron.down")
                    .font(.caption2)
                    .bold()

                
                Text(stat.changePercentage?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(( stat.changePercentage ?? 0 )  >= 0 ? Color.theme.green : Color.theme.red )
            .opacity(stat.changePercentage == nil ? 0.0 : 1.0)
        }
    }
}

#Preview {
    StatisticView(stat: DeveloperPreview.instance.statistic1)
        .preferredColorScheme(.light)
}

#Preview {
    StatisticView(stat: DeveloperPreview.instance.statistic3)
        .preferredColorScheme(.dark)
}

#Preview {
    StatisticView(stat: DeveloperPreview.instance.statistic2)
        .preferredColorScheme(.dark)
}
