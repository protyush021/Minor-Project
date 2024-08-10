//
//  CalorieModel.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

import Foundation
import SwiftData

@Model
class CalorieModel {
    var userID : String
    var name: String
    var calories: Int
    var quantity: Int
    var protien: Int
    var carbs: Int
    var fats: Int
    var calCount: Int
    var protienCount: Int
    var carbsCount: Int
    var fatsCount: Int
    
    init(userID: String = "", name: String = "", calories: Int = 0, quantity: Int = 0, protien: Int = 0, carbs: Int = 0, fats: Int = 0, calCount: Int = 0, protienCount: Int = 0, carbsCount: Int = 0, fatsCount: Int = 0) {
        self.userID = userID
        self.name = name
        self.calories = calories
        self.quantity = quantity
        self.protien = protien
        self.carbs = carbs
        self.fats = fats
        self.calCount = calCount
        self.protienCount = protienCount
        self.carbsCount = carbsCount
        self.fatsCount = fatsCount
    }
}
