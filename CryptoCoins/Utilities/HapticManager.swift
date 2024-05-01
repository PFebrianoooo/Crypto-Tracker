//
//  HapticManager.swift
//  CryptoCoins
//
//  Created by Putra Pebriano Nurba on 23/04/24.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static func vibrations(type: UINotificationFeedbackGenerator.FeedbackType) {
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(type)
    }
}
