//
//  Food.swift
//  ListPractice
//
//  Created by Aditya Majumdar on 07/08/24.
//

import Foundation
import SwiftUI

struct Food: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
    var description: String
    var isFavorite: Bool
    
    
    static func preview() -> [Food]{
        [
            Food(name: "Apple", icon: "🍎", description: "57", isFavorite: true),
            Food(name: "Banana", icon: "🍌", description: "134", isFavorite: false),
            Food(name: "Cherry", icon: "🍒", description: "87", isFavorite: false),
            Food(name: "Mango", icon: "🥭", description: "99", isFavorite: true),
            Food(name: "Kiwi", icon: "🥝", description: "110", isFavorite: false),
            Food(name: "Strawberry", icon: "🍓", description: "46", isFavorite: true),
            Food(name: "Grapes", icon: "🍇", description: "62", isFavorite: true),
            Food(name: "Rice", icon: "🍚", description: "130", isFavorite: true),
            Food(name: "Oats", icon: "🥣", description: "62", isFavorite: true)
        ]
    }
}

struct FoodCardRow: Identifiable {
    
    var id = UUID()
    var cardTitle : String
    var cardHeadTitle : String
    var cardDesc : String
    var backgroundGradient : LinearGradient
    var backgroundImageString : String
}

