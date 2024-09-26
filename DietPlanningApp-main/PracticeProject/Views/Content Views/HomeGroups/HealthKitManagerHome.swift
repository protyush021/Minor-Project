//
//  HealthKitManagerHome.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 26/09/24.
//

import HealthKit

class HealthKitManagerHome: ObservableObject {
    private var healthStore = HKHealthStore()

    @Published var caloriesBurned: Double = 0.0

    init() {
        requestAuthorization()
        fetchCaloriesBurned()
    }

    func requestAuthorization() {
        let typesToRead: Set = [HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if !success {
                // Handle errors
            }
        }
    }

    func fetchCaloriesBurned() {
        let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!

        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            if let result = result, let sum = result.sumQuantity() {
                DispatchQueue.main.async {
                    self.caloriesBurned = sum.doubleValue(for: .kilocalorie())
                }
            }
        }

        healthStore.execute(query)
    }
}
