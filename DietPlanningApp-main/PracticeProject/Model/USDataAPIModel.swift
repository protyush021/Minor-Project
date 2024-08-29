//
//  USDataAPIModel.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 29/08/24.
//

import Foundation

struct USDAFoodSearchResponse: Decodable {
    let foods: [USDAFoodItem]
}

struct USDAFoodItem: Decodable {
    let description: String?
    let brandOwner: String?
    let foodNutrients: [USDANutrient]?

    // Add a method to convert USDAFoodItem to your FoodItem model
    func toFoodItem() -> FoodItem {
        return FoodItem(
            foodName: description ?? "Unknown",
            brandName: brandOwner,
            servingQty: nil,  // USDA data might not provide this directly
            servingUnit: nil, // Adjust as per available data
            servingWeightGrams: nil,
            nfMetricQty: nil,
            nfMetricUom: nil,
            nfCalories: foodNutrients?.first { $0.nutrientName == "Energy" }?.value,
            nfTotalFat: foodNutrients?.first { $0.nutrientName == "Total lipid (fat)" }?.value,
            nfSaturatedFat: foodNutrients?.first { $0.nutrientName == "Fatty acids, total saturated" }?.value,
            nfCholesterol: foodNutrients?.first { $0.nutrientName == "Cholesterol" }?.value,
            nfSodium: foodNutrients?.first { $0.nutrientName == "Sodium, Na" }?.value,
            nfTotalCarbohydrate: foodNutrients?.first { $0.nutrientName == "Carbohydrate, by difference" }?.value,
            nfDietaryFiber: foodNutrients?.first { $0.nutrientName == "Fiber, total dietary" }?.value,
            nfSugars: foodNutrients?.first { $0.nutrientName == "Sugars, total including NLEA" }?.value,
            nfProtein: foodNutrients?.first { $0.nutrientName == "Protein" }?.value,
            nfPotassium: foodNutrients?.first { $0.nutrientName == "Potassium, K" }?.value,
            nfP: foodNutrients?.first { $0.nutrientName == "Phosphorus, P" }?.value
        )
    }
}

struct USDANutrient: Decodable {
    let nutrientName: String
    let value: Double?
}
