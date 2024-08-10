//
//  Constants.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import Foundation
import UIKit
import SwiftUI


enum Constants {
    enum Text {
        static let foodTitle = "Food"
        static let addTitle = "Add an item"
        static let doneTitle = "Done"
        
    }
}

struct CommonFunctions{
    enum Functions{
        static func getHapticFeedback(impact: UIImpactFeedbackGenerator.FeedbackStyle) {
            let generator = UIImpactFeedbackGenerator(style: impact)
            generator.impactOccurred()
        }
        
    }
    
}
