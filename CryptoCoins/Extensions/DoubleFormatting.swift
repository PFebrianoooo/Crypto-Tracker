//
//  DoubleFormatting.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 17/04/24.
//  Extensions for formating double with little documentation

import Foundation

extension Double {
    
    /// convert double to currency with 2 to 2 decimal places
    /// ```
    /// convert 1234.56 to $1,234.56
    /// ```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true // <- kita ingin menggunakan comma
        formatter.numberStyle = .currency
//        formatter.locale =  // <- default value
        formatter.currencyCode = "USD" // <- currency name
        formatter.currencySymbol = "$" // <- currency symbols
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    
    /// convert double to currency as string with 2 to  2  decimal places
    /// ```
    /// convert 1234.56 to $1,234.56
    /// ```
    func asCurrencyWithTwoDecimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.000"
    }

    
    /// convert double to currency with 2 to 6 decimal places
    /// ```
    /// convert 1234.56 to $1,234.56
    /// convert 12.3456 to $12.3456
    /// convert 0.123456 to $0.123456
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true // <- kita ingin menggunakan comma
        formatter.numberStyle = .currency
//        formatter.locale =  // <- default value
        formatter.currencyCode = "USD" // <- currency name
        formatter.currencySymbol = "$" // <- currency symbols
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    
    /// convert double to currency as string with 2 to  6 decimal places
    /// ```
    /// convert 1234.56 to $1.234.56
    /// convert 12.3456 to $12.3456
    /// convert 0.123456 to $0.123456
    /// ```
    func asCurrencyWithSixDecimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.000"
    }

    
    /// convert double to string representation with 2 decimal places
    /// ```
    /// convert 1.2344000 to "1.23"
    /// convert 12.3456 to "12,34"
    /// convert 0.123456 to "0.12"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    
    /// convert double to string representation with 2 decimal places with added percentage symbols (%)
    /// ```
    /// convert 1.2344000 to "1.23%"
    /// convert 12.3456 to "12.34%"
    /// convert 0.123456 to "0.12%"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()

        default:
            return "\(sign)\(self)"
        }
    }

    
}
