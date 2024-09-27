//
//  UserStatisticsView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 07/08/24.
//

/*import SwiftUI
import SwiftData
import Charts
import HealthKit

struct UserStatisticsView: View {
    @Environment(\.modelContext) var formData
    @EnvironmentObject var vm: ScannerViewModel
    
    @State var totalCaloriesStr: String = "0"  // Consumed calories
    @State var totalBurnedCaloriesStr: String = "0"  // Burned calories
    @State private var drawingStroke = false
    @State private var foodDataStorage: [CalorieModel] = []
    @State var userWorkout: [SheduleWorkoutModel] = []
    @State var chartData: [UserChart] = []
    
    let healthStore = HKHealthStore()
    
    var body: some View {
        NavigationStack {
            List {
                // Section 1: Summary View for Calories Consumed and Burned
                Section {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.1))
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                
                                // Calorie Intake Section
                               VStack(alignment: .leading) {
                                    Text("Calories Consumed")
                                        .bold()
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.blue)
                                    HStack(spacing: 2) {
                                        Text("\(totalCaloriesStr)")
                                            .font(.title)
                                            .bold()
                                            .foregroundStyle(Color.pink)
                                        Text("Kcal")
                                            .font(.title3)
                                            .foregroundStyle(Color.pink)
                                    }
                                }
                                
                                // Calorie Outgoing Section
                                VStack(alignment: .leading) {
                                    Text("Calories Burned")
                                        .bold()
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.blue)
                                    HStack(spacing: 2) {
                                        Text("\(totalBurnedCaloriesStr)")
                                            .font(.title)
                                            .bold()
                                            .foregroundStyle(Color.green)
                                        Text("Kcal")
                                            .font(.title3)
                                            .foregroundStyle(Color.green)
                                    }
                                }
                            }.padding(.leading)
                            Spacer()
                            
                            ActivityProgressView(drawingStroke: $drawingStroke, animationDuration: 3.0)
                                .onAppear { drawingStroke.toggle() }
                        }.padding()
                    }.frame(height: 185)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: {
            requestAuthorization()
            fetchCaloriesConsumed()
            fetchCaloriesBurned()
        })
    }
}
#Preview {
    UserStatisticsView()
        .preferredColorScheme(.light)
}

extension UserStatisticsView {
    
    // Request permission to read HealthKit data
    func requestAuthorization() {
        let readDataTypes = Set([
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ])
        
        healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { success, error in
            if !success {
                print("HealthKit authorization failed.")
            }
        }
    }
    
    // Fetch calories consumed from HealthKit
    func fetchCaloriesConsumed() {
        let energyType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("No data fetched for calories consumed.")
                return
            }
            let totalCalories = sum.doubleValue(for: HKUnit.kilocalorie())
            DispatchQueue.main.async {
                totalCaloriesStr = String(Int(totalCalories))
            }
        }
        healthStore.execute(query)
    }
    
    // Fetch calories burned from HealthKit
    func fetchCaloriesBurned() {
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("No data fetched for calories burned.")
                return
            }
            let totalBurnedCalories = sum.doubleValue(for: HKUnit.kilocalorie())
            DispatchQueue.main.async {
                totalBurnedCaloriesStr = String(Int(totalBurnedCalories))
            }
        }
        healthStore.execute(query)
    }
}*/

