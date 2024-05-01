//
//  ChartView.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 25/04/24.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        self.data = (coin.sparklineIn7D?.price ?? [])
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
     
        endingDate = Date(coinGeckoDate: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60) // back to 7 day from endDate
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(alignment: .leading) { chartNumberUpOrDown }
            
            dateChartLabels
        }
        .font(.caption2)
        .foregroundStyle(Color.theme.secondaryText)
        .onAppear(perform: { trimmingAnimateChart() })
        .padding(.vertical, 25)
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
}

extension ChartView {
    
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    
                    let xPosition = (geometry.size.width / CGFloat(data.count)) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(
                lineColor,
                style: StrokeStyle(
                    lineWidth: 2.5,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .shadow(color: lineColor, radius: 10,x: 0.0 ,y: 10.0)
            .shadow(color: lineColor.opacity(0.65), radius: 10,x: 0.0 ,y: 20.0)
            .shadow(color: lineColor.opacity(0.45), radius: 10,x: 0.0 ,y: 30.0)
            .shadow(color: lineColor.opacity(0.25), radius: 10,x: 0.0 ,y: 40.0)
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartNumberUpOrDown: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
        .padding(.horizontal, 5)
    }
    
    private var dateChartLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            
            Spacer()
            
            Text(endingDate.asShortDateString())
        }
        .padding(.horizontal, 5)
    }
    
    private func trimmingAnimateChart() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.linear(duration: 5.0)) {
                percentage += 1
            }
        }
    }
    
}


// Meaning above view
/*
 NB: make geometry reader agar bisa dinamic menggunakan frame
 
 // Mencari koordinat dari layar horizontal
 geometry.size.width = 300
 CGFloat(data.count) = 100
 CGFloat(index + 1)  = 1
 xPosition = 300 / 100 = 3 * 1   = 3
                         3 * 2   = 6
                         3 * 100 = 300
 
 
 // mencari koordinat vertical batasan dari bawah
 // ketinggian
 maxY  = nilai dari array yang tertinggi = 60.000
 minY  = nilai dari array yang terendah  = 50.000
 ketinggian, yAxis = 60.000 - 50.000 = 10.000
 
 // batasan
 dataPoint = data[indexYangDicari]
 let xPosition = ( dataPoint - minY ) / yAxis
               = ( 52.000 - 50.000 ) / 10.000
               = 2.000 / 10.000
               = 0.2 or 20%
 
 koordinat iphone kebalik, dimana koordinat dari nol harusnya dibawah, ini diatas
 
  x position =
 */
